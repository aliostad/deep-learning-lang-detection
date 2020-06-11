package semester.service.chatwork.domain.service.request

import semester.service.chatwork.domain.model.message.MessageId
import semester.service.chatwork.domain.service.ChatWorkIOContext
import semester.service.chatwork.domain.service.command.LoadOldChat
import semester.service.chatwork.domain.service.response.ChatWorkResponse

case class LoadOldChatRequest(lastMessage: MessageId)
  extends ChatWorkRequest {
  def execute(implicit context: ChatWorkIOContext): ChatWorkResponse = {
    LoadOldChat.execute(this)
  }
}

