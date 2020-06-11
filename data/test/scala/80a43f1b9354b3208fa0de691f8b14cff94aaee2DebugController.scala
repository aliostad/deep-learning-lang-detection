package controllers

import java.security.SecureRandom
import javax.inject.Inject

import models._
import play.api.i18n.{I18nSupport, MessagesApi}
import play.api.mvc._
import services._

import scala.concurrent.ExecutionContext.Implicits.global
import scala.concurrent.Future
import scala.util.Random


class DebugController @Inject()(val messagesApi: MessagesApi,
                                val manageUserService: ManageUserService,
                                val manageTweetService: ManageTweetService,
                                val manageUservectorService: ManageUservectorService,
                                val manageGroupService: ManageGroupService,
                                val graphService: GraphService)
  extends Controller with I18nSupport {

  def tweetList = Action.async { implicit rs =>
    manageTweetService.getTweets.flatMap { tweets =>
      manageUserService.getUsersByUserIdList(tweets.map(_.user_id))
        .map { users =>
          val tweetsWithUser = tweets.map { tweet =>
            (tweet, users.find(user => user.id == tweet.user_id))
          }.filter { case (tweet, user) => user.isDefined }
            .map { case (tweet, user) => (tweet, user.get) }
          Ok(views.html.debug.tweetlist(tweetsWithUser))
        }
    }
  }

  def userList = Action.async { implicit rs =>

    manageUserService.getUsers
      .map { users =>
        Ok(views.html.debug.userlist(users))
      }
  }

  def getGraph = Action.async { implicit rs =>
    graphService.createGraph.map { case (uservecs, graph) =>
      Ok(views.html.debug.getgraph(uservecs, graph))
    }
  }

  def deleteGraph = Action.async { implicit rs =>
    manageGroupService.deleteAllGroups.map { f =>
      Ok(views.html.debug.deletegraph())
    }
  }

  def uploadBase = Action { implicit rs =>
      Ok(views.html.debug.upload())
  }
}

