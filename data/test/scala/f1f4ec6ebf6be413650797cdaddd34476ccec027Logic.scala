import java.io.File
import scala.io.Source._
import java.net.URL
import sys.process._
import net.lingala.zip4j.exception.ZipException;
import net.lingala.zip4j.core.ZipFile;
import scala.actors._
import Actor._

object Logic extends App {
  
  def getPath = {
    val regex = "(.*World of Warcraft).*".r
    val e = sys.env.getOrElse("WorldOfWarcraft", null)
    e match {
      case p => p match {
        case regex(g) => if (new File(g).exists) g else sys.exit
        case _ => sys.exit
      }
    }
  }
  
  def getAddons(p: String): Set[String] = {
    val reg = """## X-Curse-Project-ID: (.*)\W*""".r.unanchored
    lazy val reg2 = """## Title: (.*)\W*""".r.unanchored
    
    def getId(f: File): String = {
     try{
       fromFile(f.toString + "/" + f.getName + ".toc").mkString match {
        case reg(x) => x
        case reg2(x) => x.replaceAll("\\s", "-")
        case _ => null
      }
     }catch {
       case e: Exception => null
     }
    }
    
    def mapFile(f: File) = {
      val id = getId(f)
      if (id != null) Set(id, f.getName) else Set(f.getName)
    }
    
    new File(p + "/Interface/AddOns").listFiles.map(mapFile).flatten.toSet
  }
  
  def getURLdownloadUnzip(xs: Set[String], path: String) = {
   val base = "http://wow.curseforge.com/addons/%s/files/"
   lazy val base2 = "http://wow.curseforge.com/search/?search=%s"
   val regex1 = "<td class=\"col-file\"><a href=\".*?/files/(.*?)\">".r.unanchored
   val regex2 = "user-action user-action-download.*?href=\"(.*?)\">Download".r.unanchored
   val regex3 = ".*/([^/]*zip)".r.unanchored
   lazy val regex4 = "(?s)<tr class=\"odd row-joined-to-next\">.*?addons/(.+?)/\"".r.unanchored
   
   def getName(url: String) = {
     url match {
       case regex3(g) => g
     }
   }
   
   def download(url: String) {
     val y: File = new File(path + "/Interface/AddonUpdater/" + getName(url))
     (new URL(url) #> y).!
     new ZipFile(y).extractAll(path + "/Interface/AddOns")
   }
   
    def getURL(a: String, alrdy: Boolean = false) {
     val url = base.format(a)
      try {fromURL(url).mkString match {
        case regex1(e) => {fromURL(url + e).mkString match {
          case regex2(g) if (isValid(g)) => download(g)
          case _ =>}}
        case _ =>
      }} catch {
        case e: Exception if (!alrdy) => {fromURL(base2.format(a.replaceAll("\\s", "+"))).mkString match {
          case regex4(g) if (isSimilar(a, g)) => getURL(g, true)
          case _ =>
        }}
       }
    }
    
    def isValid(url: String) = {
     val u = url.toLowerCase
     (u.contains("curse") || u.contains("wowace") || u.contains("wowinterface")) && (u.contains(".zip") || u.contains(".rar"))
    }
    
    def isSimilar(o: String, f: String) = {
      val old = o.toLowerCase.replaceAll("\\W", "")
      val found = f.toLowerCase.replaceAll("\\W", "")
      found.contains(old) || old.contains(found) || (if (found.length >= 3 && old.length >= 3) found.contains(old.substring(0,3)) || 
          found.contains(old.substring(old.length - 3)) else false) || (old.startsWith(found.substring(0,1)) && old.endsWith(found.substring(found.length - 1))) ||
          (found.startsWith(old.substring(0,1)) && found.endsWith(old.substring(old.length - 1))) || old == found
    }
    
    def prepare() {
      val f = new File(path + "/Interface/AddonUpdater")
      if (f.exists) {
        f.listFiles foreach (_.delete)
      } else {
        f.mkdir
      }
    }
    
    prepare
    xs foreach (f => actor {self ! getURL(f)})
  }
  
  val path = getPath
  getURLdownloadUnzip(getAddons(path), path)
}