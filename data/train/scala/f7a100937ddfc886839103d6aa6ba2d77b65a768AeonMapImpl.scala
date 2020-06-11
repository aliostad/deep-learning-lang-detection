/*
                    ,i::,
               :;;;;;;;
              ;:,,::;.
            1ft1;::;1tL
              t1;::;1,
               :;::;               _____       __  ___              __
          fCLff ;:: tfLLC         / ___/      /  |/  /____ _ _____ / /_
         CLft11 :,, i1tffLi       \__ \ ____ / /|_/ // __ `// ___// __ \
         1t1i   .;;   .1tf       ___/ //___// /  / // /_/ // /__ / / / /
       CLt1i    :,:    .1tfL.   /____/     /_/  /_/ \__,_/ \___//_/ /_/
       Lft1,:;:       , 1tfL:
       ;it1i ,,,:::;;;::1tti      AeonDB
         .t1i .,::;;; ;1tt        Copyright (c) 2014 S-Mach, Inc.
         Lft11ii;::;ii1tfL:       Author: lance.gatlin@gmail.com
          .L1 1tt1ttt,,Li
            ...1LLLL...
*/
package s_mach.aeondb.impl

import java.util.concurrent.ConcurrentSkipListMap
import org.joda.time.Instant
import scala.concurrent.{ExecutionContext, Future}
import s_mach.concurrent._
import s_mach.datadiff._
import s_mach.aeondb._
import s_mach.aeondb.internal._

//object AeonMapImpl {
//  def apply[A,B,PB](kv:(A,B)*)(implicit
//    ec: ExecutionContext,
//    dataDiff:DataDiff[B,PB]
//    ) : AeonMapImpl[A,B,PB] = {
//    val now = Instant.now()
//    new AeonMapImpl[A,B,PB](
//      _baseAeon = Aeon(now,now),
//      _baseState = MaterializedMoment(kv:_*),
//      zomBaseCommit = Nil
//    )
//  }
//}

