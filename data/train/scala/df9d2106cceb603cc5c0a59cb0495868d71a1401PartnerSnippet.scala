package sppp.snippet

import sppp.menu.SnippetSiteMap
import net.liftweb.http.{SHtml, RequestVar}
import spj.shared.domain.{Mjesto, Partner, SpjDomainModel}
import xml.{Text, NodeSeq}
import net.liftweb.util.Helpers._

object PartnerSnippet extends SnippetSiteMap
{
    val editEntry = ("EditPartner", "sifrarnici/partner/edit")
    val createEntry = ("CreatePartner", "sifrarnici/partner/create")
    val manageEntry = ("Partner", "sifrarnici/partner/manage")
}

class PartnerSnippet extends SpppSnippet
{
    val requestVar = new RequestVar[SpjDomainModel](Partner.builder().defaultValue())
    {}
    val manageEntryLoc = PartnerSnippet.manageEntry._2
    val editEntryLoc = PartnerSnippet.editEntry._2

    def manage(xhtml: NodeSeq) =
    {
        readAllRecords(classOf[Partner]) flatMap
            {
                par =>
                    bind("par", chooseTemplate("partner", "entry", xhtml),
                        "id" -> Text(par.getIdString),
                        "naziv" -> Text(par.getNaziv),
                        "telefon" -> Text(par.getTelefon),
                        "odgovornaOsoba" -> Text(par.getOdgovornaOsoba),
                        "fax" -> Text(par.getFax),
                        "ziroracun" -> Text(par.getZiroRacun),
                        "oib" -> Text(par.getOib),
                        "email" -> Text(par.getEmail),
                        "adresa" -> Text(par.getAdresa),
                        "mjesto" -> Text(par.getMjesto.getNaziv),
                        "actions" -> createManageActions[Partner](par))
            }
    }

    def edit(xhtml: NodeSeq) =
    {

        val par: Partner = selectedRecord
        val parBuilder = Partner.builder(par)

        bind("par", xhtml,
            "id" -> Text(par.getIdString),
            "naziv" -> SHtml.text(par.getNaziv, s => parBuilder.naziv(s)),
            "telefon" -> SHtml.text(par.getTelefon, s => parBuilder.telefon(s), "class" -> "numberinput"),
            "odgovornaOsoba" -> SHtml.text(par.getOdgovornaOsoba, s => parBuilder.odgovornaOsoba(s)),
            "fax" -> SHtml.text(par.getFax, s => parBuilder.fax(s)),
            "ziroracun" -> SHtml.text(par.getZiroRacun, s => parBuilder.ziroRacun(s), "class" -> "ziroracun"),
            "oib" -> SHtml.text(par.getOib, s => parBuilder.oib(s),  "class" -> "numberinput11"),
            "email" -> SHtml.text(par.getEmail, s => parBuilder.email(s)),
            "adresa" -> SHtml.text(par.getAdresa, s => parBuilder.adresa(s)),
            "mjesto" -> generateRecordSelect(par.getMjesto.getIdString, classOf[Mjesto], (s: Mjesto) => parBuilder.mjesto(s)),
            "save" -> SHtml.submit("save", () =>
            {
                requestVar(par);
                updateRecord(parBuilder)
            }))
    }

    def create(xhtml: NodeSeq) =
    {
        val parBuilder = Partner.builder()

        bind("par", xhtml,
            "id" -> SHtml.text("", s => parBuilder.id(s), "class" -> "numberinput"),
            "naziv" -> SHtml.text("", s => parBuilder.naziv(s)),
            "telefon" -> SHtml.text("", s => parBuilder.telefon(s), "class" -> "numberinput"),
            "odgovornaOsoba" -> SHtml.text("", s => parBuilder.odgovornaOsoba(s)),
            "fax" -> SHtml.text("", s => parBuilder.fax(s)),
            "ziroracun" -> SHtml.text("", s => parBuilder.ziroRacun(s), "class" -> "ziroracun"),
            "oib" -> SHtml.text("", s => parBuilder.oib(s),  "class" -> "numberinput11"),
            "email" -> SHtml.text("", s => parBuilder.email(s)),
            "adresa" -> SHtml.text("", s => parBuilder.adresa(s)),
            "mjesto" -> generateRecordSelect("", classOf[Mjesto], (s: Mjesto) => parBuilder.mjesto(s)),
            "create" -> SHtml.submit("create", () => createRecord(parBuilder)))
    }


}
