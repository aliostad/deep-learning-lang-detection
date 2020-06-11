package capturetheflag

import scala.ozma._

import util._

class GamePlay(val master: Master) extends AdvancedStatelessPortObject {
  private val timeUnit = master.timeUnit
  private val mapSize = master.mapSize

  def synchronize(body: => Unit) = serialized {
    body
  }

  def delaySynchronize(time: Int)(body: => Unit) =
    delayedSerialized(time)(body)

  def movePlayer(player: Player, oldPos: Pos, newPos: Pos) {
    if (!(mapSize contains newPos))
      player.move(oldPos)
    else {
      // Players carrying a flag move twice as slowly as others
      val time = if (player.hasFlag) 2*timeUnit else timeUnit

      delayedSerialized(time) {
        execute(player, oldPos, newPos)
      }
    }
  }

  private def execute(player: Player, oldPos: Pos, newPos: Pos) = serialized {
    val oldSquare = master.squares(oldPos)
    val newSquare = master.squares(newPos)

    val oldPl= oldSquare.getPlayer

    if (oldPl.isEmpty || (oldPl.get ne player) || master.isTerminated) {
      // Player has been killed or game is finished: abort
    } else if (newSquare.isTeamMateOf(player)) {
      // Blocked by a team mate, but you can try again
      player.move(oldPos)
    } else {
      oldSquare.quit().waitFor()
      newSquare.enter(player).waitFor()
    }
  }
}
