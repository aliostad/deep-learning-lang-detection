
//import evaluation.reachBlocked.ParallelLanes

/**
  * Created by FM on 06.08.16.
  */
object ParallelLanesEvaluation {

  def main(args: Array[String]): Unit = {

    /*

    TODO does not compile

    val dump = DumpData("Configuration", "node x lanes")
    val dumpToCsv = dump.printResults("output.csv") _

    if (args.length == 0) {
      // evaluate everything one time as pre-pre-warmup
      evaluate(Seq("tms", "greedy") toArray)


      val allOptions = Seq(
        Seq("tms", "greedy"),
        Seq("tms", "doyle"),
        Seq("tms", "learn")
        //        Seq("clingo", "push")
      )

      val allResults = allOptions map (o => evaluate(o.toArray))

      dump.plot(allResults)

      dumpToCsv(allResults)

    } else {
      val results = evaluate(args)
      dump.plot(Seq(results))
      dumpToCsv(Seq(results))
    }
  }


  def evaluate(args: Array[String]) = {
    val evaluationOptions = Seq(
      (1, 1),
      (1, 2),
      (1, 3),
      (1, 4),
      (2, 2),
      (2, 3),
      (2, 4),
      (3, 3),
      (3, 4),
      (4, 4)
    )

    val option = args.mkString(" ")

    val results = evaluationOptions map {
      case (nodes, lanes) => execute(args, nodes, lanes)
    }
    AlgorithmResult(option, results toList)
  }


  def execute(args: Array[String], nodes: Int, lanes: Int) = {

    val instance = f"${nodes}x${lanes}"

    val pl = new ParallelLanes {}
    val program = pl.generateProgramWithGrounding(nodes, lanes)

    val evaluator = PrepareEvaluator.fromArguments(args, instance, program)

    val obstacles = pl.generatedNodes.map(pl.obstacle(_)).toSet[Atom].subsets().toList
    val inputs: Seq[StreamEntry] = obstacles zip (Stream from 1) map {
      case (atoms, timePoint) => StreamEntry(TimePoint(timePoint), atoms)
    }

    evaluator.streamAsFastAsPossible(1, 2)(inputs)

      */
  }

}
