package smelt.event

import org.specs.Specification

class BrokerSpecs extends Specification {

  var broker:Broker = null
  var eventBus:EventBusLocal = null

  "Broker" should {

    doAfter {
      if(broker!=null) broker.stop()
      if(eventBus!=null) eventBus.stop()
    }

    "starts and log message" in {
      broker = new Broker()
      broker.start()

      eventBus = new EventBusLocal()
      eventBus.start()

      eventBus.publish(Event("The first event published!".getBytes))

      System.out.print("> <press any key to continue>")
      System.in.read()
    }
  }
}