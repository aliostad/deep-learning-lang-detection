package shapiro.netfauxgo

import scala.concurrent.stm._
import akka.actor.ActorRef
import scala.math.atan2
import scala.math.max
import scala.math.min

abstract class MovableAgent(world: World) extends Agent(world) {

  setProperty("heading", 360 * scala.math.random)

  def this(world:World, x:Double, y:Double) = {
	this(world)
	data.setPosition(x, y)
  }

  def forward(steps: Double) = {
    atomic {
      implicit txn => {
        val oldPatch = currentPatch()
        val oldPosition = data.getPosition()
        val oldX = oldPosition._1
        val oldY = oldPosition._2
        val heading = data.getProperty("heading").asInstanceOf[Double]
        var newX = (oldX + steps * scala.math.cos(scala.math.Pi * (heading / 180.0))) % world.width
        var newY = (oldY + steps * scala.math.sin(scala.math.Pi * (heading / 180.0))) % world.height

        while (newY < 0)
          newY += world.height
        while (newX < 0)
          newX += world.width

        data.setPosition(min(max(newX, 0), world.width - 1), min(max(newY, 0), world.height - 1))

        val newPatch = currentPatch()

        if (oldPatch != newPatch) {
          world.agentPatchMover ! MovePatches(self, oldPatch, newPatch)
        }
      }
    }
  }

  def heading = {
    data.getProperty("heading").asInstanceOf[Double]
  }

  def position = {
    data.getPosition()
  }

  def turn_right(degrees: Double) = {
    atomic {
      implicit txn =>
        val oldHeading = getProperty("heading").asInstanceOf[Double]
        setProperty("heading", (oldHeading - degrees) % 360)
    }
  }

  def turn_left(degrees: Double) = {
    turn_right(0 - degrees)
  }

  def turn_toward(patch:ActorRef):Unit = {
    data.setProperty("heading", angle_toward(patch))
  }

  def angle_toward(patch:ActorRef) = {
    val patch_position = getActorPosition(patch)
    val patch_x = patch_position._1
    val patch_y = patch_position._2
    val my_position = position
    val my_x = my_position._1
    val my_y = my_position._2

	val delta_x = patch_x - my_x
    val delta_y = patch_y - my_y
    atan2(delta_y, delta_x).toDegrees % 360
  }


}