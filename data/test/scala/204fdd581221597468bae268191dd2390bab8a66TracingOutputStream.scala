package net.technowizardry

import java.io.OutputStream

class TracingOutputStream(inner : OutputStream) extends OutputStream {
	def write(byte : Int) {
		print(new String(Array[Byte] ( byte.toByte )))
		inner.write(byte)
	}
	override def write(bytes : Array[Byte]) {
		println(new String(bytes))
		inner.write(bytes)
	}
	override def write(bytes : Array[Byte], start : Int, length : Int) {
		println(new String(bytes, start, length))
		inner.write(bytes, start, length)
	}
	override def flush() {
		inner.flush()
	}
}