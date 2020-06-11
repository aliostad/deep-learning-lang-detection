package jp.kenichi.text

import scala.collection.mutable.Buffer
import java.io.{InputStream, ByteArrayInputStream}

object HexDump {
	def dump(in: InputStream) = {
		val sb = new StringBuilder
		var count = 0

		val buf = Buffer[Int]()
		def appendBufAsText {
			sb ++= "  "
			buf.foreach { bt =>
				if (bt >= 0x20 && bt <= 0x7e)
					sb += bt.toChar
				else
					sb += '.'
			}
		}

		Iterator.continually(in.read).takeWhile(_ != -1).foreach { bt =>
			if (count % 16 == 0) {
				if (count > 0) {
					appendBufAsText
					buf.clear
					sb += '\n'
				}
				sb ++= f"$count%08x  "

			} else {
				if (count % 8 == 0)
					sb += ' '
				sb += ' '
			}
			sb ++= f"${bt & 0xff}%02x"
			count += 1
			buf += bt
		}

		if (buf.nonEmpty) {
			sb ++= "   " * (16 - buf.size)
			appendBufAsText
		}

		sb.toString
	}

	def dump(bin: Seq[Byte]): String = dump(new ByteArrayInputStream(bin.toArray))
}
