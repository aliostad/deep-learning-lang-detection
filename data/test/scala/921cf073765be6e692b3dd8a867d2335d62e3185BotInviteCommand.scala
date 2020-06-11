package score.discord.generalbot.command

import net.dv8tion.jda.core.Permission
import net.dv8tion.jda.core.entities.Message
import score.discord.generalbot.functionality.ownership.MessageOwnership
import score.discord.generalbot.util.BotMessages
import score.discord.generalbot.wrappers.jda.Conversions._

class BotInviteCommand(implicit messageOwnership: MessageOwnership) extends Command.Anyone {
  override def name = "botinvite"

  override def aliases = Nil

  override def description = "Get a link to invite this bot to your server"

  override def execute(message: Message, args: String) = {
    import Permission._
    message.getChannel.sendOwned(BotMessages.plain(message.getJDA.asBot.getInviteUrl(
      MANAGE_ROLES, MANAGE_CHANNEL, MESSAGE_MANAGE, VOICE_MOVE_OTHERS
    )), owner = message.getAuthor)
  }
}
