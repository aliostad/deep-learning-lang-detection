package iotestbed.boat

import iotestbed.Vectorizable
import iotestbed.boat.classic.VesselDatabase_Classic
import iotestbed.boat.monadic.{VesselDatabase_FlatMap, VesselDatabase_ForNotation}
import org.scalatest.FunSpec

/**
  * Created by ecastro on 30/10/16.
  */
class BoatTest extends FunSpec {

  describe("The VesselDatabase test") {

    val input = "file:data.csv"

    var classicResult: Seq[String] = null

    val classic = new VesselDatabase_Classic()
    it("works in its classic version") {
      classic.run(input)

      classicResult = Schema.formatDump(classic.dump).sorted
    }

    val flatMap = new VesselDatabase_FlatMap();
    it("works in its FlatMap version") {
      flatMap.run(input)
    }

    it("FlatMap returns the same as the classic version") {
      val result = Schema.formatDump(Vectorizable.go(flatMap.db.dump)).sorted

      assert(classicResult == result)
    }

    val forNotation = new VesselDatabase_ForNotation()
    it("works in its ForNotation version") {
      forNotation.run(input)
    }

    it("ForNotation returns the same result as the classic version") {
      val result = Schema.formatDump(Vectorizable.go(forNotation.db.dump)).sorted

      assert(classicResult == result)
    }

  }

}
