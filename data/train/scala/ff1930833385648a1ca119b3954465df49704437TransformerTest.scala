package org.github.sammyrulez.talius

import org.scalatest.{FlatSpec, Matchers}

/**
  * Created by sam on 07/04/16.
  */
class TransformerTest  extends FlatSpec with Matchers {

  def beDistiguish(s:String):String = "Mr " + s

  val eventName: String = "sayHello"

  val broker:Broker[String,String] = new Broker[String,String](new MutableInMemoryBackend[String,String],
    transformers = List((eventName,beDistiguish(_)))
   )



  "A Broker" should "accept transformations for subscribers " in {

    broker.subscribe(eventName, name => println(s"Hello $name" ))
    broker.publish(eventName,"Darcy")

  }

}
