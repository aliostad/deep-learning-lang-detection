package com.thangiee.lolhangouts.data.usecases

import com.thangiee.lolchat.LoLChat
import com.thangiee.lolchat.error.NoSession
import com.thangiee.lolhangouts.data.Cached
import com.thangiee.lolhangouts.data.datasources.entities.SummSearchHistEntity
import com.thangiee.lolhangouts.data.datasources.entities.mappers.SummSearchHistMapper
import com.thangiee.lolhangouts.data.datasources.sqlite.DB
import com.thangiee.lolhangouts.data.usecases.entities.SummSearchHist
import com.thangiee.lolhangouts.data._

import scala.concurrent.ExecutionContext.Implicits.global
import scala.concurrent.Future

trait ManageSearchHistUseCase extends Interactor {
  def loadSummSearchHist(): Future[List[SummSearchHist]]
  def saveSummSearchHist(inGameName: String, regionId: String): Future[Unit]
}

case class ManageSearchHistUseCaseImpl() extends ManageSearchHistUseCase {

  def loadSummSearchHist(): Future[List[SummSearchHist]] = Future {
    val result = collection.mutable.ListBuffer[SummSearchHist]()
    result ++= DB.getAllSummSearchHist.map(SummSearchHistMapper.transform)

    LoLChat.findSession(Cached.loginUsername) match {
      case Good(sess) =>
        result ++= sess.friends.map(f => SummSearchHist(f.name, sess.region.id, isFriend = true))
      case Bad(NoSession(msg)) => warn(s"[!] $msg")
    }

    result.toList
  }

  def saveSummSearchHist(inGameName: String, regionId: String): Future[Unit] = Future {
    new SummSearchHistEntity(inGameName, regionId).save()
  }
}