package functions

import breeze.linalg.{DenseVector => BDV,DenseMatrix => BDM}

class LinearObj(val c: BDV[Double], val A: BDM[Double]) extends Function1[BDV[Double], Double] with Update with Serializable{
  def apply(x:BDV[Double]) : Double = {
    c dot x
  }
  
 def Update (z: BDV[Double], x_old: BDV[Double], rho: Double): BDV[Double] = {
   val dimension: Int = A.cols 
   
   val I = BDM.eye[Double](dimension) * 0.1
   
   val a: BDM[Double] = A.t * A * rho + I
   
   val b: BDV[Double] = A.t * A * x_old * rho + I * x_old - A.t * z * rho - c
   
   a\b
 }
}