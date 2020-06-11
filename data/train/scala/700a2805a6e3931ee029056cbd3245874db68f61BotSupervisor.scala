package com.amxl.redditdespammer

import akka.actor.{Props, ActorRef, Actor}
import scala.collection.mutable

class BotSupervisor(val manageStore: ActorRef, val rateLimitedHttp: ActorRef) extends Actor {
  private val botActors : mutable.Map[String, ActorRef] = mutable.Map[String, ActorRef]()

  override def preStart() = {
    manageStore ! SubscribeToBots()
  }

  def receive: Actor.Receive = {
    case BotAdded(botName, botRedditUsername, botRedditPassword) =>
      if (botName != "all") {
        val client = context.actorOf(Props(classOf[RedditClient], manageStore, rateLimitedHttp, botName,
          botRedditUsername, botRedditPassword))
        botActors.put(botName, client)
      }
    case r@BotRemoved(botName) =>
      botActors.get(botName) foreach(_ ! r)
      botActors.remove(botName)
  }
}
