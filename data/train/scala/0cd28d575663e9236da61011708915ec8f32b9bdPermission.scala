package com.gamesofforums.domain

import com.shingimmel.dsl.Permission

/* Normal User Permissions */
object Publish extends Permission
object ReportUsers extends Permission

object EditMessages extends Permission
object DeleteMessages extends Permission

/* Moderator Permissions */
object Ban extends Permission

/* Administrator Permissions */
object ManageSubForumModerators extends Permission
object ManageForumAdmins extends Permission
object ManageSubForums extends Permission

/* God Permissions */
object ManageForumPolicy extends Permission
object ManageUserTypes extends Permission
