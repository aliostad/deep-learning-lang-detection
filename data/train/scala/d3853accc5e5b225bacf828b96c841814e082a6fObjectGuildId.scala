package handlers.server

import handlers.packets.{PacketWriter, ServerCodes}

import scala.concurrent.Future

/**
  * Created by franblas on 15/04/17.
  */
class ObjectGuildId {
  def process(): Future[Array[Byte]] = {

    val writer = new PacketWriter(ServerCodes.objectGuildId)
    //// pak.WriteShort((ushort) obj.ObjectID);
    //ins = write_short(0x07)
    writer.writeShort(0x07)
    /*
    // if (guild == null)
    //   pak.WriteInt(0x00);
    // else
    // {
      //   pak.WriteShort(guild.ID);
      //   pak.WriteShort(guild.ID);
      // }
    ins += write_int(0x00)
    */
    writer.writeInt(0x00)
    //// pak.WriteShort(0x00); //seems random, not used by the client
    //ins += write_short(0x00)
    writer.writeShort(0x00)
    writer.toFinalFuture()
  }
}
