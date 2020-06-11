package org.cloudio.morpheus.dci.loadBalancer.uses

import org.morpheus._
import org.morpheus.Morpheus._

import org.cloudio.morpheus.dci.loadBalancer.data._


/**
 *
 * Notes:
 * <ul>
 *  <li>The role is a projection of a data object into the scenario.</li>
 *  <li>The role should not perform any interactions since all interactions are performed through its faces.</li>
 *  <li>The role should encapsulate shared transactional data cohesive with respect to the data object.</li>
 *  <li>The role may or may not use the role's scene.</li>
 *  <li>The role "has the eyes". The eyes see the scene. The role should be able to provide a graphical representation of the scene.</li>
 *  <li>The face should not depend on the data object (Machine). They should communicate with it indirectly through the role.</li>
 * </ul>
 *
 * Created by zslajchrt on 25/06/15.
 */

@fragment
trait Storage {
  this: Machine =>

  private var recordsCounter: Int = 0
  private var replicasCounter: Int = 0

  def storedRecords = recordsCounter

  def replicatedRecords = replicasCounter
  
  def storageName = machineName

  protected def storeData(record: Array[Byte]): Unit = {
    appendRecord("mainStorage", record)
    recordsCounter += 1
  }

  protected def storeReplica(replica: Array[Byte]): Unit = {
    appendRecord("secondaryStorage", replica)
    replicasCounter += 1
  }

  protected def readLastRecords(recordCount: Int): List[Array[Byte]] = {
    readLastRecords("mainStorage", recordCount)
  }

}

@fragment
trait StorageAsReplicator {
  this: Storage with StorageScene =>

  def replicate(batch: List[Array[Byte]]) {
    for (record <- batch) {
      storeReplica(record)
    }
    loadBalancer.onMonitorEvent(ReplicasReceived(storageName, batch.size))
  }
}

@dimension
trait DataConsumer {
  def consume(data: Array[Byte]): Unit
}

// a face
@fragment
trait StorageAsConsumer extends DataConsumer {
  this: Storage with StorageScene =>

  private var replicationBatchCounter = 0

  override def consume(record: Array[Byte]): Unit = {
    storeData(record)

    replicationBatchCounter += 1

    // todo: introduce a constant in the storage scene
    if (replicationBatchCounter == 2) {
      val batch = readLastRecords(2)
      otherStorage.replicate(batch)
      loadBalancer.onMonitorEvent(ReplicasSent(storageName, batch.size))
      replicationBatchCounter = 0
    }

  }
}

// a role
@fragment
trait LoadBalancer {
  this: Machine =>

  protected var succeededRecordsCounter = 0
  private var failedRecordsCounter = 0

  def succeededRecords = succeededRecordsCounter

  def failedRecords = failedRecordsCounter

  def balancerName = machineName

  protected def enqueueRecord(failedRecord: Array[Byte], primaryCause: Throwable, secondaryCause: Throwable) {
    appendRecord("failedRecords", failedRecord)
    failedRecordsCounter += 1
  }

}

@fragment
trait LoadBalancerAsConsumer extends DataConsumer {

  this: LoadBalancer with LoadBalancerScene =>

  private var lastDir = 0

  override def consume(record: Array[Byte]): Unit = {
    // Here some data evaluation could happen. The result could affect the choice.
    lastDir = (lastDir + 1) % 2
    val (consumer1, consumer2) = if (lastDir == 0) {
      (rightStorage, leftStorage)
    } else {
      (leftStorage, rightStorage)
    }
    try {
      consumer1.consume(record)
      succeededRecordsCounter += 1
    }
    catch {
      case t: Throwable =>
        try {
          consumer2.consume(record)
          succeededRecordsCounter += 1
        }
        catch {
          case t2: Throwable =>
            enqueueRecord(record, t, t2)
        }
    }
  }
}

sealed trait MonitorEvent {
  val sendingMachineName: String
}

case class ReplicasSent(sendingMachineName: String, replicasCount: Int) extends MonitorEvent

case class ReplicasReceived(sendingMachineName: String, replicasCount: Int) extends MonitorEvent

@fragment
trait LoadMonitor {
  this: LoadBalancer with LoadBalancerScene =>

  def onMonitorEvent(event: MonitorEvent): Unit = {
    parentLoadBalancer match {
      case None =>
        println(s"Monitor Event $event at $balancerName")
      case Some(plb) => plb.onMonitorEvent(event)
    }
  }
}

// scenes

trait StorageScene {
  def otherStorage: StorageAsReplicator

  def loadBalancer: LoadMonitor
}

trait LoadBalancerScene {
  def leftStorage: DataConsumer

  def rightStorage: DataConsumer

  def parentLoadBalancer: Option[LoadBalancer with LoadMonitor]
}

// assemblage

object LoadBalancerBuilder {
  type StorageMorphType = Machine with Storage with StorageScene with (StorageAsConsumer or StorageAsReplicator)
  type LoadBalancerMorphType = Machine with LoadBalancer with LoadBalancerScene with (LoadBalancerAsConsumer or LoadMonitor)
  val storageMorphModel = parse[StorageMorphType](true)
  val loadBalancerMorphModel = parse[LoadBalancerMorphType](true)
}

import LoadBalancerBuilder._

class LoadBalancerBuilder(leftStorageMachine: Machine, rightStorageMachine: Machine, loadBalancerMachine: Machine, maybeParentLoadBalancer: => Option[LoadBalancer with LoadMonitor]) {

