package handlers.server

import handlers.GameClient
import handlers.packets.{PacketWriter, ServerCodes}

import scala.concurrent.ExecutionContext.Implicits.global
import scala.concurrent.Future

/**
  * Created by franblas on 15/04/17.
  */
class UpdateWeaponAndArmorStats(gameClient: GameClient) {
  def process(): Future[Array[Byte]] = {
    gameClient.player.map(_ => compute()).getOrElse(Future { Array.emptyByteArray })
  }

  private def compute(): Future[Array[Byte]] = {
    val writer = new PacketWriter(ServerCodes.updateWeaponAndArmorStats)
    writer.writeByte(0x05) // subcode
    writer.writeByte(0x06) //number of entries
    writer.writeByte(0x00) //subtype
    writer.writeByte(0x00) // unk
    // // weapondamage
    // var wd = (int) (m_gameClient.Player.WeaponDamage(m_gameClient.Player.AttackWeapon)*100.0);
    // pak.WriteByte((byte) (wd/100));
    // ins += write_byte(0x00)
    writer.writeByte(0x00)
    writer.writePascalString(" ")
    // // pak.WriteByte((byte) (wd%100));
    // ins += write_byte(0x00)
    writer.writeByte(0x00)
    writer.writePascalString(" ")
    // // weaponskill
    // int ws = m_gameClient.Player.DisplayedWeaponSkill;
    // pak.WriteByte((byte) (ws >> 8));
    // ins += write_byte(0x00)
    writer.writeByte(0x00)
    writer.writePascalString(" ")
    //// pak.WriteByte((byte) (ws & 0xff));
    //ins += write_byte(0x00)
    writer.writeByte(0x00)
    writer.writePascalString(" ")
    //// // overall EAF
    //// int eaf = m_gameClient.Player.EffectiveOverallAF;
    //// pak.WriteByte((byte) (eaf >> 8));
    //ins += write_byte(0x00)
    writer.writeByte(0x00)
    writer.writePascalString(" ")
    // pak.WriteByte((byte) (eaf & 0xff));
    writer.writeByte(0x00)
    writer.writePascalString(" ")
    writer.toFinalFuture()
  }
}
