package org.apache.camel.example

import org.apache.camel.Exchange
import org.apache.camel.processor.aggregate.AggregationStrategy

/**
  * Created by Arpit on 27-08-2016.
  */
class NumberAggregationStrategy extends AggregationStrategy{

   def aggregate(oldExchange: Option[Exchange], newExchange: Exchange): Exchange = {

    if (!oldExchange.isDefined) {
      return newExchange
    }

    val input = newExchange.getIn.getBody(classOf[String])

    if ("STOP".equalsIgnoreCase(input)) {
      return oldExchange.get
    }

    oldExchange.get.getIn.setBody(oldExchange.get.getIn.getBody(classOf[Int]) + input.toInt)

    oldExchange.get
  }

  override def aggregate(exchange: Exchange, exchange1: Exchange): Exchange = {
    aggregate(Option(exchange),exchange1)
  }
}