  private def newStorageKernel(storageMachine: Machine, storageScene: StorageScene): storageMorphModel.Kernel = {
    implicit val machineFrag = external[Machine](storageMachine)
    implicit val storageSceneFrag = external[StorageScene](storageScene)
    singleton(storageMorphModel, rootStrategy(storageMorphModel))
  }

  private def newLoadBalancerKernel: loadBalancerMorphModel.Kernel = {
    implicit val machineFrag = external[Machine](loadBalancerMachine)
    implicit val loadBalancerSceneFrag = external[LoadBalancerScene](LoadBalancerScene)
    singleton(loadBalancerMorphModel, rootStrategy(loadBalancerMorphModel))
  }

  val leftStorageMachineKernel = newStorageKernel(leftStorageMachine, LeftStorageScene)
  val rightStorageMachineKernel = newStorageKernel(rightStorageMachine, RightStorageScene)
  val loadBalancerMachineKernel = newLoadBalancerKernel

  object LeftStorageScene extends StorageScene {
    lazy val otherStorage = asMorphOf[StorageAsReplicator](rightStorageMachineKernel)
    lazy val loadBalancer = asMorphOf[LoadMonitor](loadBalancerMachineKernel)
  }

  object RightStorageScene extends StorageScene {
    lazy val otherStorage = asMorphOf[StorageAsReplicator](leftStorageMachineKernel)
    lazy val loadBalancer = asMorphOf[LoadMonitor](loadBalancerMachineKernel)
  }

  object LoadBalancerScene extends LoadBalancerScene {
    lazy val leftStorage = asMorphOf[DataConsumer](leftStorageMachineKernel)
    lazy val rightStorage = asMorphOf[DataConsumer](rightStorageMachineKernel)
    lazy val parentLoadBalancer = maybeParentLoadBalancer
  }

  lazy val loadBalancer = asMorphOf[DataConsumer](loadBalancerMachineKernel)

}


sealed trait Node[T] {
  val value: T
}

case class LoadBalancerNode[T](children: Either[(StorageNode[T], StorageNode[T]), (LoadBalancerNode[T], LoadBalancerNode[T])], value: T) extends Node[T]

case class StorageNode[T](value: T) extends Node[T]

class NetworkBuilder(rootMachineNode: LoadBalancerNode[Machine]) {

  class ParentLoadBalancerScene(leftConsumer: => DataConsumer, rightConsumer: => DataConsumer, maybeParentLoadBalancer: => Option[LoadBalancer with LoadMonitor]) extends LoadBalancerScene {
    lazy val leftStorage = leftConsumer
    lazy val rightStorage = rightConsumer
    lazy val parentLoadBalancer = maybeParentLoadBalancer
  }

  private def newLoadBalancerKernel(loadBalancerMachine: Machine, loadBalancerScene: LoadBalancerScene): loadBalancerMorphModel.Kernel = {
    implicit val machineFrag = external[Machine](loadBalancerMachine)
    implicit val loadBalancerSceneFrag = external[LoadBalancerScene](loadBalancerScene)
    singleton(loadBalancerMorphModel, rootStrategy(loadBalancerMorphModel))
  }

  class Traverser(loadBalancerNode: LoadBalancerNode[Machine], maybeParentTraverser: => Option[Traverser]) {

    lazy val loadBalancerKernel: loadBalancerMorphModel.Kernel = {

      val LoadBalancerNode(children, loadBalancerMachine) = loadBalancerNode

      def maybeParentLoadBalancer() = {
        maybeParentTraverser match {
          case None => None
          case Some(parentTraverser) => Some(asMorphOf[LoadBalancer with LoadMonitor](parentTraverser.loadBalancerKernel))
        }
      }

      children match {
        case Left((leftStorageNode, rightStorageNode)) =>
          val lbb = new LoadBalancerBuilder(leftStorageNode.value, rightStorageNode.value, loadBalancerMachine, maybeParentLoadBalancer())
          lbb.loadBalancerMachineKernel

        case Right((leftLoadBalancerNode, rightLoadBalancerNode)) =>
          val leftTraverser = new Traverser(leftLoadBalancerNode, Some(this))
          val rightTraverser = new Traverser(rightLoadBalancerNode, Some(this))
          newLoadBalancerKernel(loadBalancerMachine, new ParentLoadBalancerScene(leftTraverser.loadBalancerAsConsumer, rightTraverser.loadBalancerAsConsumer, maybeParentLoadBalancer()))
      }
    }

    lazy val loadBalancerAsConsumer = asMorphOf[DataConsumer](loadBalancerKernel)
  }

  val rootTraverser = new Traverser(rootMachineNode, None)
}

object App {

  def main(args: Array[String]) {

    //    val loadBalancer = new LoadBalancerBuilder(
    //      new MachineMock("leftStorageMachine"),
    //      new MachineMock("rightStorageMachine"),
    //      new MachineMock("loadBalancerMachine"), None).loadBalancer
    //

    val lbNode1 = LoadBalancerNode[Machine](
      Left(StorageNode(MachineMock("leftStorageMachine1")), StorageNode(MachineMock("rightStorageMachine1"))), MachineMock("loadBalancerMachine1"))
    val lbNode2 = LoadBalancerNode[Machine](
      Left(StorageNode(MachineMock("leftStorageMachine2")), StorageNode(MachineMock("rightStorageMachine2"))), MachineMock("loadBalancerMachine2"))
    val lbNode3 = LoadBalancerNode[Machine](Right(lbNode1, lbNode2), MachineMock("loadBalancerMachine3"))

    val nb = new NetworkBuilder(lbNode3)
    val loadBalancer = nb.rootTraverser.loadBalancerAsConsumer

    for (i <- 0 until 100) {
      loadBalancer.consume("abc".getBytes)
    }
  }

}