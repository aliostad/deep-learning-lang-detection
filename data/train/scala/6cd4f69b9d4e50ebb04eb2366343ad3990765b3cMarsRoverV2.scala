package MarsRover

class Position(curX: Int, curY: Int, direction: Direction) {

  def outOfTheGridChecker(x: Int, y: Int, maxX: Int, maxY: Int): (Int, Int) = {
    (x, y) match {
      case (a, b) if a < 0 || b < 0 || a > maxX || b > maxY => throw new Exception("The Mars Rover has gone off the grid")

      case _ => (x, y)
    }
  }

  def returnCurrentValues(): (Int, Int, Direction) = {
    (curX, curY, direction)
  }

}

class RoverManager(maxX: Int, maxY: Int) {
  def manage(input: String, pos: Position): Position = {
    val inputList = input.split("").toList
    val rover = new MarsRoverV2
    val result: Position = recursiveManage(pos, inputList, rover)

    val (x,y,dir) = result.returnCurrentValues()
    val (finalx, finaly) = pos.outOfTheGridChecker(x,y,maxX, maxY)
    result
  }

  def recursiveManage(pos: Position, inputList: List[String], rover: MarsRoverV2): Position = {
    inputList match {
      case Nil => {
        pos
      }

      case "L" :: rest => {
        val (curX, curY, direction) = pos.returnCurrentValues()
        val dir: Direction = rover.rotate(direction, "L")

        recursiveManage(new Position(curX, curY, dir), rest, rover)
      }

      case "R" :: rest => {
        val (curX, curY, direction) = pos.returnCurrentValues()
        val dir: Direction = rover.rotate(direction, "R")

        recursiveManage(new Position(curX, curY, dir), rest, rover)
      }

      case "M" :: rest => {
        val (curX, curY, direction) = pos.returnCurrentValues()
        val (x,y) = rover.move(curX, curY, direction)

        recursiveManage(new Position(x, y, direction), rest, rover)
      }
      case _ => throw new IllegalArgumentException("Invalid input string")
    }
  }
}

class MarsRoverV2 {
  def move(curX: Int, curY: Int, direction: Direction): (Int, Int) = {
    direction.moveAhead(curX, curY)
  }

  def rotate(direction: Direction, input: String): Direction = {
    input match {
      case "L" => direction.rotateLeft()

      case "R" => direction.rotateRight()
    }
  }
}