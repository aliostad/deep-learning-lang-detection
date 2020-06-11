package uk.ac.cam.bsc28.diss.App

import uk.ac.cam.bsc28.diss.Analysis.StaticAnalyser
import uk.ac.cam.bsc28.diss.CodeGeneration.CodeGenerator
import uk.ac.cam.bsc28.diss.Config.Config
import uk.ac.cam.bsc28.diss.FrontEnd._
import uk.ac.cam.bsc28.diss.VM.{Scheduler}

object Application extends App {

  private final val usage = "usage: picl file [--dump] [--trace]"

  override def main(args: Array[String]): Unit = {

    val flagActions = Map() ++ List(
      "--dump" -> { () => Config.DUMP_IR = true },
      "--trace" -> { () => Config.TRACE = true },
      "--pure" -> { () => Config.KILL_THREADS = false}
    )

    if (args.length < 1 || args.length > flagActions.size + 1) {
      println(usage)
      System.exit(1)
    }

    val flags = args.slice(1,args.length)
    flags foreach { flag =>
      flagActions.get(flag) match {
        case Some(action) =>
          action()

        case None =>
          println(s"Invalid flag: $flag")
          System.exit(8)
      }
    }

    val maybeText = Filesystem.textFromTargetFileName(args(0))

    if (maybeText.isRight) {
      val err = maybeText.right.get
      println(s"File not found: $err")
      System.exit(2)
    }

    val programText = maybeText.left.get
    val (externs, source) = ExternProcessor.preprocessSource(programText)

    try {
      val tokens = Lexer.tokenize(source)
      Config.dumpLine(s"Tokens:\n$tokens\n")

      val parser = new Parser(tokens)
      val tree = parser.parse()

      if (tree.nonEmpty) {
        Config.dumpLine(s"Parse Tree:\n${tree.get}\n")

        val errors = StaticAnalyser.analyse(tree.get)
        errors match {
          case Some(list) =>
            list foreach println
            System.exit(7)

          case _ => Config.dumpLine("No static analysis errors.\n")
        }

        val gen = new CodeGenerator(tree.get)
        val bytecode = gen.generate()

        Config.dumpLine("Bytecode:")
        bytecode foreach Config.dumpLine
        Config.dumpLine("")

        val sched = new Scheduler(bytecode, externs)

        sched.spawn(0, Map(), None)
    } else {
        println("Parsing error!")
        System.exit(3)
      }
    } catch {
      case e: LexException =>
        println(e.getMessage)
        System.exit(4)

      case e: ParseError =>
        println(e.getMessage)
        System.exit(5)
    }

  }

}
