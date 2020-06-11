package fr.jbu.asyncperf.core.dump.log

import fr.jbu.asyncperf.core.dump.Dump
import fr.jbu.asyncperf.core.injector.{Response, Request, InjectorResult}
import java.nio.file.{StandardOpenOption, Paths, Path}
import java.nio.ByteBuffer
import fr.jbu.asyncperf.util.nio.ByteBufferWriter

/**
 * THIS CLASS IS NOT THREADSAFE. ONE INSTANCE MUST BE USED ONLY BY ONE REPORTING ACTOR
 *
 * Dump request --> Response to Yaml
 */
class XmlDump(dumpFilePath: String, dumpBody: Boolean) extends Dump {

  val filePath: Path = Paths.get(dumpFilePath)
  filePath.exists match {
    case false => {

    }
    case true => {
      filePath.delete
    }
  }
  val channel = filePath.newByteChannel(StandardOpenOption.CREATE_NEW, StandardOpenOption.WRITE)
  val buffer: ByteBuffer = ByteBuffer.allocate(1024 * 1024)

  def dumpTransaction(injectorResult: InjectorResult[Request, Option[Response]]) = {
    fillBufferWithData(buffer, injectorResult)
    buffer.flip
    while (buffer.hasRemaining()) {
      channel.write(buffer);
    }
    buffer.clear
  }

  def endAndCloseReport() {
    channel.close
  }

  private def fillBufferWithData(buffer: ByteBuffer, injectorResult: InjectorResult[Request, Option[Response]]) = {
    buffer.put(injectorResult.toXML.toString.getBytes)
    buffer.put("\n".getBytes)
  }
}