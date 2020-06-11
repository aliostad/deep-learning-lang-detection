package MarsRover

import org.scalatest.FlatSpec
import org.scalatest.Matchers._

/**
 * Created by romil93 on 24/02/15.
 */
class MarsRoverTest extends FlatSpec {
  "MarsRover" should "the rotate function should run properly" in {
    val rover = new MarsRover(5,5)
    rover.rotate(North, "L") should be(West)

    rover.rotate(West, "R") should be(North)

    rover.rotate(East, "L") should be(North)

    rover.rotate(South, "R") should be(West)
  }

  it should "the move function should run properly" in {
    val rover = new MarsRover(5,5)

    rover.move(1, 1, North) should be((1, 2))

    rover.move(3, 4, South) should be((3, 3))

    rover.move(4, 4, East) should be((5, 4))

    rover.move(4, 4, West) should be((3, 4))
  }

  it should "have the basic single input case run properly through the manage function" in {
    val rover = new MarsRover(10,10)

    rover.manage(1, 1, North, "L") should be((1, 1, "W"))
  }

  it should "off the grid exception test case should release an Exception" in {
    val rover = new MarsRover(10,10)
    val exception = intercept[Exception] {
      rover.manage(1, 1, North, "LMM") should be((3, 1, "E"))
    }
    exception.getMessage should be("The Mars Rover has gone off the grid")
  }

  it should "work for the test case 1" in {
    val rover = new MarsRover(5,5)
    rover.manage(1, 2, North, "LMLMLMLMM") should be((1, 3, "N"))
  }

  it should "work for test case 2" in {
    val rover = new MarsRover(5,5)
    rover.manage(3,3,East,"MMRMMRMRRM") should be((5, 1, "E"))
  }
}