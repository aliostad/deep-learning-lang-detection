import Problem17._
import org.scalatest.{ShouldMatchers, FunSpec}

class Problem17$Test extends FunSpec with ShouldMatchers {
  describe("Problem17") {
    it("write out 2 as two") {
      writeOutNumberInBritish("2") should equal("two")
    }

    it("write out 10 as ten") {
      writeOutNumberInBritish("10") should equal("ten")
    }

    it("write out 19 as nineteen") {
      writeOutNumberInBritish("19") should equal("nineteen")
    }

    it("write out 20 as twenty") {
      writeOutNumberInBritish("20") should equal("twenty")
    }

    it("write out 90 as ninety") {
      writeOutNumberInBritish("90") should equal("ninety")
    }

    it("write out 21 as twenty-one") {
      writeOutNumberInBritish("21") should equal("twenty-one")
    }

    it("write out 99 as ninety-nine") {
      writeOutNumberInBritish("99") should equal("ninety-nine")
    }

    it("write out 100 as one hundred") {
      writeOutNumberInBritish("100") should equal("one hundred")
    }

    it("write out 101 as one hundred and one") {
      writeOutNumberInBritish("101") should equal("one hundred and one")
    }

    it("write out 111 as one hundred and eleven") {
      writeOutNumberInBritish("111") should equal("one hundred and eleven")
    }

    it("write out 190 as one hundred and ninety") {
      writeOutNumberInBritish("190") should equal("one hundred and ninety")
    }

    it("write out 191 as one hundred and ninety-one") {
      writeOutNumberInBritish("191") should equal("one hundred and ninety-one")
    }

    it("write out 1000 as one thousand") {
      writeOutNumberInBritish("1000") should equal("one thousand")
    }

    it("should able to figure out the number of letters would be used for all the numbers from 1 to 1000 (one thousand) inclusive were written out in words") {
      numberOfLetters(1, 1000) should equal(21124)
    }
  }
}
