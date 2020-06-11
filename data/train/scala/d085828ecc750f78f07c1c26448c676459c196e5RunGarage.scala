package Garage

object RunGarage {
  def main(args: Array[String]): Unit = {
    val garage = new Garage()
    val car = Car(3)
    val bike = Bike(2)
    val employee = Employee(1, "gabriel")

    // open garage
    garage.openGarage()

    // add vehicles to garage
    for(i<- 1 to 20) garage.addVehicle(new Car(i))

    // register employee
    val names = Array("Paul", "Peter", "John", "Isaac", "Gandalf")
    for(i <- 0 until 5) garage.registerEmployee(new Employee( i+1 , names(i)))

    // remove vehicle
    garage.removeVehicle(3)

    // calculate bill
    garage.calculateBills(car)
    garage.calculateBills(bike)

    // fix vehicle
    garage.fixVehicle(car, employee)
    garage.fixVehicle(bike, employee)

    println(garage)
    println(car)
    println(bike)

    // manage garage
    garage.manageGarage()

    // close garage
    garage.closeGarage()
  }
}
