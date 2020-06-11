
import scala.concurrent._
import scala.concurrent.Future
import scala.util.Try
import ExecutionContext.Implicits.global

/**
 * Created by sacry on 27/05/14.
 */
object A10SingleShareTry extends App {

  case class Share(shareId: String, curPrice: Double)

  case class Order(shareId: String, price: Double, numOfShares: Int)

  class Broker {
    def shareInfo(shareId: String): Share =
      if (shareId == "SAP") Share("SAP", 499.00) else throw new Exception("shareInfo")

    def contract(order: Order): Order =
      if (order.shareId == "SAP" && order.price >= 500) order
      else throw new Exception("contract")
  }

  def connectToBroker(uri: String): Broker =
    if (uri != "") new Broker else throw new Exception("connectToBroker")

  def makeOrder(share: Share, priceLimit: Double): Order =
    if (share.curPrice <= priceLimit)
      Order("SAP", priceLimit, 100)
    else
      throw new Exception("makeOrder")

  def buyShares(brokerUri: String, shareId: String, price: Double): Try[Order] = {
    for {
      broker <- Try {
        connectToBroker(brokerUri)
      }
      order <- Try {
        makeOrder(broker.shareInfo(shareId), price)
      }
    } yield broker.contract(order)
  }

  val t = buyShares("123", "SAP", 499.50)
  println(t)
}

object A10ManyShareTry /*extends App*/ {

  case class Share(shareId: String, curPrice: Double)

  case class Order(shareId: String, price: Double, numOfShares: Int)

  class Broker {
    def shareInfo(shareId: String): Share =
      if (shareId == "SAP") Share("SAP", 499.00) else throw new Exception("shareInfo")

    def contract(order: Order): Order =
      if (order.shareId == "SAP" && order.price >= 500) order
      else throw new Exception("contract")
  }

  def connectToBroker(uri: String): Broker =
    if (uri != "") new Broker else throw new Exception("connectToBroker")

  def makeOrder(share: Share, priceLimit: Double): Order =
    if (share.curPrice <= priceLimit)
      Order("SAP", priceLimit, 100)
    else
      throw new Exception("makeOrder")

  def buyShares(brokerUri: String, shareIds: String*): Try[Seq[Try[Order]]] = {
    for {
      broker <- Try {
        connectToBroker(brokerUri)
      }
    } yield shareIds map (id => Try {
      broker.contract(makeOrder(broker.shareInfo(id), 500.0))
    })
  }

  println(buyShares("uri", "SAP", "SAP"))
  println(buyShares("", "SAP", "SAP"))
  println(buyShares("uri", "SAP", "SAP", "SA"))
}


object A10Future extends App {

  case class Share(shareId: String, curPrice: Double)

  case class Order(shareId: String, price: Double, numOfShares: Int)

  class Broker {
    def shareInfo(shareId: String): Share =
      MyUtil.exec(
        "shareInfo", 100L,
        if (shareId == "SAP") Share("SAP", 499.00) else throw new Exception("shareInfo"))

    def contract(order: Order): Order =
      MyUtil.exec(
        "contract", 200L,
        if (order.shareId == "SAP" && order.price >= 500) order
        else throw new Exception("contract"))
  }

  def connectToBroker(uri: String): Broker =
    MyUtil.exec(
      "connectToBroker", 300L,
      if (uri != "") new Broker else throw new Exception("connectToBroker"))

  def makeOrder(share: Share, priceLimit: Double): Order = MyUtil.exec(
    "makeOrder", 500L,
    if (share.curPrice <= priceLimit)
      Order("SAP", priceLimit, 100)
    else
      throw new Exception("makeOrder"))

  def buyShares[F](brokerUri: String, shareIds: String*): Future[Seq[Future[Order]]] = {
    for {
      broker <- Future {
        connectToBroker(brokerUri)
      }
    } yield shareIds map (id => Future(broker.contract(makeOrder(broker.shareInfo(id), 500.0))))
  }
  val res: Future[Seq[Future[Order]]] = buyShares("uri", "SAP", "SAP", "SA")

  val result = for {
    ls <- res
  } yield ls.map(MyUtil.await(_).value.get)

  MyUtil.await(result)
}