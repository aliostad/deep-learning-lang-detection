package bowling.domain

import org.scalatest.FreeSpec

class MatchTest extends FreeSpec with DomainHelpers {
  "addPlayer" - {
    "should return a copy of the Match with the player added" in {
      val oldMatch = createMatch()
      val player = createPlayer()

      val updatedMatch = oldMatch.addPlayer(player)

      assert(updatedMatch != oldMatch)
      assert(updatedMatch.players === Set(player))
    }
    "should not overwrite other players" in {
      val oldMatch = createMatch()
      val player1 = createPlayer()
      val player2 = createPlayer()

      val updatedMatch = oldMatch.addPlayer(player1).addPlayer(player2)

      assert(updatedMatch != oldMatch)
      assert(updatedMatch.players === Set(player1, player2))
    }
  }
}
