package signals

import java.util

import demo.util.ProcessState.{ACTIVE, COMPLETED}
import demo.util._
import org.kie.api.runtime.KieSession
import org.kie.api.runtime.manager.RuntimeEngine
import org.kie.api.runtime.process.ProcessInstance
import org.specs2.mutable.Specification
import scala.collection.JavaConversions._
import scala.concurrent.duration._
import scala.concurrent._
import scala.concurrent.ExecutionContext.Implicits.global

class SignalSpec extends Specification with IgnoreZeroResourceTx with KieTestContext  with ProcessMatchers{

  sequential

  override val config = KBaseSession("signalDemo", "mysession")

  "foo smoke test" >> { implicit rte: RuntimeEngine =>
    val s = rte.getKieSession
    val params: Map[String, AnyRef] = Map("itemType" -> "foo")
    val noParams: Map[String, AnyRef] = Map()
    val fooProcess = s.startProcess("signals.FooProcess", noParams)
    process(fooProcess) must be(ACTIVE)
    val mainProcess = s.startProcess("signals.MainSignallingProcess", params)
    Thread.sleep(2000) // time for mailProcess to send the signal
    process(fooProcess) must be(COMPLETED)
  }

  "foo timeout" >> { implicit rte: RuntimeEngine =>
    val s = rte.getKieSession
    val noParams: Map[String, AnyRef] = Map()
    val fooProcess = s.startProcess("signals.FooProcess", noParams)
    process(fooProcess) must be(ACTIVE)
    Thread.sleep(4000) // timout in foo process
    process(fooProcess) must be(COMPLETED)
  }

  "non foo smoke test" >> { implicit rte: RuntimeEngine =>
    val s = rte.getKieSession
    val params: Map[String, AnyRef] = Map("itemType" -> "bar")
    val pi = s.startProcess("signals.MainSignallingProcess", params)
    process(pi) must be(COMPLETED)
  }
}
