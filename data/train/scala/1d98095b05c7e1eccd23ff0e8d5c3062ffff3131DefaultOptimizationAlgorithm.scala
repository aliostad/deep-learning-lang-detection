package com.github.libsml.aggregation.optimization

import java.io.PrintStream

import com.github.libsml.commons.util.Utils
import com.github.libsml.model.Model

import com.github.libsml.math.linalg.Vector
import com.github.libsml.model.evaluation.Evaluator
import com.github.libsml.optimization.Optimizer

/**
 * Created by huangyu on 15/9/6.
 */
class DefaultOptimizationAlgorithm(
                                    val optimizer: Optimizer[Vector],
                                    val model: Model[Vector, Vector],
                                    val evaluator: Option[Evaluator[Vector, Vector]] = None,
                                    iterationResultFile: Option[String] = None,
                                    val saveFrequency: Int = 1,
                                    val evaluateFrequency: Int = 1,
                                    val out: PrintStream = System.out)
  extends OptimizationAlgorithm[Vector, Vector] {


  override def optimize(): Model[Vector, Vector] = {
    var oldEvaluatorIt = 0
    var oldSaveIt = 0
    out.println("Start optimization at time %s\n".format(Utils.currentTime()))
    var iter: Int = 1
    for (it <- optimizer) {
      out.print("Iteration %d optimization finishes at time %s:%s\n".
        format(iter, Utils.currentTime(), if (it.f.isDefined) "f=" + it.f.get else ""))
      it.msg.filter(_.trim != "").foreach(m => {
        out.println("-----------message-----------")
        out.print(m)
        out.println("-----------------------------")
      })
      model.update(it.w)


      if (saveFrequency > 0 && iter - oldSaveIt >= saveFrequency) {
        iterationResultFile.foreach(f => model.save(f + "/" + iter))
        oldSaveIt = iter
      }


      if (evaluateFrequency > 0 && iter - oldEvaluatorIt >= evaluateFrequency) {
        evaluator.foreach(e => {
          out.print("Iteration %d evaluator starts at time %s:\n".
            format(iter, Utils.currentTime()))
          out.println("------------metrics------------")
          e.evaluator(model)
          out.println("-------------------------------")
          out.print("Iteration %d evaluator finishes at time %s:\n".
            format(iter, Utils.currentTime()))
        })
        oldEvaluatorIt = iter
      }
      iter += 1
      out.println
    }
    model
  }

}
