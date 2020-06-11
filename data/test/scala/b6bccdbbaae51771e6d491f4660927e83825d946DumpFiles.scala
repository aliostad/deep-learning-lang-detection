package voice.requests.common

import java.io._

import com.typesafe.scalalogging.StrictLogging
import org.apache.commons.io.IOUtils
import toolbox6.logging.LogTools
import toolbox8.jartree.streamapp.{Requestable, RootContext}


/**
  * Created by maprohu on 29-11-2016.
  */
case class DumpFilesInput(
  files: Seq[String]
)

class DumpFiles extends Requestable with StrictLogging with LogTools {
  override def request(ctx: RootContext, in: InputStream, out: OutputStream): Unit = {
    val dis = new ObjectInputStream(in)
    val input =
      dis
        .readObject()
        .asInstanceOf[DumpFilesInput]


    input
      .files
      .foreach({ fn =>
        val dos = new DataOutputStream(out)

        val f = new File(fn)
        logger.info(s"dumping file: ${fn} - ${f.length()}")
        val fis = new FileInputStream(f)

        try {
          dos.writeLong(f.length())
          IOUtils.copyLarge(
            fis,
            dos
          )
        } finally {
          fis.close()
        }

        dos.flush()
      })

    logger.info("dump files complete")
  }
}
