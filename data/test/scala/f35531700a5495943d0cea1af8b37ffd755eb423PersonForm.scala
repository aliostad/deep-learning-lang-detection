package example.snippet

import example.model.Person
import net.liftweb.http.{SHtml, RequestVar, LiftScreen, S}
import net.liftweb.util._
import Helpers._
import net.liftweb.common._
import xml.{NodeSeq, Text}

object PersonForm extends LiftScreen {

  object thisPerson extends ScreenVar[Person](Person.create)

  addFields( ()=> thisPerson.fullName )
  addFields( ()=> thisPerson.email)

  def finish = {
    S.notice("Person Saved")
    thisPerson.save
  }
}

object PersonList {
  def render = {
    val people = Person.findAll
    "li *" #> people.map(person => SHtml.link("/manage_people", ()=> setPerson(person), Text(person.fullName)):NodeSeq)
  }

  def setPerson(person :Person) {
    S.notice("Please Edit")
    PersonForm.thisPerson(person)
  }
}