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
package s_mach.aeondb

import org.joda.time.Instant

import scala.concurrent.ExecutionContext.Implicits.global
import org.scalatest.{FlatSpec, Matchers}
import s_mach.concurrent._

class AeonMapOldTest extends FlatSpec with Matchers {
  implicit val metadata = Metadata(
    who = "test",
    why = Some("test")
  )

  "AeonMap.old" must "return NoOldMoment for instants before base" in {
    val t1 = Instant.now()
    val m = Map(1 -> "a", 2 -> "b")
    val p = AeonMap(m.toSeq:_*)
    p.old(t1) should equal(p.NoOldMoment)
  }

  "AeonMap.NoOldMoment" must "be empty" in {
    val t1 = Instant.now()
    val m = Map(1 -> "a", 2 -> "b")
    val p = AeonMap(m.toSeq:_*)
    p.NoOldMoment.toMap.get should equal(Map.empty)
  }

  "AeonMap.old" must "toMap" in {
    val m = Map(1 -> "a", 2 -> "b")
    val p = AeonMap(m.toSeq:_*)
    val t1 = Instant.now()
    p.old(t1).toMap.get should equal(m)
  }

  "AeonMap.old" must "find" in {
    val m = Map(1 -> "a", 2 -> "b")
    val p = AeonMap(m.toSeq:_*)
    val t1 = Instant.now()
    p.old(t1).find(1).get should equal(Some("a"))
    p.old(t1).find(2).get should equal(Some("b"))
    p.old(t1).find(3).get should equal(None)
  }

  "AeonMap.old.checkout" must "create a duplicate AeonMap" in {
    val m = Map(1 -> "a", 2 -> "b")
    val p = AeonMap(m.toSeq:_*)
    val t1 = Instant.now()
    p.now.put(3,"c").get should equal(true)
    p.now.replace(1,"aa").get should equal(true)
    p.now.deactivate(2).get should equal(true)
    p.now.checkout().get.now.toMap.get should equal(
      Map(1 -> "aa", 3 -> "c")
    )
  }
}
