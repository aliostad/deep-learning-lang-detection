package flumina.client

import akka.actor.ActorSystem
import akka.pattern._
import akka.util.Timeout
import cats.implicits._
import cats.kernel.Monoid
import cats.~>
import flumina._
import scodec.bits.BitVector

import scala.concurrent.{ExecutionContext, Future}

final class AkkaInterpreter(settings: KafkaSettings)(implicit S: ActorSystem, T: Timeout, EC: ExecutionContext) extends (KafkaA ~> Future) {

  private val connectionPool =
    S.actorOf(KafkaConnectionPool.props(settings.bootstrapBrokers, settings.connectionsPerBroker))
  private val int = new BasicInterpreter[Future](x => connectionPool.ask(x).mapTo[BitVector])
  private val defaultContext =
    KafkaContext(broker = KafkaBroker.AnyNode, settings = settings.operationalSettings)

  private val controller = UVar(Option.empty[KafkaBroker])
  private val byTopic =
    MapVar(Map.empty[String, Map[Int, KafkaBroker]])(MapVar.updates.appendAndOmit)
  private val byGroup = MapVar(Map.empty[String, KafkaBroker])(MapVar.updates.appendAndOmit)

  private def runWithBroker[A](dsl: KafkaA[A], broker: KafkaBroker) =
    int(dsl).run(defaultContext.copy(broker = broker))

  private val retryCount   = defaultContext.settings.retryMaxCount
  private val retryBackoff = defaultContext.settings.retryBackoff

  private def getController =
    controller.update {
      case None =>
        getMetadata(Seq.empty).map(x => Option(KafkaBroker.Node(x.controller.host, x.controller.port)))
      case Some(b) => Future.successful(Option(b))
    } flatMap {
      _.fold[Future[KafkaBroker]](Future.failed(new Exception("No broker found")))(Future.successful)
    }

  private def updateController =
    controller
      .update(_ => getMetadata(Seq.empty).map(x => Option(KafkaBroker.Node(x.controller.host, x.controller.port))))
      .flatMap(_.fold[Future[KafkaBroker]](Future.failed(new Exception("No broker found")))(Future.successful))

  private def runEitherCall[A](broker: KafkaBroker, dsl: KafkaA[KafkaResult Either A]) = {
    def run(tries: Int, lastError: KafkaResult): Future[KafkaResult Either A] = {
      if (tries < retryCount) {
        for {
          result <- runWithBroker(dsl, broker)
          next <- result match {
            case Left(err) if KafkaResult.canRetry(err) =>
              FutureUtils.delayFuture(retryBackoff, run(tries + 1, err))
            case Left(err) =>
              Future.successful(Left(err))
            case Right(res) =>
              Future.successful(Right(res))
          }
        } yield next
      } else {
        Future.successful(Left(lastError))
      }
    }

    run(0, KafkaResult.NoError)
  }

  private def runGroupCall[A](groupId: String, dsl: KafkaA[A]) =
    for {
      broker <- getBrokerByGroupId(groupId)
      result <- runWithBroker(dsl, broker)
    } yield result

  private def runGroupEitherCall[A](groupId: String, dsl: KafkaA[KafkaResult Either A]) =
    for {
      broker <- getBrokerByGroupId(groupId)
      result <- runEitherCall(broker, dsl)
    } yield result

  private def runTopicPartitionValues[I, O](
      initialRequest: Traversable[TopicPartitionValue[I]],
      prg: Traversable[TopicPartitionValue[I]] => KafkaA[TopicPartitionValues[O]]
  ): Future[TopicPartitionValues[O]] = {
    def split[A](brokerMap: Map[String, Map[Int, KafkaBroker]], values: Traversable[TopicPartitionValue[A]]): Map[KafkaBroker, Traversable[TopicPartitionValue[A]]] = {

      def getBroker(topicPartition: TopicPartition) =
        (for {
          topic  <- brokerMap.get(topicPartition.topic)
          broker <- topic.get(topicPartition.partition)
        } yield broker) getOrElse KafkaBroker.AnyNode

      values
        .groupBy(_.topicPartition)
        .foldLeft(Map.empty[KafkaBroker, Traversable[TopicPartitionValue[A]]]) {
          case (acc, (topicPartition, entries)) =>
            acc.updatedValue(getBroker(topicPartition), Nil)(_ ++ entries)
        }
    }

    def rerun(retries: Int, originalRequest: Traversable[TopicPartitionValue[I]], resp: TopicPartitionValues[O]) =
      for {
        newBrokerMap <- updateTopics(resp.canBeRetried.map(_.topic))
        _            <- FutureUtils.delay(retryBackoff)
        retryResults <- Monoid.combineAll {
          split(newBrokerMap, originalRequest.filter(x => resp.canBeRetried.contains(x.topicPartition)))
            .map {
              case (newBroker, newRequest) =>
                Future.successful(resp.resultsExceptWhichCanBeRetried) |+| run(retries = retries + 1)(broker = newBroker, request = newRequest)
            }
        }
      } yield retryResults

    def run(retries: Int)(broker: KafkaBroker, request: Traversable[TopicPartitionValue[I]]): Future[TopicPartitionValues[O]] = {
      for {
        resp <- runWithBroker(prg(request), broker)
        res <- if (resp.canBeRetried.nonEmpty && retries < retryCount) {
          rerun(retries, request, resp)
        } else {
          Future.successful(resp)
        }
      } yield res
    }

    byTopic.get.flatMap(brokerMap =>
      Monoid.combineAll(split(brokerMap, initialRequest).map {
        case (broker, values) => run(0)(broker, values)
      }))
  }

