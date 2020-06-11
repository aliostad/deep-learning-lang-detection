package com.amxl.redditdespammer

import akka.actor._
import akka.contrib.throttle.TimerBasedThrottler
import scala.concurrent.duration._
import scala.language.postfixOps
import scala.Predef._
import scala.Some
import akka.contrib.throttle.Throttler.SetTarget
import akka.contrib.throttle.Throttler.Rate
import akka.io.IO
import spray.can.Http

case class Start()
class RootActor extends Actor {
  val manageStore = context.actorOf(Props[AdminCommandPersister], "manageStore")
  val sessionTracker = context.actorOf(Props(classOf[SessionTracker], manageStore), "sessionTracker")
  val manageConsole = context.actorOf(Props(classOf[ManageConsole], manageStore, sessionTracker), "manageConsole")

  implicit val theSystem = context.system

  def receive: Actor.Receive = {
    case Start() =>
      System.out.println("Starting up client...")
      manageConsole ! Start()

      val rateLimitedRedditHttp = context.actorOf(Props(classOf[TimerBasedThrottler], Rate(5, 10 seconds)),
        "rateLimitedRedditClient")
      rateLimitedRedditHttp ! SetTarget(Some(IO(Http)))

      context.actorOf(Props(classOf[BotSupervisor], manageStore, rateLimitedRedditHttp),
        "botSupervisor")

    case RedditResponse(str) =>
      System.out.println("Reddit response: " + str)
  }
}
