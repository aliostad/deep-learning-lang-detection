package handlers.server

import handlers.packets.{PacketWriter, PacketsUtils, ServerCodes}

import scala.concurrent.Future

/**
  * Created by franblas on 26/03/17.
  */
class LoginGranted(version: String, username: String) {

  def process(): Future[Array[Byte]] = {
    val writer = new PacketWriter(ServerCodes.loginGranted)
    writer.writeByte(0x01)
    writer.writeByte(PacketsUtils.parseVersion(version, true))
    writer.writeByte(PacketsUtils.parseVersion(version, false))
    writer.writeByte(0x00)
    writer.writePascalString(username)
    writer.writePascalString("NAOC") // server name
    writer.writeByte(0x0C)
    writer.writeByte(0x00)
    writer.writeByte(0x00)
    writer.writeByte(0x00)
    writer.toFinalFuture()
  }
}


