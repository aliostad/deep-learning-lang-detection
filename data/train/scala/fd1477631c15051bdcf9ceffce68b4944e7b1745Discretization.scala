package main

import main.types._
import org.apache.commons.math3.distribution.NormalDistribution


import scala.util.{Random, Success, Try}


object Discretization {

  // and it's all wrapped in the monad, you're happy and life is good

  def euler(process: StochasticProcess, t: Time, dt: Time, dw: Double): Try[Double] =
    for {
      drift <- process.drift(t,process.x_t)
      sigma <- process.sigma(t,process.x_t)
    } yield process.x_t.get + (drift * dt) + (sigma * dw)

  def milstein(process: StochasticProcess, t: Time, dt: Time, dw: Double): Try[Double] =
    for{
      drift <- process.drift(t, process.x_t)
      sigma <- process.sigma(t, process.x_t)
    } yield process.x_t.get + ( drift * dt ) + (sigma * dw) + 0.5*( drift * drift * (dw * dw - dt) )

  
// quadraticExponential is exclusively for CIR processes
  def varianceQuadraticExponential(processT: StochasticProcess, t: Time, dt: Time, dw: Double): Try[Double] = {
    val process = processT.asInstanceOf[CIR]
    val E = math.exp(-process.kappa)
    val phic = 1.5
    val m = process.theta + (process.x_t.get - process.theta)*E
    val s2 = process.x_t.get * math.pow(process.sigma, 2) * E / process.kappa * (1-E) +
       process.theta * math.pow(process.sigma, 2) / 2 / process.kappa * math.pow(1-E , 2)
    val phi = s2/ math.pow(m, 2)
    val Uv = Random.nextDouble()
    var phiinv: Double = 0

    if (phi <= phic) {
      val b = math.sqrt(2/ phi - 1 + math.sqrt(2/ phi*(2/phi-1)))
      val a = m/(1 + math.pow(b,2) )
      val g = new NormalDistribution()
      val Zv = g.inverseCumulativeProbability(Uv)
      val value = Success(a* math.pow(b + Zv, 2))
      return value
    }
    else {
      val p = (phi-1)/(phi+1)
      val beta = (1-p)/m
      if ( (0 <= Uv) && ( Uv <= p) ) {  phiinv = 0 } else {  phiinv = 1/beta * math.log((1-p)/(1-Uv)) }
      val value = Success(phiinv)
      return value
    }

  }


//discretisation for HESTON process
  def stockQE(processT: StochasticProcess, t: Time, dt: Time, dw: Double): Try[Double] = {
    val process = processT.asInstanceOf[Heston]

    val gamma1 = 0.5
    val gamma2 = 0.5

    val K0 = - process.kappa * process.rho * process.theta*dt/process.sigm
    val K1 = (process.kappa*process.rho/process.sigm - 1/2)*gamma1*dt - process.rho/process.sigm
    val K2 = (process.kappa*process.rho/process.sigm - 1/2)*gamma2*dt + process.rho/process.sigm
    val K3 = gamma1*dt*(1-math.pow(process.rho,2))
    val K4 = gamma2*dt*(1-math.pow(process.rho,2))
    val Zv = Random.nextGaussian()
    val Zs = process.rho * Zv + math.sqrt(1-math.pow(process.rho,2)) * Random.nextGaussian()


   for{
     x <- process.x_t
   } yield x * math.exp( process.mu * dt + K0 + K1 * process.variance._1 + K2 * process.variance._2 + math.sqrt(K3 * process.variance._1 + K4 * process.variance._2)*Zs)

}


}

