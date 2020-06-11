/*
 * BidiImpl.scala
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

import java.io.PrintStream

private[osc] trait BidiImpl extends ChannelImpl with Channel.Bidi {
  protected def input : Channel
  protected def output: Channel

  final def connect(): Unit = {
    input .connect()
    output.connect()
  }

  final def close(): Unit = {
    input .close()
    output.close()
  }

  final def isConnected = input.isConnected && output.isConnected

   /** Changes the way incoming and outgoing OSC messages are printed to the standard err console.
     *	By default messages are not printed.
     *
     *  @param	mode	one of <code>kDumpOff</code> (don't dump, default),
     *					<code>kDumpText</code> (dump human readable string),
     *					<code>kDumpHex</code> (hex-dump), or
     *					<code>kDumpBoth</code> (both text and hex)
     *	@param	stream	the stream to print on
     *
     *	@see	#dumpIn( int, PrintStream )
     *	@see	#dumpOut( int, PrintStream )
     *	@see	#kDumpOff
     *	@see	#kDumpText
     *	@see	#kDumpHex
     *	@see	#kDumpBoth
     */
   final def dump(mode: Dump, stream: PrintStream, filter: Dump.Filter = Dump.AllPackets): Unit = {
     dumpIn (mode, stream, filter)
     dumpOut(mode, stream, filter)
   }

   /** Changes the way incoming messages are dumped
     *	to the console. By default incoming messages are not
     *	dumped. Incoming messages are those received
     *	by the client from the server, before they
     *	get delivered to registered <code>OSCListener</code>s.
     *
     *	@param	mode	see `dump` for details
     *	@param	stream	the stream to print on
     *
     *	@see	#dump( Dump, PrintStream, Dump.Filter )
     *	@see	#dumpOut( Dump, PrintStream, Dump.Filter )
     */
   final def dumpIn(mode: Dump, stream: PrintStream, filter: Dump.Filter): Unit =
     input.dump(mode, stream, filter)

   /** Changes the way outgoing messages are dumped
     *	to the console. By default outgoing messages are not
     *	dumped. Outgoing messages are those send via
     *	<code>send</code>.
     *
     *	@param	mode	see `dump` for details
     *	@param	stream	the stream to print on
     *
     *	@see	#dump( Dump, PrintStream, Dump.Filter )
     *	@see	#dumpIn( Dump, PrintStream, Dump.Filter )
     */
   final def dumpOut(mode: Dump, stream: PrintStream, filter: Dump.Filter): Unit =
     output.dump(mode, stream, filter)
}
