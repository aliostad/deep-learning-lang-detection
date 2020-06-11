package functions

import org.apache.spark.rdd.RDD
import breeze.linalg.{DenseVector => BDV,DenseMatrix => BDM}
import breeze.linalg._

class LinearObj(val c: BDV[Double]) extends Function1[BDV[Double], Double] with Update with Serializable{

  def apply(x:BDV[Double]) : Double = {
     c dot x
  }
  
 def Update (z: BDV[Double], x_old: BDV[Double], A: BDM[Double], rho: Double): BDV[Double] = {
   val dimension: Int = A.cols 
   
   val I = BDM.eye[Double](dimension) * 0.1
   
   val a: BDM[Double] = A.t * A * rho + I
   
   val b: BDV[Double] = A.t * A * x_old * rho + I * x_old - A.t * z * rho - c
   
   a\b
 }
}

object LinearObj {
   def fromLocal(c: RDD[BDV[Double]]) : RDF[LinearObj] = {
     //This should be deleted at last

     val fns = c.map(x => new LinearObj(x))
     
     new RDF[LinearObj](fns, 0L) 
   }
  
  
}