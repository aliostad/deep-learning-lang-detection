package lllm.old.model

import breeze.linalg.DenseVector
import breeze.util.Index
import igor.experiment.ResultCache
import lllm.old.main.LLLMParams

/**
 * @author jda
 */

// TODO(jda) each objective should get its own file

trait Objective {

  def numParams(numFeatures: Int)(implicit config: LLLMParams, cache: ResultCache): Int

  def apply(theta: DenseVector[Double],
            batch: Int,
            lines: Seq[String],
            featureIndex: Index[String])
           (implicit config: LLLMParams,
            cache: ResultCache): (Double, DenseVector[Double])

}
