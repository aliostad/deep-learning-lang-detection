package dhg.pos.util

import dhg.util.CollectionUtil._
import dhg.util.FileUtil._
import dhg.util.Pattern.makeRangeString
import dhg.util.Pattern.Range
import dhg.util.Pattern.UInt
import dhg.nlp.util.CollectionUtils.UniversalSet

class Condor(
  stagingDir: String,
  memory: Int = 4000) {

  def make(classnamesArgsAndFilenames: Iterable[(String, String, String)]) = {
    val workingDir = File("").getAbsolutePath

    writeUsing(File(stagingDir, "main.config")) { w =>
      w.writeLine("universe = vanilla")
      w.writeLine("getenv = True")
      w.writeLine("")
      w.writeLine("Executable = /bin/sh")
      w.writeLine("")
      w.writeLine(s"""Requirements = InMastodon && (Memory >= $memory) && (ARCH == "X86_64")""")
      w.writeLine("+Group   = \"GRAD\"")
      w.writeLine("+Project = \"AI_ROBOTICS\"")
      w.writeLine("+ProjectDescription = \"dhg\"")
      w.writeLine("")
      w.writeLine(s"Initialdir = $workingDir")
      w.writeLine("")

      for ((classname, args, subscriptFilename) <- classnamesArgsAndFilenames) {
        val subscriptPath = pathjoin(stagingDir, subscriptFilename)

        println(subscriptPath)
        writeUsing(File(subscriptPath + ".sh")) { w =>
          w.writeLine("#! /bin/sh")
          w.writeLine(s"(cd $workingDir && exec $workingDir/target/start $classname $args)")
        }

        w.writeLine(s"Log = $subscriptPath.log")
        w.writeLine(s"Output = $subscriptPath.out")
        w.writeLine(s"Error = $subscriptPath.err")
        w.writeLine(s"Arguments = $subscriptPath.sh")
        w.writeLine("")
        w.writeLine("Queue")
        w.writeLine("")
      }
    }

    writeUsing(File(stagingDir, "main.sh")) { w =>
      w.writeLine(s"/lusr/opt/condor/bin/condor_submit ${pathjoin(stagingDir, "main.config")}")
    }
    println("sh " + pathjoin(stagingDir, "main.sh"))
  }

}
