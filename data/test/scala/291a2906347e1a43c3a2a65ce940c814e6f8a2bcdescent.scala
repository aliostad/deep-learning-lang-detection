package org.fjn.optimization.gradient.newton

import org.fjn.matrix.Matrix
import org.fjn.optimization.common.differentiation.DifferentialOpsFactory
import org.apache.commons.math3.optimization.univariate.BrentOptimizer
import org.apache.commons.math3.analysis.UnivariateFunction
import org.apache.commons.math3.optimization.GoalType
import org.fjn.optimization.common.{IOptimizerData, IOptimizerSolverBuilder, MatrixType, IOptimizerSolver}
import MatrixType.DMatrix


object GradientDescent {


  implicit def toUniFunc(f:(Double)=>Double)={
    new UnivariateFunction {
      def value(x: Double): Double = f(x)
    }
  }

  private def checkConvergence(x:Matrix[Double],xOld:Matrix[Double],grad:Matrix[Double],tol:Double,gradTol:Double)={
    val dx =((x-xOld)*(x-xOld).transpose)(0,0)
    val nGrad = (grad*grad.transpose)(0,0)

    dx<tol || nGrad<gradTol
  }

  private def solve(x0:Matrix[Double],data:IOptimizerData):(Matrix[Double],Double)={
    var x = x0
    var xOld = x

    val linearSearchIteration = 50
    val functor = data.cost
    val diffOp = DifferentialOpsFactory(functor,x0.numberRows)

    val maxIter = data.maxIterations
    var g = diffOp.grad(x)

    for(i<-0 until maxIter if !checkConvergence(x,xOld,g,1e-5,1e-4)){

      val fLinear = (v:Double)=>{functor(x-g*v)}
      val brent = new BrentOptimizer(0.01,1e-3)
      val lr = brent.optimize(linearSearchIteration,fLinear,GoalType.MINIMIZE,1e-5,1,1e-5)
      xOld = x
      x += -g * lr.getPoint

      g = diffOp.grad(x)

    }
    (x,functor(x))
  }



  def apply(x0:Matrix[Double],f:(Matrix[Double]=>Double),tolerance:Double,maxIter:Int)={
    IOptimizerSolverBuilder().withCostFunction(f).withMaxIterations(maxIter).withSolver(solve).build
  }










}
