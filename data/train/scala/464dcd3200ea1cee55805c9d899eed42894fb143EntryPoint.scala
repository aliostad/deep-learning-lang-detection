package hr.element.hmtt

import scala.xml.XML
import hr.element.hmtt.data.web.Player
import scala.xml.Elem
import java.io.FileOutputStream
import hr.ngs.templater.Configuration
import hr.element.hmtt.data.web.Skill
import hr.element.hmtt.oauth.Tokenizzzer
import hr.element.hmtt.oauth.Resources
import hr.element.hmtt.db._
import scalax.io.InputResource
import hr.element.hmtt.data.web.Training
import java.text.SimpleDateFormat
import hr.element.hmtt.data.web.DataLoader
import hr.element.hmtt.skillcalc.SkillCalculator

object EntryPoint extends App {

  val FS = System.getProperty("file.separator")
  val resource     = "src" + FS + "main" + FS + "resources" + FS + "players.xml"
  val newResource  = "src" + FS + "main" + FS + "resources" + FS + "playersNew.xml"
  val TemplatePath = "src" + FS + "main" + FS + "resources" + FS + "players_template.xlsx";
  val OutputPath   = "output" + FS + "players.xlsx";


//  Connector.prepareDB
//
//  DataLoader.batchLoad

  println(SkillCalculator.calcTrainingLenght(18,10,"Playmaking"))



//  val resource2 = Tokenizzzer.getResource(Resources.training)
//  val feedXML = XML.loadString(resource2)
//  val training = for{e <- (feedXML \\ "Team") } yield Training(e)
//
//  val resultSet = SDM.selectPlayerHistory(319335797)
//  val formatter = new SimpleDateFormat("dd-MM-yyyy")
//  while(resultSet.next()) {
//    val name = resultSet.getString("FIRSTNAME") + " " + resultSet.getString("LASTNAME")
//    val wage = resultSet.getInt("SALARY")
//    val date = new java.util.Date(resultSet.getTimestamp("TIMESTAMP").getTime())
//    println(name)
//    println(wage)
//    println(date)
//  }
//
//  val resultSet2 = SDM.selectLastSkillUpdate
//  while(resultSet2.next()) {
//    val id = resultSet.getInt("PLAYERID")
//    val timestamp = resultSet.getTimestamp("GOALKEEPING")
//    println(id + "  " + timestamp)
//  }


  def makeXMLfromString(feed: Elem) = for {
    e <- (feed \\ "Player")
  } yield Player(e)

  def makeReport(CDs: Seq[Player]) {
    val iS  = this.getClass().getResourceAsStream(TemplatePath)
    val fOS = new FileOutputStream(OutputPath)
    val tpl = Configuration.factory().open(iS, "xlsx", fOS)

    tpl.process(CDs.toArray)
    tpl.flush()
    fOS.close()
    iS.close()
  }

  def printReport(players: Seq[(Player, Player)]) {
    for{ (now, old)  <- players } {
      println(now.firstName + " " + old.lastName)
      println("TSI: " + now.tsi + " (" + (now.tsi - old.tsi) + ")")
      if(now.speciality.id != 0) println("Speciality: " + now.speciality)
      println("Wage: " + now.salary)

      printSkillChange(now.playerForm, old.playerForm)
      printSkillChange(now.staminaSkill, old.staminaSkill)
      printSkillChange(now.scorerSkill, old.scorerSkill)
      printSkillChange(now.passingSkill, old.passingSkill)
      printSkillChange(now.wingerSkill, old.wingerSkill)
      printSkillChange(now.playmakerSkill, old.playmakerSkill)
      printSkillChange(now.defenderSkill, old.defenderSkill)
      printSkillChange(now.setPiecesSkill, old.setPiecesSkill)
      printSkillChange(now.keeperSklill, old.keeperSklill)
      println()
     }
  }

  def printSkillChange(now: Skill, old: Skill) =
    println("%11s: %s -> %2d" format(now.getClass.getSimpleName, now, now-old))

  def printPlayers = {

//    val iS = this.getClass().getResourceAsStream(resource)
//    val iS2 = this.getClass().getResourceAsStream(newResource)

    try  {
      val src1 = scala.io.Source.fromFile(resource)("UTF-8")
      val src2 = scala.io.Source.fromFile(newResource)("UTF-8")
      val s1 = src1.mkString
      val s2 = src2.mkString
      src1.close()
      src2.close()

      val webResource = Tokenizzzer.getResource(Resources.players)

      val feedXML = XML.loadString(s2)
      val feedXML2 = XML.loadString(webResource)


      val playersOld = makeXMLfromString(feedXML)
      val playersNew = makeXMLfromString(feedXML2)

      val zipped = playersNew zip playersOld

      printReport(zipped)
    } catch {
      case e: Exception => e.printStackTrace()
    }//makeReport(playersNew)


  }
}