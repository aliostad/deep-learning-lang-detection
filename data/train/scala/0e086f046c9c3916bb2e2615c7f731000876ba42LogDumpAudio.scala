package voice.rpi.exec

import java.io.{InputStream, ObjectOutputStream, OutputStream}

import com.typesafe.scalalogging.StrictLogging
import toolbox8.jartree.streamapp.{Plugged, Requestable, RootContext}
import voice.core.RpiAudio

/**
  * Created by pappmar on 25/11/2016.
  */
class LogDumpAudio extends Requestable with StrictLogging {
  override def request(ctx: RootContext, in: InputStream, out: OutputStream): Unit = {
    val d = RpiAudio.dumpInfo
    logger.info("Audio dump: {}", d)
    val dos = new ObjectOutputStream(out)
    dos.writeObject(d)
    dos.flush()
  }
}
