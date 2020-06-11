package MarsRover

import org.scalatest.FlatSpec
import org.scalatest.Matchers._

class RoverManagerTest extends FlatSpec {
  "MarsRoverV2" should "make sure the manage returns the appropriate output" in {
    val pos = new Position(1,1,North)
    val manager = new RoverManager(20,20)
    manager.manage("MMMMRMMM", pos).returnCurrentValues should be(new Position(4,5,East).returnCurrentValues())

    val exception = intercept[Exception]{
      manager.manage("LMM", pos)
      println(manager.manage("LMM", pos).returnCurrentValues())
    }
    exception.getMessage should be("The Mars Rover has gone off the grid")
  }
}
