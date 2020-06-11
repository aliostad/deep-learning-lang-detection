package tel.schich.webnbt

import java.io.ByteArrayOutputStream
import java.nio.ByteBuffer
import java.nio.ByteOrder.BIG_ENDIAN
import java.nio.charset.StandardCharsets

/**
  * Created by phillip on 13.02.17.
  */
object NbtNbtRenderer extends NbtRenderer[ByteBuffer] {
  override def render(compound: NbtCompound): ByteBuffer = {
    val outStream = new ByteArrayOutputStream()
    write(outStream, compound)
    ByteBuffer.wrap(outStream.toByteArray)
  }

  private def write(buffer: ByteArrayOutputStream, root: NbtCompound): Unit = {
    write(buffer, ByteBuffer.wrap(Array.ofDim(8)).order(BIG_ENDIAN), root)
  }

  private def write(buffer: ByteArrayOutputStream, aux: ByteBuffer, value: NbtValue): Unit = {
    value match {
      case NbtCompound(children) =>
        for ((key, value) <- children) {
          write(buffer, aux, value.tag.id)
          write(buffer, aux, key)
          write(buffer, aux, value)
        }
        write(buffer, aux, NbtCompound.end)
      case NbtList(tag, children) =>
        write(buffer, aux, tag)
        write(buffer, aux, children.length)
        for (child <- children) {
          write(buffer, aux, child)
        }
      case NbtByteArray(bytes) =>
        write(buffer, aux, bytes.length)
        for (byte <- bytes) {
          write(buffer, aux, byte)
        }
      case NbtIntArray(ints) =>
        write(buffer, aux, ints.length)
        for (int <- ints) {
          write(buffer, aux, int)
        }
      case NbtByte(n) =>
        write(buffer, aux, n)
      case NbtShort(n) =>
        write(buffer, aux, n)
      case NbtInt(n) =>
        write(buffer, aux, n)
      case NbtLong(n) =>
        write(buffer, aux, n)
      case NbtFloat(n) =>
        write(buffer, aux, n)
      case NbtDouble(n) =>
        write(buffer, aux, n)
      case NbtString(s) =>
        write(buffer, aux, s)
    }
  }

  private def write(buffer: ByteArrayOutputStream, aux: ByteBuffer, n: Byte): Unit = {
    buffer.write(n)
  }

  private def prepare(buffer: ByteBuffer): Unit = {
    buffer.clear()
  }

  private def write(buffer: ByteArrayOutputStream, aux: ByteBuffer, n: Short): Unit = {
    prepare(aux)
    aux.putShort(n)
    buffer.write(aux.array(), 0, java.lang.Short.BYTES)
  }

  private def write(buffer: ByteArrayOutputStream, aux: ByteBuffer, n: Int): Unit = {
    prepare(aux)
    aux.putInt(n)
    buffer.write(aux.array(), 0, java.lang.Integer.BYTES)
  }

  private def write(buffer: ByteArrayOutputStream, aux: ByteBuffer, n: Long): Unit = {
    prepare(aux)
    aux.putLong(n)
    buffer.write(aux.array(), 0, java.lang.Long.BYTES)
  }

  private def write(buffer: ByteArrayOutputStream, aux: ByteBuffer, n: Float): Unit = {
    prepare(aux)
    aux.putFloat(n)
    buffer.write(aux.array(), 0, java.lang.Float.BYTES)
  }

  private def write(buffer: ByteArrayOutputStream, aux: ByteBuffer, n: Double): Unit = {
    aux.reset()
    aux.putDouble(n)
    buffer.write(aux.array(), 0, java.lang.Double.BYTES)
  }

  private def write(buffer: ByteArrayOutputStream, aux: ByteBuffer, data: Array[Byte]): Unit = {
    buffer.write(data)
  }

  private def write(buffer: ByteArrayOutputStream, aux: ByteBuffer, s: String): Unit = {
    val bytes = s.getBytes(StandardCharsets.UTF_8)
    write(buffer, aux, bytes.length.toShort)
    write(buffer, aux, bytes)
  }
}
