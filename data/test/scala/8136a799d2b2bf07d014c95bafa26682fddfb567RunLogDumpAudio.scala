package voice.testing

import java.io.File

import mvnmod.builder.MavenTools
import toolbox8.jartree.testing.StreamAppClient
import toolbox8.rpi.installer.Rpis
import voice.modules.VoiceRpiModules
import voice.rpi.exec.LogDumpAudio

/**
  * Created by pappmar on 25/11/2016.
  */
object RunLogDumpAudio {

  val Target = Rpis.Localhost

  def main(args: Array[String]): Unit = {
    MavenTools
      .runMavenProject(
        new File("../voice"),
        Seq("install")
      )

    StreamAppClient
      .request(
        VoiceRpiModules.Exec,
        classOf[LogDumpAudio].getName,
        "boo",
        Target
      )


  }

}
