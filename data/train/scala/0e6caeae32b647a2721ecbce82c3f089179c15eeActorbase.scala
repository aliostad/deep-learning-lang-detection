
package io.actorbase.actor.main

import akka.actor.{Actor, Props}
import io.actorbase.actor.api.Api.Request._
import io.actorbase.actor.api.Api.Response._
import io.actorbase.actor.main.Actorbase.uuid
import io.actorbase.actor.storefinder.StoreFinder
import io.actorbase.actor.storefinder.StoreFinder.Request.Query
import io.actorbase.actor.storefinder.StoreFinder.Response.QueryAck
import io.actorbase.actor.storefinder.StoreFinder.{Request, Response}

/**
  * The MIT License (MIT)
  *
  * Copyright (c) 2015 - 2017 Riccardo Cardin
  *
  * Permission is hereby granted, free of charge, to any person obtaining a copy
  * of this software and associated documentation files (the "Software"), to deal
  * in the Software without restriction, including without limitation the rights
  * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  * copies of the Software, and to permit persons to whom the Software is
  * furnished to do so, subject to the following conditions:
  *
  * The above copyright notice and this permission notice shall be included in all
  * copies or substantial portions of the Software.
  *
  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  * SOFTWARE.
  *
  * Access to actorbase from the outside
  *
  * @author Riccardo Cardin
  * @version 0.1
  * @since 0.1
  */
class Actorbase extends Actor {

  override def receive: Receive = emptyDatabase

  def emptyDatabase: Receive = {
    case CreateCollection(name) => createCollection(name)
    case Find(collection, id) => replyFindOnNotExistingCollection(collection, id)
    case Upsert(collection, id, _) => replyInsertOnNotExistingCollection(collection, id)
    case Delete(collection, id) => replyDeleteOnNotExistingCollection(collection, id)
    case Count(collection) => replyCountOnNotExistingCollection(collection)
  }

  def nonEmptyDatabase(tables: Map[String, Collection], state: ActorbaseState): Receive = {
    manageCreations(tables, state)
      .orElse(manageQueries(tables, state))
      .orElse(manageUpserts(tables, state))
      .orElse(manageDeletions(tables, state))
      .orElse(manageCounts(tables, state))
  }

  private def manageCreations(tables: Map[String, Collection], state: ActorbaseState): Receive = {
    case CreateCollection(name) =>
      if (!tables.isDefinedAt(name)) createCollection(name)
      else sender() ! CreateCollectionNAck(name, s"Collection $name already exists")
  }

  private def manageQueries(tables: Map[String, Collection], state: ActorbaseState): Receive = {
    case Find(coll, id) =>
      tables.get(coll) match {
        case Some(collection) =>
          val u = uuid()
          collection.finder ! Query(id, u)
          context.become(nonEmptyDatabase(tables, state.addQuery(u, ActorbaseRequest(collection.name, sender()))))
        case None => replyFindOnNotExistingCollection(coll, id)
      }
    case QueryAck(key, value, u) =>
      val (maybeReq, newState) = state.removeQuery(u)
      maybeReq foreach(request =>
        request.sender ! FindAck(request.collection, key, value))
      context.become(nonEmptyDatabase(tables, newState))
  }

  private def manageUpserts(tables: Map[String, Collection], state: ActorbaseState): Receive = {
    case Upsert(coll, id, value) =>
      tables.get(coll) match {
        case Some(collection) =>
          val u = uuid()
          collection.finder ! Request.Upsert(id, value, u)
          context.become(nonEmptyDatabase(tables, state.addUpsert(u, ActorbaseRequest(collection.name, sender()))))
        case None => replyInsertOnNotExistingCollection(coll, id)
      }
    case Response.UpsertNAck(key, msg, u) =>
      val (maybeReq, newState) = state.removeUpsert(u)
      maybeReq foreach(request =>
        request.sender ! UpsertNAck(request.collection, key, msg))
      context.become(nonEmptyDatabase(tables, newState))
    case Response.UpsertAck(key, u) =>
      val (maybeReq, newState) = state.removeUpsert(u)
      maybeReq foreach(request =>
        request.sender ! UpsertAck(request.collection, key))
      context.become(nonEmptyDatabase(tables, newState))
  }

  private def manageDeletions(tables: Map[String, Collection], state: ActorbaseState): Receive = {
    case Delete(coll, id) =>
      tables.get(coll) match {
        case Some(collection) =>
          val u = uuid()
          collection.finder ! Request.Delete(id, u)
          context.become(nonEmptyDatabase(tables, state.addDeletion(u, ActorbaseRequest(collection.name, sender()))))
        case None => replyDeleteOnNotExistingCollection(coll, id)
      }
    case Response.DeleteAck(key, u) =>
      val (maybeReq, newState) = state.removeDeletion(u)
      maybeReq foreach(request =>
        request.sender! DeleteAck(request.collection, key))
      context.become(nonEmptyDatabase(tables, newState))
  }

  def manageCounts(tables: Map[String, Collection], state: ActorbaseState): Receive = {
    case Count(coll) =>
      tables.get(coll) match {
        case Some(collection) =>
          val u = uuid()
          collection.finder ! Request.Count(u)
          context.become(nonEmptyDatabase(tables, state.addCount(u, ActorbaseRequest(collection.name, sender()))))
        case None => replyCountOnNotExistingCollection(coll)
      }
    case Response.CountAck(count, u) =>
      val (maybeReq, newState) = state.removeCount(u)
      maybeReq foreach(request =>
        request.sender ! CountAck(request.collection, count))
      context.become(nonEmptyDatabase(tables, newState))
  }

  private def replyFindOnNotExistingCollection(collection: String, id: String): Unit = {
    sender() ! FindNAck(collection, id, s"Collection $collection does not exist")
  }

  private def replyInsertOnNotExistingCollection(collection: String, id: String): Unit = {
    sender() ! UpsertNAck(collection, id, s"Collection $collection does not exist")
  }

  private def replyDeleteOnNotExistingCollection(collection: String, id: String): Unit = {
    sender() ! DeleteNAck(collection, id, s"Collection $collection does not exist")
  }

  private def replyCountOnNotExistingCollection(collection: String): Unit = {
    sender() ! CountNAck(collection, s"Collection $collection does not exist")
  }

  private def createCollection(name: String): Unit = {
    try {
      val table = context.actorOf(Props(new StoreFinder(name)))
      sender() ! CreateCollectionAck(name)
      context.become(nonEmptyDatabase(Map(name -> Collection(name, table)), ActorbaseState()))
    } catch {
      case ex: Exception =>
        sender() ! CreateCollectionNAck(name, ex.getMessage)
    }
  }
}

object Actorbase {
  private def uuid(): Long = System.currentTimeMillis()
}
