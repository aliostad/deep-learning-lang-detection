package models

import java.util.{Date}
import play.api.db._
import play.api.Play.current

import anorm._
import anorm.SqlParser._

import scala.language.postfixOps
import play.api.libs.json._

case class Process(id: Pk[Long] = NotAssigned, computer_id : Long, process_name: String, process_path: String)

object Process {
	val simple = {
		  get[Pk[Long]]("process.id") ~
		  get[Long]("process.computer_id") ~
		  get[String]("process.process_name") ~
		  get[String]("process.process_path") map {
		  	case id~computer_id~process_name~process_path
		  	=> Process(id,computer_id,process_name, process_path)
		  }
	}
	
	def findById(id: Long): Seq[Process] = {
		DB.withConnection { implicit connection =>
			SQL("select * from process where computer_id = {id}").on('id -> id).as(Process.simple.*)
		}
	}
	
	def findAll: Seq[Process] = {
		DB.withConnection { implicit connection =>
			SQL("select * from process").as(Process.simple.*)
		}
	}
	
	
	def processID(process: String) : String = {
		var x = ""
		process match {
			case "finger.exe" => x = "Fingerprinting Malware"
			case "chargen.exe" => x = "Chargen DoS Malware"
			case "Skype.exe" => x = "Unknown VoIP"
			case "skype.exe" => x = "Unknown VoIP"
			case "trojan.exe" => x = "Virus"
			case "VIRUS.exe" => x = "Virus"
			case "BACKDOOR.exe" => x = "Exploit"
			case "outlook.exe" => x = "IMAP Process"	
			case _ => x = "OK"
		}
		return x
	} 
		
}
    