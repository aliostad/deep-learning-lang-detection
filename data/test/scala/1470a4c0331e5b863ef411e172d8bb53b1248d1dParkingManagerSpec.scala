package oocamp

import org.scalatest.{Matchers, FlatSpec}

/**
 * Created by twer on 14/11/24.
 */
class ParkingManagerSpec extends FlatSpec with Matchers {
  it should "parkingManager can park car when manage parkinglot" in {
    val car = Car()
    val parkingLot = new ParkingLot(1)
    val ticket = new ParkingManager(Array(parkingLot)).park(car).get
    parkingLot.pick(ticket).get should be (car)
  }

  it should "parkingManager can park car when manage parkinglot and parkingBoy" in {
    val car = Car()
    val parkingBoy = new ParkingBoy(Array(new ParkingLot(1)))
    val ticket = new ParkingManager(Array(parkingBoy, new ParkingLot(1))).park(car).get
    parkingBoy.pick(ticket).get should be (car)
  }

  it should "pick car by ticket" in {
    val car = Car()
    val parkingManager = new ParkingManager(Array(new ParkingBoy(Array(new ParkingLot(1))), new ParkingLot(1)))
    val ticket = parkingManager.park(car).get
    parkingManager.pick(ticket).get should be (car)
  }
}
