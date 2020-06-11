package com.gu.facebook_news_bot.state

import com.gu.facebook_news_bot.models.{Id, MessageFromFacebook, MessageToFacebook, User}
import com.gu.facebook_news_bot.services.{Capi, Facebook}
import com.gu.facebook_news_bot.state.StateHandler.Result
import com.gu.facebook_news_bot.stores.UserStore
import com.gu.facebook_news_bot.utils.ResponseText

import scala.concurrent.ExecutionContext.Implicits.global
import scala.concurrent.Future

case object UnsubscribeState extends State {
  val Name = "UNSUBSCRIBE_STATE"

  private object Patterns {
    val morningBriefing = """(^|\W)(morning|briefing)($|\W)""".r.unanchored
    val footballTransfers = """(^|\W)(football|transfers)($|\W)""".r.unanchored
    val all = """(^|\W)all($|\W)""".r.unanchored
    val cancel = """(^|\W)(cancel|none|no)($|\W)""".r.unanchored
  }

  def transition(user: User, messaging: MessageFromFacebook.Messaging, capi: Capi, facebook: Facebook, store: UserStore): Future[Result] = {
    val result: Option[Future[Result]] = State.getUserInput(messaging).map(_.toLowerCase) map {
      case Patterns.morningBriefing(_,_,_) => ManageMorningBriefingState.unsubscribe(user)
      case Patterns.footballTransfers(_,_,_) => FootballTransferStates.ManageFootballTransfersState.unsubscribe(user, store)
      case Patterns.all(_,_) =>
        for {
          (updated1, _) <- ManageMorningBriefingState.unsubscribe(user)
          (updated2, _) <- FootballTransferStates.ManageFootballTransfersState.unsubscribe(updated1, store)
        } yield {
          val message = MessageToFacebook.textMessage(user.ID, "Done.\n\nYou can re-subscribe at any time from the menu")
          (State.changeState(updated2, MainState.Name), List(message))
        }
      case Patterns.cancel(_,_,_) => MainState.menu(user, ResponseText.menu)
      case _ => question(user)
    }

    result getOrElse question(user)
  }

  def question(user: User): Future[Result] = {
    val briefing = if (user.notificationTime != "-") Some(MessageToFacebook.QuickReply("text", Some("Morning briefing"), Some("morning"))) else None
    val transfers = if (user.footballTransfers.contains(true)) Some(MessageToFacebook.QuickReply("text", Some("Football transfers"), Some("transfers"))) else None

    val quickReplies = List(
      briefing,
      transfers,
      Some(MessageToFacebook.QuickReply("text", Some("All"), Some("all"))),
      Some(MessageToFacebook.QuickReply("text", Some("Cancel"), Some("cancel")))
    ).flatten

    val message = MessageToFacebook.Message(
      text = Some("Which service would you like to unsubscribe from?"),
      quick_replies = Some(quickReplies)
    )
    val response = MessageToFacebook(
      recipient = Id(user.ID),
      message = Some(message)
    )
    Future.successful(State.changeState(user, Name), List(response))
  }
}
