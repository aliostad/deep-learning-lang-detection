package com.pb.fundOptimizer.calculations

import funds.ExtendedDate
import funds.funds.Fund
import java.util.Date
import collection.immutable.HashMap

/**
 * Created with IntelliJ IDEA.
 * User: pb
 * Date: 10/10/12
 * Time: 7:45 AM
 * To change this template use File | Settings | File Templates.
 */
class MovingAverageCalculator {

  def calculate(funds: Array[Fund], from: ExtendedDate, to: ExtendedDate, window: Int): scala.collection.Map[Int, Array[Double]] = {
    //println("start")
    val fromDate = from.getDayCount()
    val toDate = to.getDayCount()

    require(window > 0)
    require(window <= (toDate - fromDate + 1), "require that " + window + " <= 1 + " + toDate + " - " + fromDate)

    val ma = scala.collection.mutable.LinkedHashMap[Int, Array[Double]]()

    // initial row
    var date = from.addDays(-1)
    val initialRow = new Array[Double](funds.length)
    for (day <- (0 to window - 1)) {
      date = date.addDays(1)
      for (fundind <- (0 to funds.length - 1)) {
        //println("initial loop: adding " + funds(fundind).getQuoteForDate(date).get + " to " + initialRow(fundind))
        val quote = funds(fundind).getQuoteForDate(date)
        if (quote.isDefined)
          initialRow(fundind) += quote.get
      }
    }

    var oldValues = initialRow
    var oldDate = from
    //println("Adding " + date.getDayCount() + " -> " + initialRow(0))
    ma += date.getDayCount() -> initialRow
    date = date.addDays(1)
    require(oldDate.before(date), "date: " + date.getDayCount() + ", oldDate: " + oldDate.getDayCount())
    while (!date.after(to)) {
      //println("second loop for date: " + date.toString())
      val values = new Array[Double](funds.length)
      //println("values: " + values.length + )
      for (fundind <- (0 to funds.length - 1)) {
        //println(oldValues(fundind) + " + " + funds(fundind).getQuoteForDate(date).get + " - " + funds(fundind).getQuoteForDate(oldDate).get
        // + " = " + (oldValues(fundind) + funds(fundind).getQuoteForDate(date).get - funds(fundind).getQuoteForDate(oldDate).get))
        //println("values.length: " + values.length + ", oldValues.length: " + oldValues.length)
        //println("date: " + date.getDayCount() + ", oldDate: " + oldDate.getDayCount())
        val quote = funds(fundind).getQuoteForDate(date)
        val oldQuote = funds(fundind).getQuoteForDate(oldDate)
        if (oldQuote.isDefined && quote.isDefined)
          values(fundind) = oldValues(fundind) + quote.get - oldQuote.get
      }
      //values.foreach(value => print(" " + value))
      //println
      //println("Adding " + date.getDayCount() + " -> " + values(0))
      ma += date.getDayCount() -> values

      oldDate = oldDate.addDays(1)
      date = date.addDays(1)
      oldValues = values
    }

    // divide by window
    return ma.mapValues(row => {
      row.map(value => value / window)
    })
  }
}
