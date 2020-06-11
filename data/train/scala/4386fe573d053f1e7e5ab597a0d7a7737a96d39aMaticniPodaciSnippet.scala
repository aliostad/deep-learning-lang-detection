package sppp.snippet

import net.liftweb.http.RequestVar
import spj.shared.domain.{MaticniPodaci, SpjDomainModel, Mjesto}
import xml.NodeSeq
import net.liftweb.util.Helpers._
import xml.Text
import net.liftweb.http.SHtml
import sppp.menu.SnippetSiteMap

object MaticniPodaciSnippet extends SnippetSiteMap
{
    val editEntry = ("EditMaticniPodaci", "sifrarnici/maticnipodaci/edit")
    val createEntry = ("CreateMaticniPodaci", "sifrarnici/maticnipodaci/create")
    val manageEntry = ("Maticni Podaci", "sifrarnici/maticnipodaci/manage")
}

class MaticniPodaciSnippet extends SpppSnippet
{
    val requestVar = new RequestVar[SpjDomainModel](MaticniPodaci.builder().defaultValue())
    {}
    val manageEntryLoc = MaticniPodaciSnippet.manageEntry._2
    val editEntryLoc = MaticniPodaciSnippet.editEntry._2

    def manage(xhtml: NodeSeq) =
    {
        readAllRecords(classOf[MaticniPodaci]) flatMap
            {
                mpod =>
                    bind("mpod", chooseTemplate("maticniPodaci", "entry", xhtml),
                        "id" -> Text(mpod.getIdString),
                        "naziv" -> Text(mpod.getNaziv),
                        "telefon" -> Text(mpod.getTelefon),
                        "odgovornaOsoba" -> Text(mpod.getOdgovornaOsoba),
                        "fax" -> Text(mpod.getFax),
                        "ziroracun" -> Text(mpod.getZiroRacun),
                        "oib" -> Text(mpod.getOib),
                        "adresa" -> Text(mpod.getAdresa),
                        "mjesto" -> Text(mpod.getMjesto.getNaziv),
                        "actions" -> createManageActions[MaticniPodaci](mpod))
            }
    }

    def edit(xhtml: NodeSeq) =
    {

        val mpod: MaticniPodaci = selectedRecord
        val mpodBuilder = MaticniPodaci.builder(mpod)

        bind("mpod", xhtml,
            "id" -> Text(mpod.getIdString),
            "naziv" -> SHtml.text(mpod.getNaziv, s => mpodBuilder.naziv(s)),
            "telefon" -> SHtml.text(mpod.getTelefon, s => mpodBuilder.telefon(s)),
            "odgovornaOsoba" -> SHtml.text(mpod.getOdgovornaOsoba, s => mpodBuilder.odgovornaOsoba(s)),
            "fax" -> SHtml.text(mpod.getFax, s => mpodBuilder.fax(s)),
            "ziroracun" -> SHtml.text(mpod.getZiroRacun, s => mpodBuilder.ziroRacun(s), "class" -> "ziroracun"),
            "oib" -> SHtml.text(mpod.getOib, s => mpodBuilder.oib(s), "class" -> "numberinput11"),
            "adresa" -> SHtml.text(mpod.getAdresa, s => mpodBuilder.adresa(s)),
            "mjesto" -> generateRecordSelect(mpod.getMjesto.getIdString, classOf[Mjesto], (s: Mjesto) => mpodBuilder.mjesto(s)),
            "save" -> SHtml.submit("save", () =>
            {
                requestVar(mpod);
                updateRecord(mpodBuilder)
            }))
    }

    def create(xhtml: NodeSeq) =
    {
        val mpodBuilder = MaticniPodaci.builder()

        bind("mpod", xhtml,
            "id" -> SHtml.text("", s => mpodBuilder.id(s), "class" -> "numberinput"),
            "naziv" -> SHtml.text("", s => mpodBuilder.naziv(s)),
            "telefon" -> SHtml.text("", s => mpodBuilder.telefon(s)),
            "odgovornaOsoba" -> SHtml.text("", s => mpodBuilder.odgovornaOsoba(s)),
            "fax" -> SHtml.text("", s => mpodBuilder.fax(s)),
            "ziroracun" -> SHtml.text("", s => mpodBuilder.ziroRacun(s), "class" -> "ziroracun"),
            "oib" -> SHtml.text("", s => mpodBuilder.oib(s), "class" -> "numberinput11"),
            "adresa" -> SHtml.text("", s => mpodBuilder.adresa(s)),
            "mjesto" -> generateRecordSelect("", classOf[Mjesto], (s: Mjesto) => mpodBuilder.mjesto(s)),
            "create" -> SHtml.submit("create", () => createRecord(mpodBuilder)))
    }


}