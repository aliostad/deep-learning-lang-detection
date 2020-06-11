package sppp.snippet

import net.liftweb.http._
import xml.NodeSeq
import net.liftweb.util.Helpers._
import spj.shared.domain.{Glava, Razdjel, SpjDomainModel}
import xml.Text
import sppp.menu.SnippetSiteMap

object RazdjelSnippet extends SnippetSiteMap
{
    val editEntry = ("EditRazdjel", "sifrarnici/razdjel/edit")
    val createEntry = ("CreateRazdjel", "sifrarnici/razdjel/create")
    val manageEntry = ("Razdjel", "sifrarnici/razdjel/manage")
}

class RazdjelSnippet extends SpppSnippet
{
    val requestVar = new RequestVar[SpjDomainModel](Razdjel.builder().defaultValue())
    {}
    val manageEntryLoc = RazdjelSnippet.manageEntry._2
    val editEntryLoc = RazdjelSnippet.editEntry._2

    def manage(xhtml: NodeSeq): NodeSeq =
    {
        readAllRecords(classOf[Razdjel]) flatMap
            {
                raz =>
                    bind("raz", chooseTemplate("razdjel", "entry", xhtml),
                        "id" -> Text(raz.getIdString),
                        "nazivRazdjela" -> Text(raz.getNaziv),
                        "actions" -> createManageActions[Razdjel](raz, classOf[Glava]))
            }
    }

    def edit(xhtml: NodeSeq): NodeSeq =
    {
        val raz: Razdjel = selectedRecord
        val razBuilder = Razdjel.builder(raz)

        bind("raz", xhtml,
            "id" -> Text(raz.getIdString),
            "nazivRazdjela" -> SHtml.text(raz.getNaziv, razBuilder.naziv(_)),
            "save" -> SHtml.submit("save", () => {requestVar(raz); updateRecord[Razdjel](razBuilder)}))
    }

    def create(xhtml: NodeSeq): NodeSeq =
    {
        var razBuilder = Razdjel.builder()

        bind("raz", xhtml,
            "id" -> SHtml.text("", s => razBuilder.id(s), "class" -> "numberinput3"),
            "nazivRazdjela" -> SHtml.text("", razBuilder.naziv(_)),
            "create" -> SHtml.submit("create", () =>{createRecord[Razdjel](razBuilder)}))
    }
}