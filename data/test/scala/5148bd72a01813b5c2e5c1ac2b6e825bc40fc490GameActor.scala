package it.interviews.tennisgame.boundary

import akka.actor.Actor.Receive
import it.interviews.tennisgame.domain.{GameStateData, PlayerIdWithPoints, Points}

/**
  * Created by Pietro Brunetti on 05/03/16.
  */
trait GameActor {

  protected def playing:Receive

  protected def init(players: PlayerActor*)
  protected def start
  protected def managePointMade(p:PlayerActor)
  protected def getPointsForPlayer(p:PlayerActor):Points
  protected def getScores()
  protected def getLeadPlayer:PlayerIdWithPoints
  protected def getGameState:GameStateData
  protected def registerNewParticipant(participant:ParticipantActor)
  protected def stop
}
