package popeye.pipeline.compression

import java.io.{DataOutputStream, OutputStream}
import org.xerial.snappy.{Snappy => SnappyJava}
import popeye.pipeline.snappy.Crc32C
import scala.annotation.tailrec

/**
 * @author Andrey Stepachev
 */
class SnappyStreamOutputStream(inner: DataOutputStream) extends OutputStream {

  import SnappyDecoder._

  writeBlockHeader(identifierChunk, streamIdentifier.length)
   inner.write(streamIdentifier)

   private def writeBlockHeader(blockType: Int, len: Int) {
     inner.write(blockType & 0xFF)
     inner.write(len & 0xFF)
     inner.write((len >> 8) & 0xFF)
     inner.write((len >> 16) & 0xFF)
   }

   private def writeCrc(crc: Int) {
     inner.write(crc & 0xFF)
     inner.write((crc >> 8) & 0xFF)
     inner.write((crc >> 16) & 0xFF)
     inner.write((crc >> 32) & 0xFF)
   }

   private[this] val oneByte = new Array[Byte](1)

   def write(b: Int) {
     oneByte(0) = (b & 0xff).toByte
     write(oneByte, 0, 1)
   }

   override def write(b: Array[Byte], off: Int, len: Int): Unit = {
     writeBlocks(b, off, len)
   }

   @tailrec
   private def writeBlocks(b: Array[Byte], off: Int, len: Int): Unit = {
     val actualLen = Math.min(chunkMax, len)
     val arr = new Array[Byte](SnappyJava.maxCompressedLength(actualLen))
     val compressed = SnappyJava.compress(b, off, actualLen, arr, 0)
     if (compressed < actualLen * threshold) {
       writeBlockHeader(compressedChunk, compressed + 4)
       writeCrc(Crc32C.maskedCrc32c(b, off, actualLen))
       inner.write(arr, 0, compressed)
     } else {
       writeBlockHeader(uncompressedChunk, actualLen + 4)
       writeCrc(Crc32C.maskedCrc32c(b, off, actualLen))
       inner.write(b, off, actualLen)
     }
     if (actualLen < len)
       writeBlocks(b, off + actualLen, len - actualLen)
   }
 }
