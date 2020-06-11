package com.gamesofforums.domain

import com.shingimmel.dsl._

/* God */
object God extends Role {
  override implicit val authRules: AuthorizationRules[User] = rulesFor[User] {
    derivedFrom(ForumAdmin.authRules)

    can(ManageForumPolicy)
    can(ManageUserTypes)
  }
}

/* Forum Admin */
object ForumAdmin extends Role {
  override implicit val authRules: AuthorizationRules[User] = rulesFor[User] {
    derivedFrom(NormalUser.authRules)

    can(Ban).a[User]
    can(EditMessages)
    can(DeleteMessages)
    can(ManageSubForumModerators)
    can(ManageForumAdmins)
    can(ManageSubForums)
  }
}

/* Moderator */
case class Moderator(at: Seq[SubForum]) extends Role with RulesPredicates {
  def this(in: SubForum) = this(Seq(in))

  // add itself to subforums' moderators
  at.foreach(_._moderators += this)

  override implicit val authRules: AuthorizationRules[User] = rulesFor[User] {
    derivedFrom(NormalUser.authRules)

    can(Ban).a[User]

    can(EditMessages) onlyWhen itsAValidModeratorMessage
    can(DeleteMessages) onlyWhen itsAValidModeratorMessage
  }
}

object Moderator {
  def apply(at: SubForum) = new Moderator(at)
}


/* Normal User */
object NormalUser extends Role with RulesPredicates {
  import com.shingimmel.dsl._

  override implicit val authRules: AuthorizationRules[User] = rulesFor[User] {
    can(Publish)
    can(ReportUsers)
    can(EditMessages) onlyWhen heOwnsTheMessage
    can(DeleteMessages) onlyWhen heOwnsTheMessage
  }
}
