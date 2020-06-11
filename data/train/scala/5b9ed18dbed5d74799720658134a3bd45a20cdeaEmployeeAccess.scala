package com.xiiik1a
package snippet

import scala.xml.{NodeSeq,Text}
import org.slf4j.LoggerFactory
import net.liftweb.common.{Box,Empty,Full,Logger}
import net.liftweb.http.{S,SHtml, DispatchSnippet}
import net.liftweb.util.Helpers._
import model.{Department,Employee}
import util.{DutyUtil}


class EmployeeAccess extends DispatchSnippet with Logger {
  
  override val _logger = LoggerFactory.getLogger("EmployeeEdit")

  def dispatch : DispatchIt = {
    case "manageEmployees" => manageM _ 
     case "create" => create _
  }
  
  def manageM (xhtml : NodeSeq) : NodeSeq = {
        
      def deleteEmployee (employee : Employee) {
      		employee.delete_!
      }
   
      def unbox(boxValue : Box[Int]) : Int = {
         boxValue match {
            case Full(value) =>
                 value
            case _ => 1      
         }
      }
      Employee.findAll.flatMap({ employee => 
                 bind("emp",   chooseTemplate("employee", "entry", xhtml),
                 "specialty" -> Text(employee.specialty.toString),
                 "firstName" -> Text(employee.firstName.is),
                 "lastName" -> Text(employee.lastName.is),
                 "primaryDuty" -> Text(DutyUtil.getDutyList(employee.specialty.toInt).apply(unbox(employee.duty.toInt)).toString),
                 "actions" -> { SHtml.link("/editOneEmployee", () => ModEmployeeScreen.employee.set(employee), Text("Edit")) })
      })
           
  }
  
  def create (xhtml : NodeSeq) : NodeSeq = { 
         bind("employee", xhtml,
              "create" -> SHtml.link("/editOneEmployee", () => 0, Text("Add a New Employee."))
              )              
  }

}
