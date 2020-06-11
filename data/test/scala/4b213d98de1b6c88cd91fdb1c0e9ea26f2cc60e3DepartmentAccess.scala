package com.xiiik1a
package snippet


import scala.xml.{NodeSeq,Text}
import net.liftweb.common.{Logger, Box, Full}
import net.liftweb.http.{DispatchSnippet,  SHtml}

import net.liftweb.util.Helpers._
import model.{Department,Employee}
import util.{StateUtil, DutyUtil, DepartmentTypeUtil}


object DepartmentAccess extends DispatchSnippet with Logger {
  def dispatch : DispatchIt = {
    case "manageDepartments" => manage _
    case "create" => create _
  
  } 

  def manage (xhtml : NodeSeq) : NodeSeq = {
      def unbox(boxValue : Box[Int]) : Int = {
         boxValue match {
            case Full(value) =>
                 value
            case _ => 1      
         }
      } 
      
     def setEmployee(dpt : Department) 
     {
        Employee.createRecord
        Employee.specialty.setFromAny(unbox(dpt.specialty.toInt))
        ModEmployeeScreen.employee.set(Employee)
     }   
        
     Department.findAll.flatMap({dpt =>
         bind("dpt", chooseTemplate("department", "entry", xhtml),
             "city" -> Text(dpt.city.is),
             "state" -> Text(dpt.state.toString),
             "specialty" -> Text(dpt.specialty.toString),
             "actions" -> {SHtml.link("/editOneEmployee" , () => setEmployee(dpt), Text("Add Employees")) })
     })
  }	

  def create (xhtml : NodeSeq) : NodeSeq = { 
         bind("department", xhtml,
              "create" -> SHtml.link("/editDepartment", () => 0, Text("Add a Department"))
              )              
  }
    
  
}
