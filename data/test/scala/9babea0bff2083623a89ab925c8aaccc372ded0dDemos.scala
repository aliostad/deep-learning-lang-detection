package com.github.sbroadhead.multisched

import java.awt.Desktop
import java.io.{Console => _, _}
import java.nio.file._

import com.github.sbroadhead._
import multisched.functions._
import codegraph._
import scala.sys.process._

/**
 * Demos for the `multisched` frontend.
 */
object Demos {

  class ExpDotGraph extends Demo {
    override def run(args: Seq[String]): Unit = {
      val renderer = new FunctionDotRenderer(Exp.exp)
      val dot = renderer.render

      val dotFile = File.createTempFile("multisched", ".dot")
      val bw = new BufferedWriter(new FileWriter(dotFile))
      bw.write(dot)
      bw.close()

      val viewer = if (args.isEmpty) { "/Applications/Graphviz.app/Contents/MacOS/Graphviz" } else args.head
      Seq(viewer, dotFile.getAbsolutePath).!
    }
  }

  class ExpEvalDotGraph extends Demo {
    override def run(args: Seq[String]): Unit = {
      val arg = args.headOption.getOrElse("0").toFloat
      val (_, env) = Evaluator.evaluate(Exp.exp, Seq(new Vec4(arg)))

      val renderer = new FunctionDotEvalRenderer(Exp.exp, Exp.nodeNameMap, env)
      val dot = renderer.render

      val dotFile = File.createTempFile("multisched", ".dot")
      val bw = new BufferedWriter(new FileWriter(dotFile))
      bw.write(dot)
      bw.close()

      val viewer = if (args.length < 2) { "/Applications/Graphviz.app/Contents/MacOS/Graphviz" } else args(1)
      Seq(viewer, dotFile.getAbsolutePath).!
    }
  }

  class ExpEvaluate extends Demo {
    import Instructions._

    def dumpKey(k: Long) = s"0x${k.toHexString.take(4).reverse.padTo(4, '0').reverse}"

    def dumpInt(i: Int) = f"${java.lang.Float.intBitsToFloat(i)}%16.8g~0x${i.toHexString.reverse.padTo(8, '0').reverse}"

    def dumpVec(v: Vec4) = f"<${dumpInt(v.a)}, ${dumpInt(v.b)}, ${dumpInt(v.c)}, ${dumpInt(v.d)}>"

    def dumpEdge(e: CodeGraph.Edge[Instruction], env: Map[CodeGraph.NodeKey, Any]) =
      s"* ${Console.MAGENTA}${e.label.toString}${Console.RESET}\n  " +
        s"args=\n    ${e.args.map(x => Console.CYAN +
          dumpVec(env.getOrElse(x, sys.error(s"Node not evaluated: $x")).asInstanceOf[Vec4]) + Console.RESET)
            .mkString("\n    ")}\n  " +
        s"results=\n    ${e.results.map(x => Console.CYAN +
          dumpVec(env.getOrElse(x, sys.error(s"Node not evaluated: $x")).asInstanceOf[Vec4]) + Console.RESET)
          .mkString("\n    ")}\n"

    override def run(args: Seq[String]): Unit = {
      import CodeGraphOps._
      val cg = Exp.exp

      val arg = args.headOption.getOrElse("0").toFloat
      val (_, env) = Evaluator.evaluate(cg, Seq(new Vec4(arg)))
      for (input <- cg.inputs) {
        val v = env.getOrElse(input, sys.error(s"Node not evaluated: $input")).asInstanceOf[Vec4]
        println(s"- ${Console.RED}${dumpKey(input)}${Console.RESET} :=\n    ${Console.GREEN}${dumpVec(v)}${Console.RESET}\n")
      }
      for (edgeKey <- cg.topSort) {
        val edge = cg.edge(edgeKey).head
        for (result <- edge.results) {
          val v = env.getOrElse(result, sys.error(s"Node not evaluated: $result")).asInstanceOf[Vec4]
          println(s"- ${Console.YELLOW}${dumpKey(result)}${Console.RESET} :=\n    ${Console.GREEN}${dumpVec(v)}${Console.RESET}\n")
        }
        println(dumpEdge(edge, env))
      }
      for (output <- cg.outputs) {
        val v = env.getOrElse(output, sys.error(s"Node not evaluated: $output")).asInstanceOf[Vec4]
        println(s"- ${Console.RED}${dumpKey(output)}${Console.RESET} :=\n    ${Console.GREEN}${dumpVec(v)}${Console.RESET}\n")
      }
    }
  }

}
