package org.github.sammyrulez.talius

import org.scalatest._

import scala.concurrent.Await
import scala.concurrent.duration._

class BrokerTests extends FlatSpec with Matchers {

  val broker:Broker[String,String] = new Broker[String,String](new MutableInMemoryBackend[String,String])

  val eventName: String = "sayHello"

  "A Broker" should "accept subscribers" in {

    broker.subscribe(eventName, name => println(s"Hello $name" ))

  }

  it should "publish events" in {
    broker.publish(eventName,"Sam")
  }
  it should "publish events async" in {
    broker.publish(eventName,"Saaaaaam",new Async)
  }
  it should "publish repeating events " in {
    broker.publish(eventName,"Sam Sam",new Repeating(3 seconds))
    Thread.sleep(5000)
  }
}


