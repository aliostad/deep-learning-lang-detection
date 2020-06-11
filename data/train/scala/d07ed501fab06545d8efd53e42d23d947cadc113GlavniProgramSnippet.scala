package sppp.snippet

import sppp.menu.SnippetSiteMap
import xml.{Text, NodeSeq}
import net.liftweb.http.{SHtml, RequestVar}
import spj.shared.domain.{Program, GlavniProgram, SpjDomainModel}
import net.liftweb.util.Helpers._
import java.lang.Long

object GlavniProgramSnippet extends SnippetSiteMap
{
  val editEntry = ("EditGlavniProgram", "sifrarnici/glavniprogram/edit")
  val createEntry = ("CreateGlavniProgram", "sifrarnici/glavniprogram/create")
  val manageEntry = ("Glavni Program", "sifrarnici/glavniprogram/manage")
}

class GlavniProgramSnippet extends SpppSnippet
{
  val requestVar = new RequestVar[SpjDomainModel](GlavniProgram.builder().id(0L).naziv("empty").build())
  {}
  val manageEntryLoc = GlavniProgramSnippet.manageEntry._2
  val editEntryLoc = GlavniProgramSnippet.editEntry._2

  def manage(xhtml: NodeSeq): NodeSeq =
  {
    readAllRecords(classOf[GlavniProgram]) flatMap
      {
        glprog => bind("glprog", chooseTemplate("glavniProgram", "entry", xhtml),
            "id" -> Text(glprog.getIdString),
            "naziv" -> Text(glprog.getNaziv),
            "actions" -> createManageActions[GlavniProgram](glprog, classOf[Program]))
      }

  }

  def edit(xhtml: NodeSeq): NodeSeq =
  {
    val glprog: GlavniProgram = selectedRecord
    val glprogBuilder = GlavniProgram.builder(glprog)

    bind("glprog", xhtml,
      "id" -> Text(glprog.getIdString),
      "naziv" -> SHtml.text(glprog.getNaziv(), glprogBuilder.naziv(_)),
      "save" -> SHtml.submit("save", () => {requestVar(glprog); updateRecord(glprogBuilder)}))
  }

  def create(xhtml: NodeSeq): NodeSeq =
  {
    var glprogBuilder = GlavniProgram.builder()

    bind("glprog", xhtml,
      "id" -> SHtml.text("", s => glprogBuilder.id(s), "class" -> "numberinputA2"),
      "naziv" -> SHtml.text("", glprogBuilder.naziv(_)),
      "create" -> SHtml.submit("create", () => createRecord(glprogBuilder)))
  }
}

