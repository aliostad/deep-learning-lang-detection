package semverfi

import org.specs._

object ShowSpec extends Specification {
  "showing versions" should {
    "show normal versions" in {
      Show(NormalVersion(1, 2, 3)) must_== "1.2.3"
    }
    "show pre-release versions" in {
      Show(PreReleaseVersion(1, 2, 3, Seq("alpha", "1"))) must_== "1.2.3-alpha.1"
    }
    "show build versions" in {
      Show(BuildVersion(1,2,3, Seq(), Seq("build", "1"))) must_== "1.2.3+build.1"
    }
    "show invalid versions" in {
      Show(Invalid("asdfasdf")) must_== "invalid: asdfasdf"
    }
  }
}
