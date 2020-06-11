package semester.service.chatwork.domain.service.response

import semester.service.chatwork.domain.model.message.{Message, MessageId}
import semester.service.chatwork.domain.service.request.LoadOldChatRequest
import org.json4s.JValue

case class LoadOldChatResponse(rawResponse: JValue,
                               request: LoadOldChatRequest,
                               lastMessage: MessageId,
                               messages: Seq[Message])
  extends ChatWorkResponse {
  type Request = LoadOldChatRequest
}
