package fr.xebia.xkeakka.manufacturing

import org.scalatest.matchers.ShouldMatchers
import org.scalatest.{BeforeAndAfterAll, WordSpec}
import java.io.File
import fr.xebia.xkeakka.manufacturing.transcoder.{FileFormat, LameTranscoder, Transcoder}

/**
 * @author David Galichet.
 */

class TranscoderTests extends WordSpec with ShouldMatchers with BeforeAndAfterAll {

    "FileFormat" should {
        "manage file name" in {
            val fileFormat = FileFormat(new File("/test/music.wav"), "mp3", 32768)
            fileFormat.encodedFile.getAbsolutePath should be("/test/encoded/music_32768.mp3")
        }
    }
}