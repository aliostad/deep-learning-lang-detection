package sppp.snippet

import spj.shared.domain.Mjesto
import net.liftweb.http.SHtml
import xml.Text
import net.liftweb.util.Helpers._
import xml.NodeSeq
import spj.shared.domain.SpjDomainModel
import net.liftweb.http.RequestVar
import sppp.menu.SnippetSiteMap

object MjestoSnippet extends SnippetSiteMap
{
    val editEntry = ("EditMjesto", "sifrarnici/mjesto/edit")
    val createEntry = ("CreateMjesto", "sifrarnici/mjesto/create")
    val manageEntry = ("Mjesto", "sifrarnici/mjesto/manage")
}

class MjestoSnippet extends SpppSnippet
{
    val requestVar = new RequestVar[SpjDomainModel](Mjesto.builder().defaultValue())
    {}
    val manageEntryLoc = MjestoSnippet.manageEntry._2
    val editEntryLoc = MjestoSnippet.editEntry._2

    def manage(xhtml: NodeSeq) =
    {
        readAllRecords(classOf[Mjesto]) flatMap
            {
                mj =>
                    bind("mj", chooseTemplate("mjesto", "entry", xhtml),
                        "id" -> Text(mj.getIdString),
                        "naziv" -> Text(mj.getNaziv),
                        "pozivniBroj" -> Text(mj.getPozivniBroj),
                        "postanskiBroj" -> Text(mj.getPostanskiBroj),
                        "actions" -> createManageActions[Mjesto](mj))
            }
    }

    def edit(xhtml: NodeSeq) =
    {

        val mj: Mjesto = selectedRecord
        val mjBuilder = Mjesto.builder(mj)

        bind("mj", xhtml,
            "id" -> Text(mj.getIdString),
            "naziv" -> SHtml.text(mj.getNaziv, s => mjBuilder.naziv(s)),
            "pozivniBroj" -> SHtml.text(mj.getPozivniBroj, s => mjBuilder.pozivniBroj(s), "class" -> "numberinput"),
            "postanskiBroj" -> SHtml.text(mj.getPostanskiBroj, s => mjBuilder.postanskiBroj(s), "class" -> "numberinput5"),
            "save" -> SHtml.submit("save", () =>
            {
                requestVar(mj);
                updateRecord(mjBuilder)
            }))
    }

    def create(xhtml: NodeSeq) =
    {
        val mjBuilder = Mjesto.builder()

        bind("mj", xhtml,
            "id" -> SHtml.text("", s => mjBuilder.id(s), "class" -> "numberinput"),
            "naziv" -> SHtml.text("", s => mjBuilder.naziv(s)),
            "pozivniBroj" -> SHtml.text("", s => mjBuilder.pozivniBroj(s), "class" -> "numberinput"),
            "postanskiBroj" -> SHtml.text("", s => mjBuilder.postanskiBroj(s), "class" -> "numberinput5"),
            "create" -> SHtml.submit("create", () => createRecord(mjBuilder)))
    }


}

