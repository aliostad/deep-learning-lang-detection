package handlers.server

import database.{Classes, Races}
import gameobjects.GamePlayer
import handlers.GameClient
import handlers.packets.{PacketWriter, ServerCodes}

import scala.concurrent.ExecutionContext.Implicits.global
import scala.concurrent.Future

/**
  * Created by franblas on 15/04/17.
  */
class UpdatePlayer(gameClient: GameClient) {

  private val classes = new Classes()
  private val races = new Races()

  def process(): Future[Array[Byte]] = {
    gameClient.player.map(player => compute(player)).getOrElse(Future { Array.emptyByteArray })
  }

  private def compute(player: GamePlayer): Future[Array[Byte]] = {
    val character = player.dbCharacter

    val writer = new PacketWriter(ServerCodes.updatePlayer)
    writer.writeByte(0x03)
    writer.writeByte(0x0F)
    writer.writeByte(0x00)
    writer.writeByte(0x00)

    // ins += write_byte(data['level'])
    writer.writeByte(character.level.toByte)
    // ins += write_pascal_string(data['name'])
    writer.writePascalString(character.name)
    // ins += write_byte(0x00)
    writer.writeByte(0x00)

    // char_class = get_class(data['char_class'])
    classes.getCharClass(character.charClass).flatMap(result => {
      val charClass = result.head

      // ins += write_pascal_string(char_class['char_class_name'])
      //writer.writePascalString(res.getString("char_class_name"))
      writer.writePascalString(charClass.characterClassName)

      // pak.WriteByte((byte) (player.MaxHealth & 0xFF)); // maxhealth low byte ?
      // ins += write_byte(0x1E)
      writer.writeByte(0x1E)
      // ins += write_pascal_string(char_class['profession'])
      //writer.writePascalString(res.getString("profession"))
      writer.writePascalString(charClass.profession)

      // ins += write_byte(0x00)
      writer.writeByte(0x00) // unk
      // pak.WritePascalString(player.CharacterClass.GetTitle(player, player.Level)); // player level
      // ins += write_pascal_string('none')
      writer.writePascalString("none")
      // // 	//todo make function to calcule realm rank
      // // 	//client.Player.RealmPoints
      // // 	//todo i think it s realmpoint percent not realrank
      // // 	pak.WriteByte((byte) player.RealmLevel); //urealm rank
      // ins += write_byte(0x00)
      writer.writeByte(0x00)
      // ins += write_pascal_string('Defender')
      writer.writePascalString("Defender")
      // // 	pak.WriteByte((byte) player.RealmSpecialtyPoints); // realm skill points
      // ins += write_byte(0x00)
      writer.writeByte(0x00)
      // ins += write_pascal_string(char_class['base'])
      //writer.writePascalString(res.getString("base"))
      writer.writePascalString(charClass.base)

      writer.writeByte(0x00)
      writer.writePascalString("") // guild name
      writer.writeByte(0x00)
      writer.writePascalString("") // last name
      writer.writeByte(0x01) // ml level
      races.getRace(character.race)
    }).map(result => {
      val race = result.head
      // ins += write_pascal_string(char_race['name'])
      //writer.writePascalString(race.getString("name"))
      writer.writePascalString(race.name)

      writer.writeByte(0x00)
      // // 	if (player.GuildRank != null)
      // // 		pak.WritePascalString(player.GuildRank.Title); // Guild title
      // // 	else
      // // 		pak.WritePascalString("");
      // ins += write_pascal_string('')
      writer.writePascalString("")
      writer.writeByte(0x00)
      // // 	AbstractCraftingSkill skill = CraftingMgr.getSkillbyEnum(player.CraftingPrimarySkill);
      // // 	if (skill != null)
      // // 		pak.WritePascalString(skill.Name); //crafter guilde: alchemist
      // // 	else
      // // 		pak.WritePascalString("None"); //no craft skill at start
      // ins += write_pascal_string('Basic Crafting')
      writer.writePascalString("Basic Crafting")
      writer.writeByte(0x00)
      // // 	pak.WritePascalString(player.CraftTitle.GetValue(player, player)); //crafter title: legendary alchemist
      // ins += write_pascal_string('Basic crafter\'s Helper')
      writer.writePascalString("Basic crafter\'s Helper")
      writer.writeByte(0x00)
      writer.writePascalString("") // ML title
      writer.writeByte(0x00)
      // // 	if (player.CurrentTitle != PlayerTitleMgr.ClearTitle)
      // // 		pak.WritePascalString(player.CurrentTitle.GetValue(player, player)); // new in 1.74 - Custom title
      // // 	else
      // // 		pak.WritePascalString("None");
      // write_pascal_string('None')
      writer.writePascalString("None")
      // // 	// new in 1.79
      // // 	if(player.Champion)
      // // 		pak.WriteByte((byte)(player.ChampionLevel+1)); // Champion Level (+1)
      // // 	else
      // // 		pak.WriteByte(0x0);
      // ins += write_byte(0x00)
      writer.writeByte(0x00)
      writer.writePascalString("") // champion title
    }).map(_ => {
      writer.getFinalPacket()
    })
  }
}
