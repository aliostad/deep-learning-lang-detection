import org.apache.uima.UIMAFramework
import org.apache.uima.aae.client.UimaAsynchronousEngine
import org.apache.uima.adapter.jms.client.BaseUIMAAsynchronousEngine_impl
import org.apache.uima.resourceSpecifier.factory.SerializationStrategy
import org.apache.activemq.broker.BrokerService
import scala.concurrent._
import scala.concurrent.duration._
import scala.concurrent.ExecutionContext.Implicits.global
import uimaAS._
import org.apache.uima.jcas.JCas
import java.net.URI

class UimaAsync(val config: UimaAppContext = UimaAppContext()) {
  val engine: UimaAsynchronousEngine = new BaseUIMAAsynchronousEngine_impl
  val configMap = config.toMap
  var springContainerId: Option[String] = None

  def start[T](corpus: Corpus, process: Process, block: Util.Block[T], collectionTotal: Option[Int] = None): Future[Util.Results[T]] = {
    if (UimaAsync.broker.isEmpty) {
      throw new IllegalStateException("Broker must be started before instantiating UimaAsync")
    }

    val collectionReader = UIMAFramework.produceCollectionReader(corpus.reader)
    val statusListener = new UimaStatusCallbackListener(this.engine, block, collectionTotal = collectionTotal)
    engine.setCollectionReader(collectionReader)
    engine.addStatusCallbackListener(statusListener)

    val deployConfig = UimaAsyncDeploymentConfig(engineDescs = process.engines, appCtx = config)
    val deployXML = deployConfig.toXML()

    springContainerId = Some(engine.deploy(deployXML, configMap))

    engine.initialize(configMap)
    engine.process()

    val f = statusListener.promisedResults.future

    f onSuccess {
      case _ => stop()
    }

    f
  }

  def stop(): Unit = {
    springContainerId.foreach { springId => engine.undeploy(springId) }
    engine.stop()
  }
}

object UimaAsync {
  val uri = new URI("tcp://localhost:61616")
  var broker: Option[BrokerService] = None

  def start(): Unit = {
    if (broker.isEmpty) {
      val brokerService = new BrokerService
      brokerService.setBrokerName("localhost")
      brokerService.setUseJmx(false)
      brokerService.addConnector(uri.toString)
      brokerService.start()
      broker = Some(brokerService)
    }
  }

  def stop(): Unit = broker.foreach { b => b.stop() }
}
