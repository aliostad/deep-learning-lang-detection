package iotestbed.boat

import iotestbed.Vectorizable
import iotestbed.boat.classic.VesselDatabase_Classic
import iotestbed.boat.monadic.VesselDatabase_Each
import org.scalatest.FunSpec

/**
  * Created by ecastro on 30/10/16.
  */
class BoatTest_Each extends FunSpec {

  describe("The VesselDatabase test") {

    val input = "file:data.csv"

    var classicResult: Seq[String] = null

    val classic = new VesselDatabase_Classic()

    it("works in its classic version") {
      classic.run(input)

      classicResult = Schema.formatDump(classic.dump).sorted
    }

    val each = new VesselDatabase_Each()

    it("works in its Each version") {
      each.run(input)
    }

    it("returns the same result as the classic version") {
      val result = Schema.formatDump(Vectorizable.go(each.db.dump)).sorted

      assert(classicResult == result)
    }

  }

}
