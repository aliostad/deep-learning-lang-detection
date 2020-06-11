package main.shared.communication

import main.shared.data._
import org.json.JSONObject
import main.server.JsonFiles.SaveJsons

abstract class MessageSender {
  val MessageBuilder = new MessageBuilder
  def writeLoginMessage(user: TwitterUser) = writeMessage(MessageBuilder.writeLogin(user))
  def writeMessage(json: JSONObject): Unit

  def writeLogout(user: TwitterUser): Unit = {
    writeMessage(MessageBuilder.writeLogout(user))
  }

  def writeData(serializable: Serializable): JSONObject ={
    val json:JSONObject = MessageBuilder.writeData(serializable)
    writeMessage(json)
    json
  }
}
