package org.apache.spark.ml.image.core


trait ProcessStep[A, B] extends Serializable {
  def apply(prev: A): B

  def -> [C](other: ProcessStep[B, C]): ProcessStep[A, C] = {
    new ChainedProcessStep(this, other)
  }

}

class ChainedProcessStep[A, B, C](first: ProcessStep[A, B], last: ProcessStep[B, C])
  extends ProcessStep[A, C] {
  override def apply(prev: A): C = {
    last(first(prev))
  }
}

object ProcessStep {

  def Hue(delta: Float): ProcessStep[cMat, cMat] = org.apache.spark.ml.image.core.Hue(delta)

}