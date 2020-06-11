package com.gamesofforums.matchers

import com.gamesofforums.domain._
import org.specs2.mutable.Specification
import org.specs2.specification.Scope

/**
 * Created by lidanh on 4/24/15.
 */
trait RolesSharedTests { this: Specification with ForumMatchers =>
  trait Ctx extends Scope {
    implicit val user = User(
      generateId,
      firstName = "kuki",
      lastName = "buki",
      mail = "some@email.com",
      password = "somePass")

    val otherUser = User(
      generateId,
      firstName = "bibi",
      lastName = "buzi",
      mail = "bib@i.com",
      password = "1234"
    )
  }

  def behaveLike(role: Role) = {
    role match {
      case NormalUser => normalUserBehaviour(role)
      case role: Moderator => moderatorBehaviour(role)
      case ForumAdmin => forumAdminBehaviour(role)
      case God => forumGodBehaviour(role)
    }
  }

  trait NormalUserCtx extends Ctx {
    val someForum = SubForum(name = "test")
    val userPost = Post(subject = "some subject", content = "hakshev!", postedBy = user, postedIn = someForum)
    user.messages += userPost

    val otherUserPost = Post(subject = "other subject", content = "hofshi!", postedBy = otherUser, postedIn = someForum)
    otherUser.messages += otherUserPost
  }

  private def normalUserBehaviour(role: Role) = {
    "can publish anything" in new NormalUserCtx {
      val somePost = Post(subject = "some subject", content = "hakshev!", postedBy = user, postedIn = someForum)

      role must havePermissionTo(Publish)(somePost)
    }

    "can edit only messages he owns" in new NormalUserCtx {
      role must havePermissionTo(EditMessages)(userPost) and
        not(havePermissionTo(EditMessages)(otherUserPost))
    }

    "can delete only messages he owns" in new NormalUserCtx {
      role must havePermissionTo(DeleteMessages)(userPost) and
        not(havePermissionTo(DeleteMessages)(otherUserPost))
    }

    "can report other users" in new NormalUserCtx {
      role must havePermissionTo(ReportUsers)(otherUser)
    }
  }

  trait ModeratorCtx extends Ctx {
    val moderatedSubforum = SubForum(name = "test forum")
    user is Moderator(at = moderatedSubforum)
    val postInModeratedSubforum = Post(subject = "hello", content = "test message", postedBy = otherUser, postedIn = moderatedSubforum)
    val commentInModeratedSubforum = Comment(content = "some comment", parent = postInModeratedSubforum, postedBy = otherUser)

    val notModeratedSubforum = SubForum(name = "other forum")
    val otherPost = Post(subject = "hello", content = "test message", postedBy = otherUser, postedIn = notModeratedSubforum)
    val otherComment = Comment(content = "some comment", parent = otherPost, postedBy = otherUser)

  }

  private def moderatorBehaviour(role: Role) = {
    "behave like a normal user" in new ModeratorCtx {
      normalUserBehaviour(role)
    }

    "can ban users" in new ModeratorCtx {
      role must havePermissionTo(Ban)(otherUser)
    }

    "can edit any post in forums that he moderates" in new ModeratorCtx {
      role must havePermissionTo(EditMessages)(postInModeratedSubforum) and
        not(havePermissionTo(EditMessages)(otherPost))
    }

    "can edit any comment in forums that he moderates" in new ModeratorCtx {
      role must havePermissionTo(EditMessages)(commentInModeratedSubforum) and
        not(havePermissionTo(EditMessages)(otherComment))
    }

    "can delete any post in forums that he moderates" in new ModeratorCtx {
      role must havePermissionTo(DeleteMessages)(postInModeratedSubforum) and
        not(havePermissionTo(DeleteMessages)(otherPost))
    }

    "can delete any comment forums that he moderates" in new ModeratorCtx {
      role must havePermissionTo(DeleteMessages)(commentInModeratedSubforum) and
        not(havePermissionTo(DeleteMessages)(otherComment))
    }
  }

  trait ForumAdminCtx extends Ctx {
    val someSubforum = SubForum(name = "test forum")
    val somePostInSubforum = Post(subject = "hello", content = "test message", postedBy = otherUser, postedIn = someSubforum)
    val commentUnderPost = Comment(content = "some comment", parent = somePostInSubforum, postedBy = otherUser)

    val forum = Forum(ForumPolicy())
  }

  private def forumAdminBehaviour(role: Role) = {
    "can publish anything" in new NormalUserCtx {
      val somePost = Post(subject = "some subject", content = "hakshev!", postedBy = user, postedIn = someForum)

      role must havePermissionTo(Publish)(somePost)
    }

    "can ban users" in new ForumAdminCtx {
      role must havePermissionTo(Ban)(otherUser)
    }

    "can edit any post in any forum" in new ForumAdminCtx {
      role must havePermissionTo(EditMessages)(somePostInSubforum)
    }

    "can edit any comment in any forum" in new ForumAdminCtx {
      role must havePermissionTo(EditMessages)(commentUnderPost)
    }

    "can delete any post in any forum" in new ForumAdminCtx {
      role must havePermissionTo(DeleteMessages)(somePostInSubforum)
    }

    "can delete any comment in any forum" in new ForumAdminCtx {
      role must havePermissionTo(DeleteMessages)(commentUnderPost)
    }

    "can manage subforums moderators" in new ForumAdminCtx {
      role must havePermissionTo(ManageSubForumModerators)(forum)
    }

    "can manage forum admins" in new ForumAdminCtx {
      role must havePermissionTo(ManageForumAdmins)(forum)
    }

    "can manage subforums" in new ForumAdminCtx {
      role must havePermissionTo(ManageSubForums)(forum)
    }
  }

  private def forumGodBehaviour(role: Role) = {
    trait GodCtx extends Ctx {
      val forum = Forum(ForumPolicy())
    }

    "behave like a forum admin" in {
      forumAdminBehaviour(role)
    }

    "can manage forum policy" in new GodCtx {
      role must havePermissionTo(ManageForumPolicy)(forum)
    }

    "can manage user types" in new GodCtx {
      role must havePermissionTo(ManageUserTypes)(forum)
    }
  }
}
