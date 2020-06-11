package sppp.snippet

import net.liftweb.http._
import xml.NodeSeq
import net.liftweb.util.Helpers._
import spj.shared.domain.{IzvorFinanciranja, SpjDomainModel}
import java.lang.Long
import xml.Text
import sppp.menu.SnippetSiteMap

object IzvorFinSnippet extends SnippetSiteMap
{
    val editEntry = ("EditIzvorFin", "sifrarnici/izvorfinanciranja/edit")
    val createEntry = ("CreateIzvorFinanciranja", "sifrarnici/izvorfinanciranja/create")
    val manageEntry = ("Izvor Financiranja", "sifrarnici/izvorfinanciranja/manage")
}

class IzvorFinSnippet extends SpppSnippet
{
    val requestVar = new RequestVar[SpjDomainModel](IzvorFinanciranja.builder().defaultValue())
    {}
    val manageEntryLoc = IzvorFinSnippet.manageEntry._2
    val editEntryLoc = IzvorFinSnippet.editEntry._2

    def manage(xhtml: NodeSeq): NodeSeq =
    {
        readAllRecords(classOf[IzvorFinanciranja]) flatMap
            {
                izfin =>
                    bind("izfin", chooseTemplate("izvorfin", "entry", xhtml),
                        "id" -> Text(izfin.getIdString),
                        "naziv" -> Text(izfin.getNaziv),
                        "actions" -> createManageActions[IzvorFinanciranja](izfin))
            }
    }

    def edit(xhtml: NodeSeq): NodeSeq =
    {
        val izfin: IzvorFinanciranja = selectedRecord
        val izfinBuilder = IzvorFinanciranja.builder(izfin)

        bind("izfin", xhtml,
            "id" -> Text(izfin.getIdString),
            "naziv" -> SHtml.text(izfin.getNaziv, izfinBuilder.naziv(_)),
            "save" -> SHtml.submit("save", () => {requestVar(izfin); updateRecord(izfinBuilder)}))
    }

    def create(xhtml: NodeSeq): NodeSeq =
    {
        var izfinBuilder = IzvorFinanciranja.builder()

        bind("izfin", xhtml,
            "id" -> SHtml.text("", s => izfinBuilder.id(s), "class" -> "numberinput2"),
            "naziv" -> SHtml.text("", izfinBuilder.naziv(_)),
            "create" -> SHtml.submit("create", () => createRecord(izfinBuilder)))
    }
}