package benoit.ocr

import benoit.UnitSpec
import benoit.ocr.DefaultOcrWriters._
import benoit.ocr.OcrSyntax._
import org.scalatest.DiagrammedAssertions

class OcrWriterSpec extends UnitSpec with DiagrammedAssertions {

  "OcrWriter" - {

    val expectedValues = Array(
      " _ \n| |\n|_|\n   \n",
      "   \n  |\n  |\n   \n",
      " _ \n _|\n|_ \n   \n",
      " _ \n _|\n _|\n   \n",
      "   \n|_|\n  |\n   \n",
      " _ \n|_ \n _|\n   \n",
      " _ \n|_ \n|_|\n   \n",
      " _ \n  |\n  |\n   \n",
      " _ \n|_|\n|_|\n   \n",
      " _ \n|_|\n _|\n   \n"
    )

    "should write OcrNumbers 0-9" in {

      forAll(0 to 9) { (i: Int) =>

        val ocr = OcrNumber(i+"")
        val expectedCharArray = expectedValues(i)

        info(s"OcrDigit(${ocr.value}) should serialise to\n${expectedCharArray.mkString}")
        ocr.write should have length 16
        ocr.write should be(expectedCharArray)
      }
    }


    "should write OcrNumber 000000000" in {

      val expected =
          " _  _  _  _  _  _  _  _  _ \n" +
          "| || || || || || || || || |\n" +
          "|_||_||_||_||_||_||_||_||_|\n" +
          "                           \n"

      OcrNumber("000000000").write shouldBe expected
    }

    "should write OcrNumber 111111111" in {

      val expected =
          "                           \n" +
          "  |  |  |  |  |  |  |  |  |\n" +
          "  |  |  |  |  |  |  |  |  |\n" +
          "                           \n"

      OcrNumber("111111111").write shouldBe expected
    }

    "should write OcrNumber 222222222" in {

      val expected =
          " _  _  _  _  _  _  _  _  _ \n" +
          " _| _| _| _| _| _| _| _| _|\n" +
          "|_ |_ |_ |_ |_ |_ |_ |_ |_ \n" +
          "                           \n"

      OcrNumber("222222222").write shouldBe expected
    }

    "should write OcrNumber 333333333" in {

      val expected =
          " _  _  _  _  _  _  _  _  _ \n" +
          " _| _| _| _| _| _| _| _| _|\n" +
          " _| _| _| _| _| _| _| _| _|\n" +
          "                           \n"

      OcrNumber("333333333").write shouldBe expected
    }

    "should write OcrNumber 444444444" in {

      val expected =
          "                           \n" +
          "|_||_||_||_||_||_||_||_||_|\n" +
          "  |  |  |  |  |  |  |  |  |\n" +
          "                           \n"

      OcrNumber("444444444").write shouldBe expected
    }

    "should write OcrNumber 5555555555" in {

      val expected =
          " _  _  _  _  _  _  _  _  _ \n" +
          "|_ |_ |_ |_ |_ |_ |_ |_ |_ \n" +
          " _| _| _| _| _| _| _| _| _|\n" +
          "                           \n"

      OcrNumber("555555555").write shouldBe expected
    }


    "should write OcrNumber 666666666" in {

      val expected =
          " _  _  _  _  _  _  _  _  _ \n" +
          "|_ |_ |_ |_ |_ |_ |_ |_ |_ \n" +
          "|_||_||_||_||_||_||_||_||_|\n" +
          "                           \n"

      OcrNumber("666666666").write shouldBe expected
    }

    "should write OcrNumber 777777777" in {

      val expected =
          " _  _  _  _  _  _  _  _  _ \n" +
          "  |  |  |  |  |  |  |  |  |\n" +
          "  |  |  |  |  |  |  |  |  |\n" +
          "                           \n"

      OcrNumber("777777777").write shouldBe expected
    }

    "should write OcrNumber 888888888" in {

      val expected =
          " _  _  _  _  _  _  _  _  _ \n" +
          "|_||_||_||_||_||_||_||_||_|\n" +
          "|_||_||_||_||_||_||_||_||_|\n" +
          "                           \n"

      OcrNumber("888888888").write shouldBe expected
    }

    "should write OcrNumber 999999999" in {

      val expected =
          " _  _  _  _  _  _  _  _  _ \n" +
          "|_||_||_||_||_||_||_||_||_|\n" +
          " _| _| _| _| _| _| _| _| _|\n" +
          "                           \n"

      OcrNumber("999999999").write shouldBe expected
    }

    "should write OcrNumber 123456789" in {

      val expected =
          "    _  _     _  _  _  _  _ \n" +
          "  | _| _||_||_ |_   ||_||_|\n" +
          "  ||_  _|  | _||_|  ||_| _|\n" +
          "                           \n"

      OcrNumber("123456789").write shouldBe expected
    }
  }
}
