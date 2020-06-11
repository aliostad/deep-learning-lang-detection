package org.stash.protocol

import java.io.Serializable
import java.io.ByteArrayOutputStream

class StashResponse extends Serializable {

    private val buffer:ByteArrayOutputStream = new ByteArrayOutputStream()
    private val endline = "\r\n".getBytes

    def bytes:Array[Byte] = buffer.toByteArray
    def size:Int = buffer.size

    def write(message:Array[Byte]) = {
        buffer.write(message)
        buffer.write(endline)
    }

    def write(message:String) = {
        buffer.write(message getBytes)
        if (!message.contains("\r\n"))
            buffer.write(endline)
    }
}
