package sefs
package cps

import effect._
import scala.util.continuations._
import process._
import Process._

object ProcessCps extends SpecificCps[PS.AIO_PS] {
  protected override val monad = PIOMonad

  type process = cps[PIO[Any]]

  def pio2cps[A](a: PIO[A]) = sm2cps(a)
  implicit def io2cps[A](a: IO[A]) = sm2cps(io2pio(a))
  implicit def aio2cps[A](a: AIO[A, PS]) = sm2cps(a)

  implicit def asProcess[A](cps: => A @process): PIO[A] = asMonad(cps)

  def self = pio2cps(Process.self).value
  def spawn[A](body: => A @process)(implicit executor: ProcessExecutor) = {
    val b = asProcess(body)
    Process.spawn(b) value
  }
  def receive[A](pf: PartialFunction[Any, A @process]): A @process = {
    val pfm = new PartialFunction[Any, PIO[A]] {
      override def isDefinedAt(v: Any) = pf.isDefinedAt(v)
      override def apply(v: Any) = asProcess[A](pf(v))
    }
    val pa: PIO[A] = Process.receive[A](pfm)
    pio2cps(pa).value
  }

  def spawn_pio[A](body: PIO[A])(implicit executor: ProcessExecutor) = Process.spawn(body) value
  def receive_pio[A](pf: PartialFunction[Any, PIO[A]]): PIO[A] = {
    Process.receive[A](pf)
  }
}
