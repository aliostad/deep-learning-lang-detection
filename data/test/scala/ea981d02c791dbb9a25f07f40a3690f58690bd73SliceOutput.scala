package com.capslock.leveldb

import java.io.{DataOutput, InputStream, OutputStream}
import java.nio.ByteBuffer
import java.nio.channels.{ScatteringByteChannel, FileChannel}

/**
 * Created by capslock.
 */
abstract class SliceOutput extends OutputStream with DataOutput {
    def reset()

    def size: Int

    def writableBytes: Int

    def isWritable: Boolean

    def writeBytes(source: Slice)

    def writeBytes(source: Slice, length: Int)

    def writeBytes(source: Slice, index: Int, length: Int)

    def writeBytes(source: Array[Byte])

    def writeBytes(source: Array[Byte], sourceIndex: Int, length: Int)

    def writeBytes(source: ByteBuffer)

    def writeBytes(source: InputStream, length: Int)

    def writeBytes(source: FileChannel, position: Int, length: Int)

    def writeBytes(source: SliceInput, length: Int)

    def writeBytes(source: ScatteringByteChannel, length: Int):Int

    def writeZero(length: Int): Unit

    def slice(): Slice

    override def writeFloat(v: Float): Unit = throw new UnsupportedOperationException

    override def writeChars(s: String): Unit = throw new UnsupportedOperationException

    override def writeDouble(v: Double): Unit = throw new UnsupportedOperationException

    override def writeUTF(s: String): Unit = throw new UnsupportedOperationException

    override def writeBoolean(value: Boolean): Unit = writeByte(if (value) 1 else 0)

    override def write(value: Int): Unit = writeByte(value)

    override def writeBytes(s: String): Unit = throw new UnsupportedOperationException

    override def writeChar(v: Int): Unit = throw new UnsupportedOperationException
}
