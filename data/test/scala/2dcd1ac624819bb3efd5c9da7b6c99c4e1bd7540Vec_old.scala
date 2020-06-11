package russoul.lib.common.math.algebra

import russoul.lib.common.NotNothing
import russoul.lib.common.TypeClasses.{Euclidean, Field}
import russoul.lib.common.math.immutable.algebra._


import scala.reflect.ClassTag

/**
  * Created by russoul on 20.05.17.
  */


/*class IncorrectDimException(dim:Dim) extends Exception{
  override def getMessage: String = "dim: " + dim.n
}

//TODO compile time scalameta checks of validity (Vec_oldDim == arg.length and others like vec(2.dim, ...) + vec(3.dim, ...))
case class Vec_old[A <: Dim : NotNothing, @tbsp B](dim: A, array:Array[B])(implicit tagA: ClassTag[A], tagB: ClassTag[B], ev: Field[B] with Euclidean[B]){

  //TODO prevent this runtime check if possible ???, but how ?
  if(dim.n != array.length) throw new IncorrectDimException(dim)

  @inline def x: B = array(0)
  @inline def y: B = array(1)
  @inline def z: B = array(2)
  @inline def w: B = array(3)

  /**
    *
    * @param index - starts from 1 !
    * @return
    */
  @inline def apply(index: Int): B = {
    array(index-1)
  }

  @inline def *[C <: Dim : NotNothing](vec: Vec_old[C,B]): B = {
    var res:B = ev.zero

    for(i <- array.indices){
      res += array(i) * vec.array(i)
    }

    res
  }

  @inline def ??*[C <: Dim : NotNothing](vec: Vec_old[C,B]): Boolean = {
    dim.n == vec.dim.n
  }

  @inline def *(scalar: B): Vec_old[A,B] = {
    val ar = new Array[B](dim.n)
    for(i <- 0 until dim.n){
      ar(i) = array(i) * scalar
    }

    new Vec_old(dim, ar)
  }

  @inline def /(scalar: B): Vec_old[A,B] = {
    val ar = new Array[B](dim.n)
    for(i <- 0 until dim.n){
      ar(i) = array(i) / scalar
    }

    new Vec_old(dim, ar)
  }

  @inline def ⊗[C <: Dim : NotNothing](vec:Vec_old[C,B]):Vec_old[Dim,B] = {
    val ar = new Array[B](dim.n)
    for(i <- 0 until dim.n){
      ar(i) = array(i) * vec.array(i)
    }

    new Vec_old(dim, ar)
  }

  @inline def ??⊗[C <: Dim : NotNothing](vec: Vec_old[C,B]): Boolean = {
    dim.n == vec.dim.n
  }

  @inline def +[C <: Dim : NotNothing](vec:Vec_old[C,B]):Vec_old[Dim,B] = {
    val ar = new Array[B](dim.n)
    for(i <- 0 until dim.n){
      ar(i) = array(i) + vec.array(i)
    }

    new Vec_old(dim, ar)
  }


  @inline def ??+[C <: Dim : NotNothing](vec: Vec_old[C,B]): Boolean = {
    dim.n == vec.dim.n
  }


  @inline def -[C <: Dim : NotNothing](vec:Vec_old[C,B]):Vec_old[Dim,B] = {
    val ar = new Array[B](dim.n)
    for(i <- 0 until dim.n){
      ar(i) = array(i) - vec.array(i)
    }

    new Vec_old(dim, ar)
  }

  @inline def ??-[C <: Dim : NotNothing](vec: Vec_old[C,B]): Boolean = {
    dim.n == vec.dim.n
  }

  @inline def unary_-(): Vec_old[A,B] = {
    val ar = new Array[B](dim.n)
    for(i <- 0 until dim.n){
      ar(i) = -array(i)
    }

    new Vec_old(dim, ar)
  }

  @inline def unary_+(): Vec_old[A,B] = {
    val ar = new Array[B](dim.n)
    for(i <- 0 until dim.n){
      ar(i) = array(i)
    }

    new Vec_old(dim, ar)
  }

  /**
    * defined only for vectors of dim 2
    * @return
    */
  @inline def ⟂():Vec_old[Dim,B] = {
    Vec_old(Two, y, -x)
  }


  @inline def ??⟂():Boolean = {
    dim.n == 2
  }

  @inline def ?⟂():Option[Vec_old[Dim,B]] = {
    if(??⟂()) Some(Vec_old(Two, y, -x)) else None
  }


  /**
    * defined only for vectors of dim 3
    * @return
    */
  @inline def ⨯[C <: Dim : NotNothing](v:Vec_old[C,B]):Vec_old[Dim,B] = {
    Vec_old(dim, y * v.z - z * v.y, z * v.x - x * v.z, x * v.y - y * v.x)
  }



  @inline def ??⨯[C <: Dim : NotNothing](v:Vec_old[C,B]):Boolean = {
    dim.n == 3 && v.dim.n == 3
  }

  @inline def ?⨯[C <: Dim : NotNothing](v:Vec_old[C,B]):Option[Vec_old[Dim,B]] = {
    if(??⨯(v)) Some(Vec_old(dim, y * v.z - z * v.y, z * v.x - x * v.z, x * v.y - y * v.x)) else None
  }

  @inline def squaredLength():B = {
    var res:B = ev.one

    for(i <- array.indices){
      res *= array(i) * array(i)
    }

    res
  }

  @inline def length():B = {
    ev.sqrt(squaredLength())
  }

  @inline def normalize(): Vec_old[A,B] = {
    val ar = new Array[B](dim.n)
    val len = length()
    for(i <- 0 until dim.n){
      ar(i) = array(i) / len
    }

    new Vec_old(dim, ar)
  }

  override def toString(): String = {
    val bld = new StringBuilder


    bld ++= "Vec_old[" + dim.n + "," + ev.toString() + "]("

    for(a <- array){
      bld ++= a.toString + "; "
    }

    bld.delete(bld.length - 2, bld.length)
    bld += ')'

    bld.result()
  }
}

object Vec_old{
  def apply[A <: Dim : NotNothing, B](dim:A, seq: B*)(implicit tagA: ClassTag[A], tagB : ClassTag[B], ev: Field[B] with Euclidean[B]): Vec_old[A,B] = {

    val arr = new Array[B](dim.n)

    for(i <- 0 until dim.n){
      arr(i) = seq(i)
    }

    new Vec_old(dim, arr)
  }


  //EXTRA OPS...........................................................................
  @inline def ⟂[B  : ClassTag](v:Vec_old[Two, B])(implicit ev: Field[B] with Euclidean[B]):Vec_old[Two,B] = {
    Vec_old(Two, v.y, -v.x)
  }


  @inline def ⨯[B  : ClassTag](a:Vec_old[Three,B], b:Vec_old[Three,B])(implicit ev: Field[B] with Euclidean[B]):Vec_old[Three,B] = {
    Vec_old(Three, a.y * b.z - a.z * b.y, a.z * b.x - a.x * b.z, a.x * b.y - a.y * b.x)
  }
  //....................................................................................

}*/
