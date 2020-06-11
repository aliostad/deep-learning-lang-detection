package s_mach.aeondb.impl

import org.joda.time.Instant
import scala.concurrent.Future
import s_mach.aeondb.internal.OldMoment
import s_mach.aeondb._

trait OldMomentImpl[A,B,PB] extends OldMoment[A,B,PB] {
  override def filterKeys(f: (A) => Boolean): OldMomentImpl[A,B,PB]

  def oomCommit: List[(Commit[A,B,PB],Metadata)]
  def local: LocalMoment[A,B]

  override def checkout(): Future[AeonMapImpl[A,B,PB]] = {
    val now = Instant.now()
    val materializedMoment = local.materialize
    Future.successful {
      new AeonMapImpl(
        _baseAeon = aeon,
        _baseState = materializedMoment,
        zomBaseCommit = Nil
      )(
        executionContext = aeonMap.executionContext,
        dataDiff = aeonMap.dataDiff
      )
    }
  }
}
