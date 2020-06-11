package com.tsunderebug.speedrunbot

import sx.blah.discord.handle.impl.events.guild.channel.message.MessageReceivedEvent
import sx.blah.discord.handle.obj.Permissions

object PermissionChecks {

  def manageServer(e: MessageReceivedEvent): Boolean = {
    e.getGuild.getOwnerLongID == e.getAuthor.getLongID || e.getAuthor.getPermissionsForGuild(e.getGuild).contains(Permissions.MANAGE_SERVER) || Main.globals.contains(e.getAuthor.getLongID)
  }

  def isGlobal(e: MessageReceivedEvent): Boolean = {
    Main.globals.contains(e.getAuthor.getLongID)
  }

}
