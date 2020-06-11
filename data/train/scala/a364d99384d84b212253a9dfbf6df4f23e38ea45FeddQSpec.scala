package fedd

import cypress.io.fedd.FeddQ
import cypress.io.fedd.DataFormatHelpers._
import cypress.model.{Experiment, Computer}
import generated._
import org.scalatest.FlatSpec
import org.scalatest.time.{Span,Seconds}
import org.scalatest.concurrent.ScalaFutures

trait FeddIOTest extends ScalaFutures {
  implicit override val patienceConfig =
    PatienceConfig(timeout=Span(47, Seconds))
}

class NewDeleteSpec extends FlatSpec with FeddIOTest {
  
  "Multistatus" should "list experiment info" in {
    whenReady(FeddQ.multiStatus){ 
      _.info.map(showExpInfo).foreach(println)
    }
  }
  
  "New" should "create empty experiment called abby" in {
    whenReady(FeddQ.`new`("abby")){ x => println(x.dumpString) }
  }
  
  "Terminate" should "remove the empty experiment called abby" in {
    whenReady(FeddQ.terminate("abby")){
      x => println(x.dumpString)
    }
  }
}

class CreateSpec extends FlatSpec with FeddIOTest {
  
  val exp = Experiment(name="abby")
  exp.computers += Computer("murphy")
  
  "Create" should "start an experiment called abby" in {
    
    val f = FeddQ.create(exp)

    whenReady(f) {
      x => x.status match {
        case Starting => println(x.dumpString)
        case _ => fail(x.dumpString)
      }
    }
   
  }
  
}

