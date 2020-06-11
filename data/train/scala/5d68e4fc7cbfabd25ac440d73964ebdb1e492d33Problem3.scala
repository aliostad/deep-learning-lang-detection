package problem001_010

import scala.math.BigInt.int2bigInt
import common.Problem

/**
 * The prime factors of 13195 are 5, 7, 13 and 29.
 * What is the largest prime factor of the number 600851475143 ?
 * @author moerie
 */

object Problem3  extends Problem {

  def solve() {
    val number = BigInt(600851475143L)
    println(largestPrimeFactor(number))
  }

  def largestPrimeFactor(bigNumber: BigInt) = {
    var old = bigNumber
    def loop(factor: BigInt, number: BigInt): BigInt = {
      if (old != number)
        println("loop: factor = " + factor + ", number = " + number)
      old = number
      if (factor == number) {
        number
      } else if (number % factor == 0) {
        loop(factor, number / factor)
      } else {
        loop(factor + 1, number)
      }
    }
    loop(BigInt(2), bigNumber)
  }

}