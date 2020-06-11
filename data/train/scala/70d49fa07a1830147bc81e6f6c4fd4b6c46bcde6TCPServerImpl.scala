/*
 * TCPServerImpl.scala
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

import java.nio.channels.{ClosedChannelException, AsynchronousCloseException, ServerSocketChannel}
import java.io.PrintStream
import java.net.InetSocketAddress

private[osc] final class TCPServerImpl(val channel: ServerSocketChannel, protected val config: TCP.Config)
  extends TCPChannelImpl with Server with Channel.Net.ConfigLike with ThreadedImpl {

  override def toString: String = s"${transport.name}.Server@${hashCode().toHexString}"

  private val connSync    = new AnyRef
  private var connections = Set.empty[TCP.Client]

  type Connection = TCP.Client

  def localSocketAddress: InetSocketAddress = {
    val so = channel.socket()
    new InetSocketAddress(so.getInetAddress, so.getLocalPort)
  }

  private var actionVar: Action = (_, _) => ()

  def action: Action = connSync.synchronized(actionVar)

  def action_=(value: Action): Unit = connSync.synchronized {
    actionVar = value
    connections.foreach { c =>
      c.action = value(_, c)
    }
  }

  private var dumpInMode    : Dump        = Dump.Off
  private var dumpOutMode   : Dump        = Dump.Off
  private var dumpInStream  : PrintStream = Console.err
  private var dumpOutStream : PrintStream = Console.err
  private var dumpInFilter  : Dump.Filter = Dump.AllPackets
  private var dumpOutFilter : Dump.Filter = Dump.AllPackets

  private def addConnection(c: TCP.Client): Unit = connSync.synchronized {
    connections += c
    if (dumpInMode != Dump.Off) {
      c.dumpIn(dumpInMode, dumpInStream, dumpInFilter)
    }
    if (dumpOutMode != Dump.Off) {
      c.dumpOut(dumpOutMode, dumpOutStream, dumpOutFilter)
    }
    val actVal = actionVar
    c.action = actVal(_, c)
  }

  private def removeConnection(c: TCP.Client): Unit = connSync.synchronized {
    connections -= c
  }

  protected def threadLoop(): Unit =
    try {
      val sch     = channel.accept()
      val target  = sch.socket().getRemoteSocketAddress
      val conn    = new impl.TCPClientImpl(sch, target, config)
      conn.connect() // has safety check against isConnected
      addConnection(conn)

    } catch {
      case _: AsynchronousCloseException  => closedException()
      case _: ClosedChannelException      => closedException()
    }

  def connect(): Unit = if (!isConnected) startThread()

  def isConnected: Boolean = channel.isOpen && isThreadRunning

  def close(): Unit = {
    stopThread()
    channel.close()
    connSync.synchronized {
      connections.foreach { c =>
        removeConnection(c)
        c.close()
      }
    }
  }

  def dump(mode: Dump, stream: PrintStream, filter: Dump.Filter): Unit = {
    dumpIn (mode, stream, filter)
    dumpOut(mode, stream, filter)
  }

  def dumpIn(mode: Dump, stream: PrintStream, filter: Dump.Filter): Unit = connSync.synchronized {
    dumpInMode    = mode
    dumpInStream  = stream
    dumpInFilter  = filter
    connections.foreach(_.dumpIn(mode, stream, filter))
  }

  def dumpOut(mode: Dump, stream: PrintStream, filter: Dump.Filter): Unit = connSync.synchronized {
    dumpOutMode   = mode
    dumpOutStream = stream
    dumpOutFilter = filter
    connections.foreach(_.dumpOut(mode, stream, filter))
  }
}
