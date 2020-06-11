package com.automatatutor.renderer

import scala.xml.NodeSeq
import scala.xml.Text
import com.automatatutor.model.Course
import com.automatatutor.model.PosedProblemSet
import com.automatatutor.snippet.CourseReqVar
import net.liftweb.http.SHtml
import net.liftweb.http.SHtml.ElemAttr.pairToBasic
import net.liftweb.http.js.JE.JsRaw
import net.liftweb.http.js.JsCmd
import net.liftweb.http.js.JsCmds
import net.liftweb.http.js.JsCmds.jsExpToJsCmd
import com.automatatutor.model.User

class CourseRenderer(course : Course) {
  def renderShowLink : NodeSeq = {
    return SHtml.link("/courses/show", () => CourseReqVar(course), Text("Show"))
  }
  
  def renderContactLink : NodeSeq = {
    SHtml.link("mailto:" + course.getContact, () => (), Text(course.getContact))
  }
  
  def renderManageLink : NodeSeq = {
      if(course.getInstructors.contains(User.currentUser openOr null)) {
        SHtml.link("/courses/manage", () => CourseReqVar(course), Text("Manage course"))
      } else {
        NodeSeq.Empty
      }
  }

  def renderDeleteLink : NodeSeq = {
    val target = "/courses/index"
    def function() = course.delete_!
    val label = if(course.canBeDeleted) { Text("Delete") } else { Text("Cannot delete course") }
    val onclick : JsCmd = if(course.canBeDeleted) { 
        JsRaw("return confirm('Are you sure you want to delete this course?')") 
      } else  { 
        JsCmds.Alert("Cannot delete this course:\n" + course.getDeletePreventers.mkString("\n")) & JsRaw("return false")
      }

    return SHtml.link(target, function, label, "onclick" -> onclick.toJsCmd)
  }
  
  def renderRemoveProblemSetLink(posedProblemSet : PosedProblemSet) : NodeSeq = {
    val target = "/courses/manage"
    def function() = { CourseReqVar(course); course.removePosedProblemSet(posedProblemSet) }
    val label = if(posedProblemSet.canBeRemoved) { Text("Remove Problem Set") } else { Text("Cannot remove Problem Set") }
    val onclick : JsCmd = if(posedProblemSet.canBeRemoved) {
      JsRaw("return confirm('Are you sure you want to remove this problem set?')")
    } else {
      JsCmds.Alert("Cannot remove this problem set:\n" + posedProblemSet.getRemovePreventers.mkString("\n")) & JsRaw("return false")
    }
    
    return SHtml.link(target, function, label, "onclick" -> onclick.toJsCmd)
  }
}