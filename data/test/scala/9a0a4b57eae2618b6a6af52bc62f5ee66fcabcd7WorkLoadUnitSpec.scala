package models

import org.scalacheck.Prop.forAll
import org.scalacheck.{Gen, Properties}

/**
 * Created by Jeff on 25/02/2016.
 */
class WorkLoadUnitSpec extends Properties("WorkLoadUnitSpec") {
  property("fromString should correctly create a workload from a string") = forAll(WorkLoadUnitSpec.ValidWorkLoadUnit) { workLoadUnit =>
    WorkLoadUnit.fromString(workLoadUnit.toString).get == workLoadUnit
  }
}

object WorkLoadUnitSpec {
  val ValidWorkLoadUnit = Gen.oneOf(xs = WorkLoadUnit.AllWorkLoadUnits.values.toSeq)
}
