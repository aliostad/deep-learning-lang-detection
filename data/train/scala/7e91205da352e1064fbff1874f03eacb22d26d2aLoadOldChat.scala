package semester.service.chatwork.domain.service.command

import semester.service.chatwork.domain.service.parser.MessageParser
import semester.service.chatwork.domain.service.request.LoadOldChatRequest
import semester.service.chatwork.domain.service.response.LoadOldChatResponse
import semester.service.chatwork.domain.service.{ChatWorkApi, ChatWorkIOContext}

object LoadOldChat
  extends ChatWorkCommand[LoadOldChatRequest, LoadOldChatResponse] {

  def execute(request: LoadOldChatRequest)(implicit context: ChatWorkIOContext): LoadOldChatResponse = {
    val json = ChatWorkApi.api(
      "load_old_chat",
      Map(
        "room_id" -> request.lastMessage.roomId.value.toString(),
        "first_chat_id" -> request.lastMessage.messageId.toString()
      )
    )

    LoadOldChatResponse(
      json,
      request,
      request.lastMessage,
      MessageParser.parseMessage(request.lastMessage.roomId, json)
    )
  }
}
