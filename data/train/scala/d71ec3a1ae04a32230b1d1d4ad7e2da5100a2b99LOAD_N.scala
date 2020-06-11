package com.sword865.scalaJVM.instructions.loads

import com.sword865.scalaJVM.instructions.base.NoOperandsInstruction
import com.sword865.scalaJVM.instructions.base.NoOperandsInstruction._
import com.sword865.scalaJVM.rtda.{Frame, heap}

import scala.reflect.ClassTag

object LOAD_N{
  class ALOAD_0 extends LOAD_N[heap.Object,ZERO]
  class ALOAD_1 extends LOAD_N[heap.Object,ONE]
  class ALOAD_2 extends LOAD_N[heap.Object,TWO]
  class ALOAD_3 extends LOAD_N[heap.Object,THREE]
  class DLOAD_0 extends LOAD_N[Double,ZERO]
  class DLOAD_1 extends LOAD_N[Double,ONE]
  class DLOAD_2 extends LOAD_N[Double,TWO]
  class DLOAD_3 extends LOAD_N[Double,THREE]
  class FLOAD_0 extends LOAD_N[Float,ZERO]
  class FLOAD_1 extends LOAD_N[Float,ONE]
  class FLOAD_2 extends LOAD_N[Float,TWO]
  class FLOAD_3 extends LOAD_N[Float,THREE]
  class ILOAD_0 extends LOAD_N[Int,ZERO]
  class ILOAD_1 extends LOAD_N[Int,ONE]
  class ILOAD_2 extends LOAD_N[Int,TWO]
  class ILOAD_3 extends LOAD_N[Int,THREE]
  class LLOAD_0 extends LOAD_N[Long,ZERO]
  class LLOAD_1 extends LOAD_N[Long,ONE]
  class LLOAD_2 extends LOAD_N[Long,TWO]
  class LLOAD_3 extends LOAD_N[Long,THREE]
}


class LOAD_N[T, V <: VALUE](implicit val ev: ClassTag[T], implicit val vev: ClassTag[V])
  extends NoOperandsInstruction {

  val index: Short = convertClassToValue(vev)

  override def execute(frame: Frame): Unit = {
    val value = frame.localVars.get[T](index)
    frame.operandStack.push[T](value)
  }
}
