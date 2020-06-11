package com.autoscout24
import cats.Show
import cats.syntax.show._

// trait Show[T] {
//  def show(f: T): String
// }

final case class ClutchPedal(serialNumber: String)
final case class GasPedal(serialNumber: String)

final case class Car(clutchPedal: ClutchPedal, gasPedal: GasPedal)

object DefaultShows {
  implicit val showCar: Show[Car] = Show.show[Car] { car =>
    s"Car with clutch pedal (${car.clutchPedal.serialNumber}) and gas pedal (${car.gasPedal.serialNumber})"
  }
}

object ShowTest extends App {
  import DefaultShows._

  val carStr = Car(ClutchPedal("000"),GasPedal("001")).show

  println(carStr)
}