class AeonMapImpl[A,B,PB](
  _baseAeon: Aeon = { val now = Instant.now; Aeon(now,now) },
  _baseState: MaterializedMoment[A,B] = MaterializedMoment.empty[A,B],
  zomBaseCommit: List[(List[Commit[A,B,PB]],Metadata)] = Nil
)(implicit
  val executionContext: ExecutionContext,
  val dataDiff:DataDiff[B,PB]
) extends AeonMap[A,B,PB] { self =>
  import AeonMap._

  protected def unsafeOnCommitHook(oomCommit: List[(Commit[A,B,PB],Metadata)]) : Unit = { }

  override val base = BaseMomentImpl[A,B,PB](
    aeonMap = this,
    aeon = _baseAeon,
    local = _baseState
  )

  val whenToOldState : ConcurrentSkipListMap[Long,OldMomentImpl[A,B,PB]] = {
    val m = new ConcurrentSkipListMap[Long,OldMomentImpl[A,B,PB]]()
    m.put(_baseAeon.end.getMillis, base)
    m
  }

  def print : String = {
    import scala.collection.JavaConverters._
    val sb = new StringBuilder
    sb.append(s"base.aeon=${base.aeon}\n")
    sb.append("whenToOldState\n")
    whenToOldState.descendingMap().entrySet().asScala.foreach { entry =>
      sb.append(s"${new Instant(entry.getKey)} => ${entry.getValue}\n")
    }
    sb.result()
  }


  override def zomCommit: Future[List[(Commit[A,B,PB], Metadata)]] = {
    import scala.collection.JavaConverters._
    whenToOldState
      .entrySet.asScala
      .iterator
      .flatMap { entry =>
        entry.getValue.oomCommit
      }
      .toList
      .reverse
  }.future


  val NoOldMoment = EmptyOldMomentImpl[A,B,PB](
    aeonMap = this,
    endTime = _baseAeon.start.minus(1)
  )

  override def old(when: Instant): OldMomentImpl[A,B,PB] = {
    val key = whenToOldState.floorKey(when.getMillis)
    whenToOldState.get(key) match {
      case null => NoOldMoment
      case v => v
    }
  }

  def mostRecentOldMoment = whenToOldState.lastEntry.getValue


  // Note: need _commitFold for f: OldMoment => (commitFold is Moment[A,B] => ...)
  def _commitFold[X](
    f: OldMomentImpl[A,B,PB] => Future[(Checkout[A],List[(Commit[A,B,PB],Metadata)],X)],
    g: Exception => X
  ) : Future[X] = {
    def loop() : Future[X] = {
      val lastEntry = whenToOldState.lastEntry
      val nextAeon = Instant.now()
      val currentMoment = lastEntry.getValue
      for {
        (checkout,oomCommit, x) <- f(currentMoment)
        result <- {
          val missingCheckout = calcMissingCheckout(checkout,currentMoment)
          if(missingCheckout.isEmpty) {
            if(oomCommit.nonEmpty) {
              val nextMoment = LazyOldMomentImpl(
                aeonMap = this,
                aeon = Aeon(
                  start = currentMoment.aeon.end.plus(1),
                  end = Instant.now()
                ),
                oomCommit = oomCommit
              )
              def innerLoop(lastEntry: java.util.Map.Entry[Long,OldMomentImpl[A,B,PB]]) : Future[X] = {
                // Note: need synchronized here to ensure no new states are inserted
                // during check-execute below -- lock time has been minimized
                if(compareAndSetNowMoment(lastEntry,nextMoment)) {
                  x.future
                } else {
                  // State changed during computation
                  val updatedLastEntry = whenToOldState.lastEntry
                  val updatedState = updatedLastEntry.getValue
                  if(canCommit(checkout, updatedState)) {
                    // If checkouts have not changed then just retry without
                    // recomputing commit
                    innerLoop(updatedLastEntry)
                  } else {
                    // At least one checkout changed, have to recompute commit
                    loop()
                  }
                }

              }
              innerLoop(lastEntry)
            } else {
              g(EmptyCommitError()).future
            }
          } else {
            g(KeyNotFoundError(missingCheckout)).future
          }
        }
      } yield result
    }
    loop()
  }

  def _mergeFold[X](
    f: Moment[A,B] => Future[(AeonMap[A,B,PB],X)],
    g: Exception => X
  )(implicit metadata: Metadata) : Future[X] = {
    def loop() : Future[X] = {
      val lastEntry = whenToOldState.lastEntry
      val currentMoment = whenToOldState.lastEntry.getValue
      for {
        (other, x) <- f(currentMoment)
        otherBase = other.base
        otherActive <- otherBase.active.toMap
        otherInactive <- otherBase.inactive.toMap
        zomCommit <- other.zomCommit
        result <- {
          if(zomCommit.nonEmpty) {
            val checkout =
              (otherActive.map { case (key,record) => (key,record.version)}) ++
              (otherInactive.map { case (key,record) => (key,record.version)})
            val missingCheckout = calcMissingCheckout(checkout,currentMoment)
            if(missingCheckout.isEmpty) {
              val checkoutVersionMismatch = calcCheckoutVersionMismatch(checkout, currentMoment)
              if (checkoutVersionMismatch.isEmpty) {
                val nextMoment = LazyOldMomentImpl(
                  aeonMap = this,
                  aeon = Aeon(
                    start = currentMoment.aeon.end,
                    end = Instant.now()
                  ),
                  oomCommit = zomCommit
                )
                if (compareAndSetNowMoment(lastEntry, nextMoment)) {
                  x.future
                } else {
                  loop()
                }
              } else {
                g(MergeConflictError(checkoutVersionMismatch)).future
              }
            } else {
              g(KeyNotFoundError(missingCheckout)).future
            }
          } else {
            x.future
          }
        }
      } yield result
    }
    loop()
  }

  def compareAndSetNowMoment(
    lastEntry: java.util.Map.Entry[Long,OldMomentImpl[A,B,PB]],
    nextMoment: LazyOldMomentImpl[A,B,PB]
  ): Boolean = {
    whenToOldState.synchronized {
      if (lastEntry.getKey == whenToOldState.lastEntry.getKey) {
        whenToOldState.put(nextMoment.aeon.end.getMillis, nextMoment)
        unsafeOnCommitHook(nextMoment.oomCommit)
        true
      } else {
        false
      }
    }
  }

  def calcMissingCheckout(
    checkout: Checkout[A],
    currentMoment: OldMomentImpl[A,B,PB]
  ) : Iterable[A] = {
    checkout
      .filterNot { case (key,version) =>
        currentMoment.local.active.contains(key) ||
        currentMoment.local.inactive.contains(key)
      }
      .keys
  }

  def canCommit(checkout: Checkout[A], moment: OldMomentImpl[A,B,PB]) : Boolean = {
    // Check if any of commit's checkout versions changed
    checkout.forall { case (key,version) =>
      val record =
        moment.local.active.get(key) match {
          case Some(_record) => _record
          case None => moment.local.inactive(key)
        }
      record.version == version
    }
  }

  def calcCheckoutVersionMismatch(
    checkout: Checkout[A],
    currentMoment: OldMomentImpl[A,B,PB]
  ) : Iterable[VersionMismatch[A]] = {
    // Note: assumed here that all checkout keys exist
    checkout.flatMap { case (key,expectedVersion) =>
      val record =
        currentMoment.local.active.get(key) match {
          case Some(_record) => _record
          case None =>
            // Note: if record isn't active is has to be inactive since
            // checkouts are confirmed to exist
            currentMoment.local.inactive(key)
        }

      if(record.version == expectedVersion) {
        None
      } else {
        Some(
          VersionMismatch(
            key = key,
            expectedVersion = expectedVersion,
            version = record.version
          )
        )
      }
    }
  }


  override def now = NowMomentImpl[A,B,PB](
    aeonMap = this,
    oldMoment = mostRecentOldMoment
  )

  override def future(
    f: FutureMoment[A,B,PB] => Future[FutureMoment[A,B,PB]]
  )(implicit metadata: Metadata): Future[Boolean] = {
    for {
      futureMoment <- f(FutureMomentImpl(mostRecentOldMoment))
      result <- {
        val (checkout,commit) = futureMoment.asInstanceOf[FutureMomentImpl[A,B,PB]].builder.result()
        now.commit(checkout, (commit,metadata) :: Nil)
      }
    } yield result
  }
}
