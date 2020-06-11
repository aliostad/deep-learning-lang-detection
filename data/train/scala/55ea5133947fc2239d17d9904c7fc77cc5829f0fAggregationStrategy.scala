/*
 *
 *  Copyright 2010-2014 Crossing-Tech SA, EPFL QI-J, CH-1015 Lausanne, Switzerland.
 *  All rights reserved.
 *
 * ==================================================================================
 */

package io.xtech.babel.camel.model

import org.apache.camel.Exchange
import org.apache.camel.processor.aggregate.AggregationStrategy

/**
  * An implementation of the fold operation for camel using an Aggregation Strategy
  * @param seed the initial value.
  * @param fold the fold function
  * @tparam I the input type.
  * @tparam O the output type.
  */
class FoldBodyAggregationStrategy[I, O](seed: O, fold: (O, I) => O) extends AggregationStrategy {

  def aggregate(oldExchangeParam: Exchange, newExchange: Exchange): Exchange = {

    val oldExchange = Option(oldExchangeParam)

    oldExchange.fold {

      val newBody: I = newExchange.getIn.getBody.asInstanceOf[I]

      val newValue = fold(seed, newBody)
      newExchange.getIn.setBody(newValue)
      newExchange
    }(oldEx => {

      val oldBody: O = oldEx.getIn.getBody.asInstanceOf[O]
      val newBody: I = newExchange.getIn.getBody.asInstanceOf[I]

      val v = fold(oldBody, newBody)
      oldEx.getIn.setBody(v)
      oldEx
    })
  }

}

/**
  * An implementation of the reduce operation for camel using an Aggregation Strategy
  * @param reduce the reduce function.
  * @tparam I the input type.
  */
class ReduceBodyAggregationStrategy[I](reduce: (I, I) => I) extends AggregationStrategy {

  def aggregate(oldExchangeParam: Exchange, newExchange: Exchange): Exchange = {

    val oldExchange = Option(oldExchangeParam)

    oldExchange.fold(newExchange)(oldEx => {

      val oldBody: I = oldEx.getIn.getBody.asInstanceOf[I]
      val newBody: I = newExchange.getIn.getBody.asInstanceOf[I]

      val newValue = reduce(oldBody, newBody)

      oldEx.getIn.setBody(newValue)

      oldEx
    })
  }
}

class EnrichBodyAggregationStrategy[I, O, T](reduce: (I, O) => T) extends AggregationStrategy {
  override def aggregate(oldExchangeParam: Exchange, newExchange: Exchange): Exchange = {
    val oldExchange = Option(oldExchangeParam)

    oldExchange.fold(newExchange)(oldEx => {

      val oldBody: I = oldEx.getIn.getBody.asInstanceOf[I]
      val newBody: O = newExchange.getIn.getBody.asInstanceOf[O]

      val newValue = reduce(oldBody, newBody)

      oldEx.getIn.setBody(newValue)

      oldEx
    })
  }
}
