package cm.app.catf.cmd

import scala.io.{Codec, Source}
import java.nio.charset.CodingErrorAction
import cm.app.catf.util.{Format, IOUtil}
import java.io.File

/**
 * Created by eyang on 3/5/14.
 */
class LogSplit extends Command {

  // in case of malformed encoding
  implicit val codec = Codec("UTF-8")
  codec.onMalformedInput(CodingErrorAction.REPLACE)
  codec.onUnmappableCharacter(CodingErrorAction.REPLACE)

  override def exec(conf: Config): Unit = {
    val REGEX = conf.regex.r
    val itr = Source.fromFile(conf.file).getLines()

    IOUtil.withPrintWriter(createOutputFileName(conf.output),
      out => {
        // 0 ==> initial state
        // 1 ==> begin dump
        // 2 ==> end dump
        var dump = 0
        for (l <- itr; if dump < 2) {
          REGEX.findFirstIn(l) match {
            case Some(_) =>
              dump match {
                case 0 => dump = 1
                case 1 => dump = 2
                case _ =>
              }
            case None =>
          }

          if (dump > 0)
            out.println(l)
        }
      })
  }

  private def createOutputFileName(origin: String): String = {
    val r = if (origin.size == 0) "output.txt" else origin

    val file = new File(r)
    if (file.exists()) {
      val p = "%s_%s".format(file.getName, Format.millisToFileTag(file.lastModified()))
      info("rename output file from %s to %s".format(r, p))

      file.renameTo(new File(p))
    }

    r
  }

  override def name: String = LogSplit.cmdName
}

object LogSplit {
  val cmdName = "split"
}