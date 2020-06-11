package net.rayxiao

/**
  * Created by rxiao on 7/7/16.
  */
object IntegerToEnglishWord extends App {

  def isMultiple(value: Long): String = {
    if (value > 0) "s "
    else " "
  }

  def processIntInternal(remainingInt: Long): String = remainingInt match {
    case x if x >= 1000000000 => processInt(x / 1000000000) + "Billion" + isMultiple(x / 1000000000) + processInt(x % 1000000000)
    case x if x >= 1000000 => processInt(x / 1000000) + "Million" + isMultiple(x / 1000000) + processInt(x % 1000000)
    case x if x >= 1000 => processInt(x / 1000) + "Thousand" + isMultiple(x / 1000) + processInt(x % 1000)
    case x if x >= 100 => processInt(x / 100) + "Hundred" + isMultiple(x / 1000000000) + processInt(x % 100)
    case x if x >= 90 => "Ninety " + processInt(x - 90)
    case x if x >= 80 => "Eighty " + processInt(x - 80)
    case x if x >= 70 => "Seventy " + processInt(x - 70)
    case x if x >= 60 => "Sixty" + processInt(x - 60)
    case x if x >= 50 => "Fifty " + processInt(x - 50)
    case x if x >= 40 => "Forty " + processInt(x - 40)
    case x if x >= 30 => "Thirty " + processInt(x - 30)
    case x if x >= 20 => "Twenty " + processInt(x - 20)
    case x if x == 19 => "Nineteen "
    case x if x == 18 => "Eighteen "
    case x if x == 17 => "Seventeen "
    case x if x == 16 => "Sixteen "
    case x if x == 15 => "Fifteen "
    case x if x == 14 => "Fourteen "
    case x if x == 13 => "Thirteen "
    case x if x == 12 => "Twelve "
    case x if x == 11 => "Eleven "
    case x if x == 10 => "Ten "
    case x if x == 9 => "Nine "
    case x if x == 8 => "Eight "
    case x if x == 7 => "Seven "
    case x if x == 6 => "Six "
    case x if x == 5 => "Five "
    case x if x == 4 => "Four "
    case x if x == 3 => "Three "
    case x if x == 2 => "Two "
    case x if x == 1 => "One "
    case x if x == 0 => ""

  }

  def processInt(value: Long): String = {
    if (value == 0) "Zero"
    else processIntInternal(value)
  }

  println(processInt(123577623))
  println(processInt(0))
  println(processInt(10010))


}
