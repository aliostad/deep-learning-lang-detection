package com.reactive.http.server.actor


import java.io.IOException
import java.nio.ByteBuffer
import java.nio.channels.SelectionKey.OP_WRITE
import java.nio.channels.SocketChannel

import akka.actor.ActorRef
import akka.util.ByteString

import scala.annotation.tailrec
import scala.util.control.NonFatal

object Writer {

  sealed abstract class PendingWrite {
    def commander: ActorRef

    def doWrite(): PendingWrite

    def release(): Unit // free any occupied resources
  }

  object EmptyPendingWrite extends PendingWrite {
    def commander: ActorRef = throw new IllegalStateException

    def doWrite(): PendingWrite = throw new IllegalStateException

    def release(): Unit = throw new IllegalStateException
  }

  def PendingWrite(commander: ActorRef, write: WriteCommand, channel: SocketChannel, registration: Option[ChannelRegistration]): PendingWrite = {
    @tailrec def create(head: WriteCommand, tail: WriteCommand = Write.empty): PendingWrite =
      head match {
        case Write.empty ⇒ if (tail eq Write.empty) EmptyPendingWrite else create(tail)
        case Write(data, ack) if data.nonEmpty ⇒ PendingBufferWrite(commander, data, channel, registration, ack, tail)
      }

    create(write)
  }

  def PendingBufferWrite(commander: ActorRef, data: ByteString, channel: SocketChannel, registration: Option[ChannelRegistration], ack: Event, tail: WriteCommand): PendingBufferWrite = {
    val buffer = ByteBuffer.allocate(2048)
    try {
      val copied = data.copyToBuffer(buffer)
      buffer.flip()
      new PendingBufferWrite(commander, data.drop(copied), ack, buffer, tail, channel, registration)
    } catch {
      case NonFatal(e) ⇒
        throw e
    }
  }

  class PendingBufferWrite(
                            val commander: ActorRef,
                            remainingData: ByteString,
                            ack: Any,
                            buffer: ByteBuffer,
                            tail: WriteCommand,
                            channel: SocketChannel, registration: Option[ChannelRegistration]) extends PendingWrite {

    def doWrite(): PendingWrite = {
      @tailrec def writeToChannel(data: ByteString): PendingWrite = {
        println(s"Started writing ${data}")
        channel.write(buffer) // at first we try to drain the remaining bytes from the buffer
        if (buffer.hasRemaining) {
          // we weren't able to write all bytes from the buffer, so we need to try again later
          if (data eq remainingData) this
          else new PendingBufferWrite(commander, data, ack, buffer, tail, channel, registration) // copy with updated remainingData

        } else if (data.nonEmpty) {
          buffer.clear()
          val copied = data.copyToBuffer(buffer)
          buffer.flip()
          writeToChannel(data drop copied)

        } else {
          if (!ack.isInstanceOf[NoAck]) commander ! ack
          release()
          PendingWrite(commander, tail, channel, registration)
        }
      }
      try {
        val next = writeToChannel(remainingData)
        if (next ne EmptyPendingWrite) registration.map( reg ⇒ {
          println("Enabling write interest")
          reg.enableInterest(OP_WRITE)
        })
        next
      } catch {
        case e: IOException ⇒ this
      }
    }

    override def release(): Unit = {}
  }
}