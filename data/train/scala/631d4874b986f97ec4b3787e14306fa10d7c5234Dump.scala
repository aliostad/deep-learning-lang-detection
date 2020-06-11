/*
 * Dump.scala
 * (ScalaOSC)
 *
 * Copyright (c) 2008-2015 Hanns Holger Rutz. All rights reserved.
 *
 * This software is published under the GNU Lesser General Public License v2.1+
 *
 *
 * For further information, please contact Hanns Holger Rutz at
 * contact@sciss.de
 */

package de.sciss.osc

import scala.annotation.switch

object Dump {
  def apply(id: Int): Dump = (id: @switch) match {
    case Off  .id => Off
    case Text .id => Text
    case Hex  .id => Hex
    case Both .id => Both
    case _        => throw new IllegalArgumentException(id.toString)
  }

  /** Dump mode: do not dump messages. */
  case object Off  extends Dump { final val id = 0 }

  /** Dump mode: dump messages in text formatting. */
  case object Text extends Dump { final val id = 1 }

  /** Dump mode: dump messages in hex (binary) view. */
  case object Hex  extends Dump { final val id = 2 }

  /** Dump mode: dump messages both in text and hex view. */
  case object Both extends Dump { final val id = 3 }

  type Filter = Packet => Boolean
  val AllPackets: Filter = _ => true
}
sealed trait Dump {
  val id: Int
}