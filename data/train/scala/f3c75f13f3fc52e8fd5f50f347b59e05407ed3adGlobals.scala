package pip.core

import swing.Label
import java.io.File
/**
 * Created by IntelliJ IDEA.
 * User: svetylk0@seznam.cz
 * Date: 27.2.11
 * Time: 9:38
 * To change this template use File | Settings | File Templates.
 */

object Globals {
  import Tools.loadIcon

  val authFile = "myauth"

  val configFile = "config.ini"
  val defaultTweetCount = 20
  val encoding = "UTF-8"

  val backgroundColor = (new Label).background
  val localizationDir = "loc"
  val resourcesDir = "res"
  val imagesCacheDir = "cache"+File.separator+"img"
    
  //dalsi promenne
  var myNick = ""
    
  //promenne ze souboru config.ini
  var tweetsPerPage = 5
  var tweetFontSize = 12f
  var browserCommand = ""

  //ikonky tlacitek
  val quitIcon = loadIcon("quit_icon.png")
  val searchIcon = loadIcon("search_icon.png")
  val preferencesIcon = loadIcon("preferences_icon.png")
  val addIcon = loadIcon("add_icon.png")
  val removeIcon = loadIcon("remove_icon.png")
  val messagesIcon = loadIcon("messages_icon.png")
  val firstIcon = loadIcon("first_icon.png")
  val leftIcon = loadIcon("left_icon.png")
  val rightIcon = loadIcon("right_icon.png")

  //ikonky
  val replyIcon = loadIcon("reply.png")
  val replyHighlightIcon = loadIcon("reply_highlight.png")
  val retweetIcon = loadIcon("retweet.png")
  val retweetHighlightIcon = loadIcon("retweet_highlight.png")
  val retweetHighlightIcon2 = loadIcon("retweet_highlight2.png")
  val favoriteIcon = loadIcon("favorite.png")
  val favoriteHighlightIcon = loadIcon("favorite_highlight.png")
  val favoriteHighlightIcon2 = loadIcon("favorite_highlight2.png")
  val urlIcon = loadIcon("url.png")
  val urlHighlightIcon = loadIcon("url_highlight.png")
  val imageIcon = loadIcon("image.png")
  val imageHighlightIcon = loadIcon("image_highlight.png")


  //tlacitka mysi
  val leftMouseButton = 0
  val middleMouseButton = 512
  val rightMouseButton = 256

  def setConfigVariables() {
    tweetsPerPage = Config("tweetsPerPage").toInt
    tweetFontSize = Config("tweetFontSize").toFloat
    browserCommand = Config("browserCommand")
  }
}