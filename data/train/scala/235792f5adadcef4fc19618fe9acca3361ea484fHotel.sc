trait Customer
case object Regular extends Customer
case object Rewards extends Customer

trait Day
case object Weekday extends Day
case object Weekend extends Day

case class Rate(customer: Customer, day: Day, price : Int)

class RateCard(){
  private var rates = List[Rate]();
  def add(rate: Rate) = {
    rates = rates :+ rate
  }

  def getPrice(customer: Customer, day: Day) : Int = {
    def searchRateFor(rate: Rate)= {
      if(rate.customer == customer && rate.day == day)
        true
      else
        false
    }
    val rate: Option[Rate] = rates.find(searchRateFor)
    rate.get.price
  }
}

case class Hotel(name : String, rating : Int){

  private val rateCard = new RateCard()

  def addRate(rate: Rate) = {
    rateCard.add(rate)
  }
  def getTotalCost(customer : Customer, days: Seq[Day]): Int = {
    val cost: Seq[Int] = days.map(day => rateCard.getPrice(customer,day))
    cost.sum
  }

}
class Manager(){
  private var hotels = List[Hotel]()
  def manage (hotel : Hotel) ={
    hotels = hotels :+ hotel
  }
  def getCheapestHotel(customer: Customer, days: Seq[Day]) : Hotel = {
//    hotels.minBy(hotel=> hotel.getTotalCost(customer, days), -hotel.rating)
    val costsOfAllHotels = hotels.map(hotel => hotel.getTotalCost(customer, days))
    val min = costsOfAllHotels.min
    val hotelsWithMinimumCost: List[Hotel] = hotels.filter(hotel => hotel.getTotalCost(customer, days)<=min)
    hotelsWithMinimumCost(0)
  }
}
val lakewood = new Hotel("Lakewood", 3)
val bridgewood = new Hotel("Bridgewood", 4)
val ridgewood = new Hotel("Ridgewood", 5)

lakewood.addRate(new Rate(Regular, Weekday, 110))
lakewood.addRate(new Rate(Rewards, Weekday, 80))
lakewood.addRate(new Rate(Regular, Weekend, 90))
lakewood.addRate(new Rate(Rewards, Weekend, 80))

bridgewood.addRate(new Rate(Regular, Weekday, 160))
bridgewood.addRate(new Rate(Rewards, Weekday, 110))
bridgewood.addRate(new Rate(Regular, Weekend, 90))
bridgewood.addRate(new Rate(Rewards, Weekend, 80))

ridgewood.addRate(new Rate(Regular, Weekday, 220))
ridgewood.addRate(new Rate(Rewards, Weekday, 100))
ridgewood.addRate(new Rate(Regular, Weekend, 150))
ridgewood.addRate(new Rate(Rewards, Weekend, 40))
val manager = new Manager()
manager.manage(lakewood)
manager.manage(bridgewood)
manager.manage(ridgewood)
val days = Seq(Weekday, Weekday, Weekend)
manager.getCheapestHotel(Regular, days).name
//val cost: Int = lakewood.getTotalCost(Regular, days)
//val cost1: Int = lakewood.getTotalCost(Rewards, days)
