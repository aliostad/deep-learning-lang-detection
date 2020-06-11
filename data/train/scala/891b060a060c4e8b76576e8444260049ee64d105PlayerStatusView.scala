package view

import model.{GameSequence, Player, ShipPlan}
import flagship.console.control.Control
import flagship.console.terminal.Screen

/**
 * Created by mtrupkin on 3/12/14.
 */
class PlayerStatusView(val game: GameSequence) extends Control {
    import game._

    def render(screen: Screen) {
      screen.clear()
      screen.write(0, 0, "Commander")
      screen.write(0, 1, "   Phase: " + game.phase)
      screen.write(0, 2, "Movement: " + player.movement)
      screen.write(0, 3, "   Armor: " + player.armor)
      screen.write(0, 4, " Stamina: " + player.stamina)
      screen.write(0, 5, " Bitcoin: " + player.bitcoins)
    }
}
