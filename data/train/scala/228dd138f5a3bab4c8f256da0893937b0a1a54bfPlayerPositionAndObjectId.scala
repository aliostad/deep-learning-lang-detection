package handlers.server

import gameobjects.GamePlayer
import handlers.GameClient
import handlers.packets.{PacketWriter, ServerCodes}

import scala.concurrent.ExecutionContext.Implicits.global
import scala.concurrent.Future

/**
  * Created by franblas on 14/04/17.
  */
class PlayerPositionAndObjectId(gameClient: GameClient) {
  def process(): Future[Array[Byte]] = {
    gameClient.player.map(player => compute(player)).getOrElse(Future { Array.emptyByteArray })
  }

  private def compute(player: GamePlayer): Future[Array[Byte]] = {
    val writer = new PacketWriter(ServerCodes.playerPositionAndObjectId)
    // ins = write_short(player.object_id)
    writer.writeShort(player.objectId.toShort)
    // ins += write_short(player.current_position.get('Z'))
    writer.writeShort(player.currentPosition.z.toShort)
    // ins += write_int(player.current_position.get('X'))
    writer.writeInt(player.currentPosition.x)
    // ins += write_int(player.current_position.get('Y'))
    writer.writeInt(player.currentPosition.y)
    // ins += write_short(player.current_position.get('heading'))
    writer.writeShort(player.currentPosition.heading.toShort)

    // int flags = 0;
    var flags = 0

    // Zone zone = m_gameClient.Player.CurrentZone;
    // if (zone == null) return;
    // zone = '' // data['current_zone']
    // if not zone: return
    val zone = ""

    // if (m_gameClient.Player.CurrentZone.IsDivingEnabled)
    //     flags = 0x80 | (m_gameClient.Player.IsUnderwater ? 0x01 : 0x00);
    //
    // pak.WriteByte((byte)(flags));
    // ins += write_byte(flags)
    writer.writeByte(flags.toByte)

    // pak.WriteByte(0x00);	//TODO Unknown (Instance ID: 0xB0-0xBA, 0xAA-0xAF)
    // ins += write_byte(0x00)
    writer.writeByte(0x00)

    /*
    // if (zone.IsDungeon)
    // {
      //     pak.WriteShort((ushort)(zone.XOffset / 0x2000));
      //     pak.WriteShort((ushort)(zone.YOffset / 0x2000));
      // }
    // else
    // {
      //     pak.WriteShort(0);
      //     pak.WriteShort(0);
      // }
    ins += write_short(0x00)
    ins += write_short(0x00)
    */
    writer.writeShort(0x00)
    writer.writeShort(0x00)

    // //Dinberg - Changing to allow instances...
    // pak.WriteShort(m_gameClient.Player.CurrentRegion.Skin);
    // ins += write_short(int(player.current_region['region_id']))
    writer.writeShort(player.currentRegion.regionId.toShort)

    // pak.WritePascalString(GameServer.Instance.Configuration.ServerNameShort); // new in 1.74, same as in SendLoginGranted
    // ins += write_pascal_string('NAOC')
    writer.writePascalString("NAOC")

    // pak.WriteByte(0x00); //TODO: unknown, new in 1.74
    // ins += write_byte(0x00)
    writer.writeByte(0x00)

    writer.toFinalFuture()
  }
}
