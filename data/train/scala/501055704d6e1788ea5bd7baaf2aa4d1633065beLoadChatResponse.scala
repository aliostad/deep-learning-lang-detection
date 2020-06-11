package semester.service.chatwork.domain.service.response

import semester.service.chatwork.domain.model.message.Message
import semester.service.chatwork.domain.service.request.LoadChatRequest
import org.json4s.JValue

case class LoadChatResponse(rawResponse: JValue,
                            request: LoadChatRequest,
                            chatList: Seq[Message] = Seq(),
                            description: Option[String] = None,
                            publicDescription: Option[String] = None)
  extends ChatWorkResponse {
  type Request = LoadChatRequest
}