package main

import main.ReactiveEvolution._
import main.types._
import rx.lang.scala.Observable

import scala.util.{Failure, Random, Success, Try}


object Evolution {

  def run(process: StochasticProcess, t0: Time , T: Time, dt: Time ): List[Try[Double]] = {

    if (T < dt) List()
    else
    {
      process.x_t = process.evolve(t0 + dt, dt, math.sqrt(dt) * Random.nextGaussian())
      process.x_t :: run(process, t0, T-dt, dt)
    }
  }

}


object ReactiveEvolution {

  def reactiveRun(process: StochasticProcess, t0: Time , T: Time, dt: Time ): Observable[Double] = {
    val N = T/dt

    Observable[Double](subscriber => {
      for (i  <-  1 to N.toInt) {
        process.x_t = process.evolve(t0 + dt, dt, math.sqrt(dt) * Random.nextGaussian())
        process.x_t match {
          case Success(v) => subscriber.onNext(v)
          case Failure(e) => subscriber.onError(e)
        }
      }
      subscriber.onCompleted()
    })
  }


}

object EvolutionHeston {

  def runHeston(processT: StochasticProcess, t0: Time , T: Time, dt: Time ): Observable[(Double,Double)] = {
    val process = processT.asInstanceOf[Heston]
    val N = (T/dt).toInt

    val volatility = Volatility.volatility(process.kappa, process.theta, process.sigm, Success(process.variance._1), Discretization.varianceQuadraticExponential, t0, T, N)

    Observable[(Double,Double)]( subscriber => {

      volatility.subscribe( v => {
        process.variance = v
        process.x_t =  process.evolve(t0 + dt, dt, math.sqrt(dt) * Random.nextGaussian())
        process.x_t match {
          case Success(h) => subscriber.onNext( (v._2, h) )
          case Failure(e) => subscriber.onError(e)
        }
      })
     }
    )
  }

}





object Volatility{

  def volatility(kappa: Double, theta: Double, sigma: Double, v0: Try[Double], discretization: Scheme, t0: Time, T: Time, N: Int): Observable[(Double, Double)] = {

    val dt = (T - t0) / N
    val ceikit = new CIR(kappa, theta, sigma, v0, discretization)
    val last = v0.get +: reactiveRun(ceikit, t0, T, dt)

    last.zip(last.tail)
  }
}