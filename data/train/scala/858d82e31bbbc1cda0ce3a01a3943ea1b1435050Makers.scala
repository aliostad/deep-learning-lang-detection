/*
 * Copyright 2011 David Crosson
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *   http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package fr.janalyse.series

import collection.immutable.TreeMap
import math._

/**
  * Unik content series by time period, 1 object will be counted only once for each period
  * @author David Crosson
  */

class UnikSeriesMaker[US](
     val name:String,
     val tm:TimeModel,
     val series:Series[CountCell],
     protected val unikBackend:Map[Long, Set[US]]=TreeMap.empty[Long,Set[US]] ) {

  def manage[N<%Number](time:N, ob:US):UnikSeriesMaker[US] = {
    val reftime = tm.referenceTime(time.longValue)
    val set = unikBackend.getOrElse(reftime, Set.empty[US])
    if (! (set contains ob)) {
         val updatedSeries  = series << reftime -> 0 // Will do +1
         val updatedBackend = unikBackend + (reftime -> (set + ob))
         new UnikSeriesMaker[US](name, tm, updatedSeries, updatedBackend)
    } else this
  }
}

object UnikSeriesMaker {
  def apply[US](name:String)(implicit builder:CellBuilder[CountCell]) = new UnikSeriesMaker[US](name, 1, Series[CountCell](name, 1))
  def apply[US](name:String, timeModel:TimeModel)(implicit builder:CellBuilder[CountCell]) = new UnikSeriesMaker[US](name, timeModel, Series[CountCell](name, timeModel))    
}


protected trait ManageDistribution {
  protected def computeToAdd[N<%Number, M<%Number]
            (series:Series[AddCell],
             givenTime:N, 
             givenDuration:M, 
             distributeFactor:Double=1d) = {
    val tm = series.tm
    val name = series.name
    val time     = givenTime.longValue
    var toadd    = Series[AddCell](name,tm)
    var period   = tm.granularityAt(time.longValue)
    var itime    = tm.referenceTime(time.longValue)
    var remain   = period - time % period
    var duration = givenDuration.longValue
    if (remain > 0L) {
      period = tm.granularityAt(itime)
      toadd <<= itime -> min(remain, duration)*distributeFactor
      itime+=period
      duration-=min(remain,duration)
    }
    while(duration>period) {
      period = tm.granularityAt(itime)
      toadd <<= itime->period*distributeFactor
      itime+=period
      duration-=period
    }
    if (duration>0) toadd <<= itime -> duration*distributeFactor
    
    toadd
  }
}

/**
  * Busy task series - count number of "task" which are simultaneously executed
  * @author David Crosson
  */
class BusySeriesMaker(
     val name:String,
     val tm:TimeModel,
     backend:Series[AddCell]) extends ManageDistribution {

  def manage[N<%Number, M<%Number](givenTime:N, givenDuration:M) = {
    val toadd = computeToAdd(backend, givenTime, givenDuration)    
    new BusySeriesMaker(name, tm, backend <<< toadd)
  }
  def series:Series[CalcCell] = backend / tm.period //TODO
}

object BusySeriesMaker {
  def apply(name:String)(implicit builder:CellBuilder[AddCell]) = new BusySeriesMaker(name, 1, Series[AddCell](name, 1))
  def apply(name:String, timeModel:TimeModel)(implicit builder:CellBuilder[AddCell]) = new BusySeriesMaker(name, timeModel, Series[AddCell](name, timeModel))    
}


/**
  * Distribution series - Distribute a value uniformely from givenTime 
  *    and for givenDuration the distribution is applied on each discrete
  *    point of the timerange.
  *    
  * @author David Crosson
  */
class DistributionSeriesMaker(
     val name:String,
     val tm:TimeModel,
     val series:Series[AddCell]) extends ManageDistribution {

  def manage[N<%Number, M<%Number, L<%Number]
            (givenTime:N, givenDuration:M, toDistribute:L) = {
    val weight = toDistribute.doubleValue / givenDuration.doubleValue
    val toadd = computeToAdd(series, givenTime, givenDuration, weight)
    new DistributionSeriesMaker(name, tm, series <<< toadd)
  }
}

object DistributionSeriesMaker {
  def apply(name:String)(implicit builder:CellBuilder[AddCell]) = new DistributionSeriesMaker(name, 1, Series[AddCell](name, 1))
  def apply(name:String, timeModel:TimeModel)(implicit builder:CellBuilder[AddCell]) = new DistributionSeriesMaker(name, timeModel, Series[AddCell](name, timeModel))    
}
