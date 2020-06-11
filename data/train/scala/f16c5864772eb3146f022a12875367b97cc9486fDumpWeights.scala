/*
 * La Trobe University - Distributed Deep Learning System
 * Copyright 2016 Matthias Langer (t3l@threelights.de)
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

package edu.latrobe.blaze.objectives

import edu.latrobe._
import edu.latrobe.blaze._
import java.io.{ObjectOutputStream, OutputStream}
import edu.latrobe.time._

/**
  * Dumps the weights buffer (binary!) into the output stream.
  */
final class DumpWeights(override val builder: DumpWeightsBuilder,
                        override val seed:    InstanceSeed)
  extends IndependentObjective[DumpWeightsBuilder] {
  require(builder != null && seed != null)

  override protected def doEvaluate(sink:                Sink,
                                    optimizer:           OptimizerLike,
                                    runBeginIterationNo: Long,
                                    runBeginTime:        Timestamp,
                                    runNoSamples:        Long,
                                    model:               Module,
                                    batch:               Batch,
                                    output:              Tensor,
                                    value:               Real)
  : Option[ObjectiveEvaluationResult] = {
    val clock = Stopwatch()
    if (logger.isDebugEnabled) {
      logger.debug("Dumping model weights...")
    }

    // Get weights and download into JVM if necessary.
    val jvmWeights = model.weightBuffer.toRealTensorBufferJVM

    // Serialize into object stream.
    sink.writeRaw(jvmWeights)

    logger.debug(s"Model weight dump complete. Time taken: $clock")
    None
  }

}

final class DumpWeightsBuilder
  extends IndependentObjectiveBuilder[DumpWeightsBuilder] {

  override def repr
  : DumpWeightsBuilder = this

  override def canEqual(that: Any)
  : Boolean = that.isInstanceOf[DumpWeightsBuilder]

  override protected def doCopy()
  : DumpWeightsBuilder = DumpWeightsBuilder()

  override def build(seed: InstanceSeed)
  : DumpWeights = new DumpWeights(this, seed)

}

object DumpWeightsBuilder {

  final def apply()
  : DumpWeightsBuilder = new DumpWeightsBuilder

}