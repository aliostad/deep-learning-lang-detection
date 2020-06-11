/*
 * ChannelImpl.scala
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
package impl

import java.io.{IOException, PrintStream}
import java.nio.ByteBuffer

private[osc] trait ChannelImpl extends Channel {
  protected def config: Channel.Config

  final def bufferSize: Int         = config.bufferSize
  final def codec     : PacketCodec = config.codec
  final def isOpen    : Boolean     = channel.isOpen
}

private[osc] trait SingleChannelImpl extends ChannelImpl {
  @volatile protected var dumpMode   : Dump         = Dump.Off
  @volatile protected var printStream: PrintStream  = Console.err
  @volatile protected var dumpFilter : Dump.Filter  = Dump.AllPackets

  final protected val bufSync = new AnyRef
  final protected val buf     = ByteBuffer.allocateDirect(config.bufferSize)

  /** Requests to connect the network channel. This may be called several
    * times, and the implementation should ignore the call when the channel
    * is already connected.
    */
  @throws(classOf[IOException])
  protected def connectChannel(): Unit

  final def dump(mode: Dump, stream: PrintStream, filter: Dump.Filter): Unit = {
    dumpMode    = mode
    printStream = stream
    dumpFilter  = filter
  }

  /** Callers should have a lock on the buffer! */
  final protected def dumpPacket(p: Packet, prefix: String): Unit =
    if ((dumpMode ne Dump.Off) && dumpFilter(p)) {
      printStream.synchronized {
        printStream.print(prefix)
        dumpMode match {
          case Dump.Text => Packet.printTextOn(p, codec, printStream)
          case Dump.Hex  => Packet.printHexOn (buf,      printStream)
          case Dump.Both => Packet.printTextOn(p, codec, printStream)
                            Packet.printHexOn (buf,      printStream)
          case _ => // satisfy compiler (Dump.Off)
        }
      }
    }
}

private[osc] trait SingleOutputChannelImpl extends SingleChannelImpl {
  final protected def dumpPacket(p: Packet): Unit = dumpPacket(p, "s: ")
}

private[osc] trait SingleInputChannelImpl extends SingleChannelImpl {
  final protected def dumpPacket(p: Packet): Unit = dumpPacket(p, "r: ")
}