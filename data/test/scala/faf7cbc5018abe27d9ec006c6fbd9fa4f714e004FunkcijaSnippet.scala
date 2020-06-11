package sppp.snippet

import net.liftweb.http.{SHtml, RequestVar}
import spj.shared.domain.{Funkcija, SpjDomainModel}
import xml.{Text, NodeSeq}
import net.liftweb.util.Helpers._
import sppp.menu.SnippetSiteMap

object FunkcijaSnippet extends SnippetSiteMap
{
    val editEntry = ("EditFunkcija", "sifrarnici/funkcija/edit")
    val createEntry = ("CreateFunkcija", "sifrarnici/funkcija/create")
    val manageEntry = ("Funkcija", "sifrarnici/funkcija/manage")
}

class FunkcijaSnippet extends SpppSnippet
{
    val requestVar = new RequestVar[SpjDomainModel](Funkcija.builder().defaultValue())
    {}
    val manageEntryLoc = FunkcijaSnippet.manageEntry._2
    val editEntryLoc = FunkcijaSnippet.editEntry._2

    def manage(xhtml: NodeSeq): NodeSeq =
    {
        readAllRecords(classOf[Funkcija]) flatMap
            {
                fja =>
                    bind("fja", chooseTemplate("funkcija", "entry", xhtml),
                        "id" -> Text(fja.getIdString),
                        "naziv" -> Text(fja.getNaziv),
                        "actions" -> createManageActions[Funkcija](fja))
            }
    }

    def edit(xhtml: NodeSeq): NodeSeq =
    {
        val fja: Funkcija = selectedRecord
        val fjaBuilder = Funkcija.builder(fja)

        bind("fja", xhtml,
            "id" -> Text(fja.getIdString),
            "naziv" -> SHtml.text(fja.getNaziv, fjaBuilder.naziv(_)),
            "save" -> SHtml.submit("save", () => {requestVar(fja); updateRecord[Funkcija](fjaBuilder)}))
    }

    def create(xhtml: NodeSeq): NodeSeq =
    {
        var razBuilder = Funkcija.builder()

        bind("fja", xhtml,
            "id" -> SHtml.text("", s => razBuilder.id(s), "class" -> "numberinput4"),
            "naziv" -> SHtml.text("", razBuilder.naziv(_)),
            "create" -> SHtml.submit("create", () =>{createRecord[Funkcija](razBuilder)}))
    }
}
