/*
 * La Trobe University - Distributed Deep Learning System
 * Copyright 2015 Matthias Langer (t3l@threelights.de)
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

package edu.latrobe.blaze.gradientchecks

import edu.latrobe._
import edu.latrobe.time._
import edu.latrobe.blaze._
import scala.util.hashing._

abstract class NumericalGradientCheck[TBuilder <: NumericalGradientCheckBuilder[_]]
  extends GradientCheckEx[TBuilder] {

  final val epsilon
  : Real = builder.epsilon

  final val dumpProgressInterval
  : TimeSpan = builder.dumpProgressInterval

}

abstract class NumericalGradientCheckBuilder[TThis <: NumericalGradientCheckBuilder[_]]
  extends GradientCheckExBuilder[TThis] {

  final private var _epsilon
  : Real = if (Real.size == 4) 0.001f else 0.0001f

  final def epsilon
  : Real = _epsilon

  final def epsilon_=(value: Real)
  : Unit = {
    require(value >= Real.epsilon)
    _epsilon = value
  }

  final def setEpsilon(value: Real)
  : TThis = {
    epsilon_=(value)
    repr
  }

  final private var _dumpProgressInterval
  : TimeSpan = TimeSpan.infinite

  final def dumpProgressInterval
  : TimeSpan = _dumpProgressInterval

  final def dumpProgressInterval_=(value: TimeSpan)
  : Unit = {
    require(value != null)
    _dumpProgressInterval = value
  }

  final def setReportingInterval(value: TimeSpan)
  : TThis = {
    dumpProgressInterval_=(value)
    repr
  }

  override def hashCode()
  : Int = {
    var tmp = super.hashCode()
    tmp = MurmurHash3.mix(tmp, _epsilon.hashCode())
    tmp = MurmurHash3.mix(tmp, _dumpProgressInterval.hashCode())
    tmp
  }

  override protected def doEquals(other: Equatable)
  : Boolean = super.doEquals(other) && (other match {
    case other: NumericalGradientCheckBuilder[_] =>
      _epsilon              == other._epsilon &&
      _dumpProgressInterval == other._dumpProgressInterval
    case _ =>
      false
  })

  override def copyTo(other: InstanceBuilder): Unit = {
    super.copyTo(other)
    other match {
      case other: NumericalGradientCheckBuilder[TThis] =>
        other._epsilon              = _epsilon
        other._dumpProgressInterval = _dumpProgressInterval
      case _ =>
    }
  }

}