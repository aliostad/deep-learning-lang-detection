package com.kubukoz.adventofcode2016

import scala.annotation.tailrec
import scala.language.postfixOps

object Day13 {
  type State = (Int, Int)

  def findShortestRouteTo(x: Int, y: Int, salt: Int): Int = {
    def isOpen(x: Int, y: Int): Boolean = {
      (x * x + 3 * x + 2 * x * y + y + y * y + salt).toBinaryString.count(_ == '1') % 2 == 0
    }

    def nextPossibilities: State => Set[State] = {
      case (oldX, oldY) =>
        for {
          (newX, newY) <- Set((oldX - 1, oldY), (oldX + 1, oldY), (oldX, oldY - 1), (oldX, oldY + 1))
          if newX >= 0
          if newY >= 0
          if isOpen(newX, newY)
        } yield (newX, newY)
    }

    val isComplete = (x, y) == _

    @tailrec
    def goRec(possibilities: Set[State], alreadySeen: Set[State], depth: Int): Int = {
      if (possibilities.exists(isComplete)) depth
      else goRec(possibilities.flatMap(nextPossibilities) -- alreadySeen, alreadySeen ++ possibilities, depth + 1)
    }

    goRec(nextPossibilities((1, 1)), Set.empty, 1)
  }

  def main(args: Array[String]): Unit = {
    println(findShortestRouteTo(x = 31, y = 39, salt = 1352))
  }
}