  private def updateTopics(topics: Set[String]): Future[Map[String, Map[Int, KafkaBroker]]] = {

    def metadataBroker(broker: KafkaBroker, topicsToUpdate: Set[String]) =
      runWithBroker(KafkaA.GetMetadata(topicsToUpdate), broker)
        .map { m =>
          val topicPartitionBrokers = for {
            topic  <- m.topics.toList
            broker <- m.brokers.find(_.nodeId == topic.result.leader).toList
          } yield (topic.topicPartition.topic, topic.topicPartition.partition, KafkaBroker.Node(broker.host, broker.port): KafkaBroker)

          topicPartitionBrokers
            .groupBy(x => x._1)
            .map { case (topic, values) => topic -> Option(values.map(y => y._2 -> y._3).toMap) }
            .toList
        }

    byTopic.updateSubset(topics, topicsToUpdate => getController.flatMap(controller => metadataBroker(controller, topicsToUpdate)))
  }

  private def groupCoordinator(groupId: String) =
    runEitherCall(defaultContext.broker, KafkaA.GroupCoordinator(groupId))
      .map(_.toOption.map(b => KafkaBroker.Node(b.host, b.port)))

  private def getBrokerByGroupId(groupId: String) =
    byGroup
      .getOrElseUpdate(groupId, groupCoordinator)
      .flatMap(_.fold[Future[KafkaBroker]](Future.failed(new Exception("No broker found")))(Future.successful))

  private def getMetadata(topics: Traversable[String]) =
    runWithBroker(KafkaA.GetMetadata(topics), KafkaBroker.AnyNode)

  private def runControllerCall(dsl: KafkaA[List[TopicResult]]) = {
    def rerun =
      for {
        newBroker <- updateController
        res       <- runWithBroker(dsl, newBroker)
      } yield res

    for {
      currentController <- getController
      resp              <- runWithBroker(dsl, currentController)
      res <- if (resp.exists(_.kafkaResult == KafkaResult.NotController)) rerun
      else Future.successful(resp)
    } yield res
  }

  override def apply[A](fa: KafkaA[A]): Future[A] = fa match {

    case r: KafkaA.OffsetsFetch  => runGroupCall(r.groupId, r)
    case r: KafkaA.OffsetsCommit => runGroupCall(r.groupId, r)
    case r: KafkaA.ProduceN =>
      runTopicPartitionValues[Record, Long](r.values, (v) => KafkaA.ProduceN(r.compression, v))
    case r: KafkaA.ProduceOne =>
      runTopicPartitionValues[Record, Long](Seq(r.values), v => KafkaA.ProduceOne(v.headOption.getOrElse(sys.error("Impossible"))))
    case r: KafkaA.JoinGroup        => runGroupEitherCall(r.groupId, r)
    case r: KafkaA.SynchronizeGroup => runGroupEitherCall(r.groupId, r)
    case r: KafkaA.LeaveGroup       => runGroupEitherCall(r.groupId, r)
    case r: KafkaA.Heartbeat        => runGroupEitherCall(r.groupId, r)
    case r: KafkaA.Fetch =>
      runTopicPartitionValues[Long, OffsetValue[Record]](r.values, v => KafkaA.Fetch(v))
    case r: KafkaA.GroupCoordinator =>
      runEitherCall(KafkaBroker.AnyNode, KafkaA.GroupCoordinator(r.groupId))
    case r: KafkaA.GetMetadata  => getController.flatMap(b => runWithBroker(r, b))
    case r: KafkaA.CreateTopics => runControllerCall(r)
    case r: KafkaA.DeleteTopics => runControllerCall(r)
    case r: KafkaA.DescribeGroups =>
      for {
        brokerMap <- Future.traverse(r.groupIds)(groupId => getBrokerByGroupId(groupId).map(broker => broker -> groupId))
        multiMap = brokerMap.foldLeft(Map.empty[KafkaBroker, Set[String]]) {
          case (acc, (broker, groupId)) =>
            acc.updatedValue(broker, Set.empty)(_ + groupId)
        }
        groups <- Future.traverse(multiMap.toList) {
          case (broker, groupIds) => runWithBroker(KafkaA.DescribeGroups(groupIds), broker)
        }
      } yield groups.flatten

    case KafkaA.ListGroups =>
      for {
        metadata <- getMetadata(Set())
        res      <- Monoid.combineAll(metadata.brokers.map(b => runEitherCall(KafkaBroker.Node(b.host, b.port), KafkaA.ListGroups)))
      } yield res

    case KafkaA.ApiVersions => runWithBroker(KafkaA.ApiVersions, KafkaBroker.AnyNode)
  }
}
