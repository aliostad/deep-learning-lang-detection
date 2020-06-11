package elkorn.playground.distributed.dashboard.write

import elkorn.playground.distributed.dashboard.data.{ Fare, Trip }
import elkorn.playground.distributed.dashboard.write.WriterComponent.WriteResult

import scala.concurrent.Future

object WriterComponent {
  sealed trait WriteResult

  object WriteResult {
    object Success extends WriteResult
    object Failure extends WriteResult
  }
}

trait WriterComponent {
  def writer: Writer

  trait Writer {
    def writeFare(fare: Fare): Future[WriteResult]
    def writeTrip(trip: Trip): Future[WriteResult]
  }
}
