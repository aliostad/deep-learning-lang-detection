/**
 * Created by stpyang on 4/29/14.
 */
object Problem017 {
  def apply(n: Int) = new Problem017(n)

  def main(args: Array[String]) = println(Problem017(1000).solve)

  private def write(n: Int): String = {
    if (n == 0) ""
    else if (n < 20) n match {
      case 1 => "one"
      case 2 => "two"
      case 3 => "three"
      case 4 => "four"
      case 5 => "five"
      case 6 => "six"
      case 7 => "seven"
      case 8 => "eight"
      case 9 => "nine"
      case 10 => "ten"
      case 11 => "eleven"
      case 12 => "twelve"
      case 13 => "thirteen"
      case 14 => "fourteen"
      case 15 => "fifteen"
      case 16 => "sixteen"
      case 17 => "seventeen"
      case 18 => "eighteen"
      case 19 => "nineteen"
    } else if (n < 100) n / 10 match {
      case 2 => "twenty" + write(n % 10)
      case 3 => "thirty" + write(n % 10)
      case 4 => "forty" + write(n % 10)
      case 5 => "fifty" + write(n % 10)
      case 6 => "sixty" + write(n % 10)
      case 7 => "seventy" + write(n % 10)
      case 8 => "eighty" + write(n % 10)
      case 9 => "ninety" + write(n % 10)
    }
    else if (n < 1000 && n % 100 == 0) write(n / 100) + "hundred"
    else if (n < 1000) write(n / 100) + "hundredand" + write(n % 100)
    else if (n == 1000) "onethousand"
    else throw new IllegalArgumentException("n out of bounds!")
  }
}

class Problem017(n: Int) {
  def solve = (1 to n).map(Problem017.write(_).length).sum
}
