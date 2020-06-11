package eu.sbradl.liftedcontent.blog.snippet

import eu.sbradl.liftedcontent.blog.model.Post
import eu.sbradl.liftedcontent.blog.model.PostContent
import net.liftweb.mapper._
import net.liftweb.util.Helpers._
import net.liftweb.http._
import eu.sbradl.liftedcontent.core.model.User
import eu.sbradl.liftedcontent.core.lib.ACL
import scala.xml.Text
import java.text.DateFormat
import eu.sbradl.liftedcontent.blog.model.Comment
import java.util.Date
import net.liftmodules.textile.TextileParser

class BlogPosts {
  
  var dateFormat: DateFormat = null

  def render = {
    val posts = PostContent.findAll(OrderBy(PostContent.createdAt, Descending))

    val isBlogModerator = ACL.isAllowed("blog/edit")

    val publishedPosts = posts.filter((p: PostContent) => {
      isBlogModerator || (p.published.is && p.language.is == S.locale.getLanguage)
    })

    dateFormat = DateFormat.getDateTimeInstance(DateFormat.FULL, DateFormat.SHORT, S.locale)

    def manageStyle = isBlogModerator match {
      case true => "display: inline"
      case false => "display: none"
    }

    "data-name=blogpost *" #> publishedPosts.map {
      post => renderPost(post, manageStyle)
    }
  }

  def editLink(id: Long) = <a href={ "/blog/edit/" + id.toString }>{ S ? "EDIT" }</a>
  def deleteLink(id: Long) = <a href={ "/blog/delete/" + id.toString }>{ S ? "DELETE" }</a>

  def renderPost(post: PostContent, manageStyle: String) = {
    val metaPost = post.post.obj.open_!
    val author = metaPost.author.obj.open_!
    
    val status = post.published.is match {
      case true => S ? "BLOG_ENTRY_STATUS_PUBLISHED"
      case false => S ? "BLOG_ENTRY_STATUS_UNPUBLISHED"
    }

    "data-name=title *" #> post.title.is &
      "data-name=author *" #> author.name &
      "data-name=translator *" #> post.translator.obj.map(_.name).openOr("unknown") &
      "data-name=createdAt *" #> dateFormat.format(post.createdAt.is) &
      "data-name=updatedAt *" #> dateFormat.format(post.updatedAt.is) &
      "data-name=text" #> TextileParser.toHtml(post.text.is) &
      "data-name=manage [style]" #> manageStyle &
      "data-name=manage *" #> {
        "data-name=status" #> status &
        "data-name=edit" #> editLink(metaPost.id.is) &
          "data-name=delete" #> deleteLink(metaPost.id.is)
      } & renderComments(metaPost)
      
  }
  
  def renderComments(metaPost: Post) = {
    "data-name=comments *" #> {
        "data-name=summary" #> (S ? ("COMMENT_SUMMARY", metaPost.comments.size)) &
        "data-name=commentUrl [href]" #> ("/blog/comment/" + metaPost.id.is) &
        "data-name=commentLinkText" #> (S ? "WRITE_COMMENT") &
          "data-name=comment *" #> metaPost.comments.map {
            comment =>
              {
                "data-name=author" #> comment.author.obj.map(_.name).openOr("unknown") &
                  "data-name=createdAt" #> dateFormat.format(comment.createdAt.is) &
                  "data-name=text *" #> comment.comment.is
              }
          }
      }
  }

}