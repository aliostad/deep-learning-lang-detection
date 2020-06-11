package com.robocubs4205.cubscout.model.access

import scala.util.{Failure, Success, Try}

/**
  * A specific permission a client has
  * Unless otherwise specified, a client can only perform the actions allowed by a scope if the user of the client
  * is authorized to do so
  */
sealed trait Scope

object Scope {
  def parseSet(string:String):Try[Set[Scope]] = {
    val (successes,failures) = string.split(" ").toSet.filter(_!="").map(parse).partition(_.isSuccess)
    if(failures.isEmpty) Success(successes.map(_.get))
    else Failure(failures.head.failed.get)
  }

  def toString(scopes:Set[Scope]) = scopes.map(_.toString()).mkString(" ")

  def parse(string:String):Try[Scope] = string match {
    case SCORE_MATCHES => Success(ScoreMatches)
    case MANAGE_SCORED_MATCHES => Success(ManageScoredMatches)
    case READ_RESULTS => Success(ReadResults)
    case MANAGE_EVENTS => Success(ManageEvents)
    case MANAGE_GAMES => Success(ManageGames)
    case MANAGE_TEAM => Success(ManageTeam)
    case MANAGE_SCORECARDS => Success(ManageScorecards)
    case _ => Failure(new IllegalArgumentException(s"invalid scope $string"))
  }

  /**
    * App is allowed to score matches
    */
  case object ScoreMatches extends Scope{
    override def toString = SCORE_MATCHES
  }

  /**
    * App is allowed to score matches and can edit and delete scores that have been submitted
    * Implies `ScoreMatches`
    */
  case object ManageScoredMatches extends Scope{
    override  def toString = MANAGE_SCORED_MATCHES
  }

  /**
    * App is allowed to read results for individual matches and aggregate results for events and games
    */
  case object ReadResults extends Scope{
    override def toString = READ_RESULTS
  }

  /**
    * App is allowed to create, modify, and delete events
    */
  case object ManageEvents extends Scope{
    override def toString = MANAGE_EVENTS
  }

  /**
    * App is allowed to create, modify, and delete games
    */
  case object ManageGames extends Scope{
    override def toString = MANAGE_GAMES
  }

  /**
    * App is allowed to invite users to and kick users from your team
    */
  case object ManageTeam extends Scope{
    override def toString = MANAGE_TEAM
  }

  /**
    * App is allowed to create, modify, and delete Scorecards
    */
  case object ManageScorecards extends Scope{
    override def toString = MANAGE_SCORECARDS
  }

  private[this] val SCORE_MATCHES = "ScoreMatches"

  private[this] val MANAGE_SCORED_MATCHES = "ManageScoredMatches"

  private[this] val READ_RESULTS = "ReadResults"

  private[this] val MANAGE_EVENTS = "ManageEvents"

  private[this] val MANAGE_GAMES = "ManageGames"

  private[this] val MANAGE_TEAM = "ManageTeam"

  private[this] val MANAGE_SCORECARDS = "ManageScorecards"
}
