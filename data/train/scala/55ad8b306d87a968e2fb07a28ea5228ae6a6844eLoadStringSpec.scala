package com.github.gigurra.io

import org.scalatest._
import org.scalatest.mock._

import scala.language.postfixOps

class LoadStringSpec
  extends WordSpec
  with MockitoSugar
  with Matchers
  with OneInstancePerTest {

  "LoadString" should {

    "Load Some(..) from local resource" in {
      LoadString.from("testfile.txt").map(_.trim) shouldBe Some("abc123")
    }

    "Load Some(..) from global resource" in {
      LoadString.from("testfileg.txt").map(_.trim) shouldBe Some("abc123g")
    }

    "Load Some(..) from global file" in {
      LoadString.from("build.sbt").map(_.trim).exists(_.contains("libgurra")) shouldBe true
    }

    "Load None if no source exists" in {
      LoadString.from("no-such-file") shouldBe None
      LoadString.from("testfile.txt", lookForLocalResource = false) shouldBe None
      LoadString.from("testfileg.txt", lookForGlobalResource = false) shouldBe None
      LoadString.from("build.sbt", lookForFile = false) shouldBe None
    }
  }
}
