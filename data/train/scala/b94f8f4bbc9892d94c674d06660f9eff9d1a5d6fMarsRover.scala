package MarsRover

/**
 * Created by romil93 on 24/02/15.
 */

class MarsRover(maxX: Int, maxY: Int) {
  def move(curX: Int, curY: Int, direction: Direction): (Int, Int) = {
    direction.name match {
      case "N" => {
        val (x,y) = North.moveAhead(curX, curY)
        outOfTheGridChecker(x, y)
      }
      case "S" => {
        val (x,y) = South.moveAhead(curX, curY)
        outOfTheGridChecker(x, y)
      }
      case "E" => {
        val (x,y) = East.moveAhead(curX, curY)
        outOfTheGridChecker(x, y)
      }
      case "W" => {
        val (x,y) = West.moveAhead(curX, curY)
        outOfTheGridChecker(x, y)
      }
    }
  }

  def outOfTheGridChecker(x: Int,y: Int): (Int, Int) ={
    (x,y) match {
      case (a, b) if a < 0 || b < 0 || a>maxX || b>maxY  => throw new Exception("The Mars Rover has gone off the grid")
      case _ => (x, y)
    }
  }

  def rotate(direction: Direction, input: String): Direction = {
    input match {
      case "L" => {
        direction.rotateLeft()
      }
      case "R" => {
        direction.rotateRight()
      }
    }
  }

  def manage(curX: Int, curY: Int, direction: Direction, input: String): (Int, Int, String) = {
    val inputList = input.split("").toList
    recursiveManage(curX, curY, direction, inputList)
  }

  def recursiveManage(curX: Int, curY: Int, direction: Direction, inputList: List[String]): (Int, Int, String) = {
    inputList match {
      case Nil => (curX, curY, direction.name)
      case "L" :: rest => {
        val dir: Direction = rotate(direction, "L")
        recursiveManage(curX, curY, dir, rest)
      }
      case "R" :: rest => {
        val dir: Direction = rotate(direction, "R")
        recursiveManage(curX, curY, dir, rest)
      }
      case "M" :: rest => {
        val (x,y) = move(curX, curY, direction)
        recursiveManage(x, y, direction, rest)
      }
      case _ => throw new IllegalArgumentException("Invalid input string")
    }
  }
}
