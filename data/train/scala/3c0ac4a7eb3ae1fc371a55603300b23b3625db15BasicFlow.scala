package process

import akka.actor.{ActorContext, ActorRef}
import akka.persistence.{ AtLeastOnceDelivery, PersistentActor }
import processframework.{If, Par, ProcessStep, PersistentProcess}
import messages._

class BasicFlow extends PersistentProcess[State] {
  def emailActor: ActorRef = ???
  def fulfillmentActor: ActorRef = ???
  def financeActor: ActorRef = ???

  def persistenceId: String = "asdas"
  val sendToProcess = super.unhandled _

  val init: ProcessStep[State] = new InitStep()
  val sendMail: ProcessStep[State] = new EmailStep(emailActor)
  val startFulfillment: ProcessStep[State] = ???
  val updateFinance: ProcessStep[State] = ???
  val emailUpdate: ProcessStep[State] = ???

  val updateStock: ProcessStep[State] = ???
  val A: ProcessStep[State] = ???
  val B: ProcessStep[State] = ???
  val C: ProcessStep[State] = ???

  var state = State()

  override def receiveCommand = {
    case StartCmd =>
      val originalSender = sender()
      sendMail.onCompleteAsync( originalSender ! Ack )
      sendToProcess(StartCmd)
  }

  def process = init ~> sendMail ~> startFulfillment ~> Par(updateFinance, emailUpdate) ~> updateStock ~> If[State](_.fulfilled > 100)(A).Else(B) ~> C
}
