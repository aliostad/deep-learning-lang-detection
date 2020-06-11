package fr.jbu.asyncperf.user.api

import akka.actor.{ActorRef, Actor}
import fr.jbu.asyncperf.user.SequentialUserActor

class UserBuilder {

  var currentScenario: Scenario = _
  var dumpActor: Option[ActorRef] = None
  var logActor: Option[ActorRef] = None
  var httpClient: Option[ActorRef] = None
  var nbOfExecution: Int = 1

  def withScenario(scenario: Scenario): UserBuilder = {
    currentScenario = scenario
    this
  }

  def withBaseIdentifiant(baseIdentifiant: String): UserBuilder = {
    this
  }

  def withDumpActor(dumpActorRef: ActorRef): UserBuilder = {
    dumpActor = Some(dumpActorRef)
    this
  }

  def withLogActor(actorRef: ActorRef): UserBuilder = {
    logActor = Some(actorRef)
    this
  }

  def withHttpClientActor(actorRef: ActorRef): UserBuilder = {
    httpClient = Some(actorRef)
    this
  }

  def withNbOfExecution(nbExecution:Int): UserBuilder = {
    nbOfExecution = nbExecution
    this
  }

  def buildActor(nbActor: Int): Array[ActorRef] = {
    val actors = new Array[ActorRef](nbActor)
    for (i <- 0 until nbActor) {
      actors(i) = Actor.actorOf(new SequentialUserActor(currentScenario.getFunctionSequence, dumpActor, logActor, httpClient, true, nbOfExecution))
    }
    actors
  }

}