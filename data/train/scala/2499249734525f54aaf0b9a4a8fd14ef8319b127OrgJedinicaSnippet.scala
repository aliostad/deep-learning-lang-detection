package sppp.snippet

import net.liftweb.http._
import xml.NodeSeq
import net.liftweb.util.Helpers._
import spj.shared.domain.{KorisnikProracuna, OrganizacijskaJedinica, SpjDomainModel}
import java.lang.Long
import xml.Text
import sppp.menu.SnippetSiteMap

object OrgJedinicaSnippet extends SnippetSiteMap
{
    val editEntry = ("EditOrgJedinica", "sifrarnici/organizacijskajedinica/edit")
    val createEntry = ("CreateOrgJedinica", "sifrarnici/organizacijskajedinica/create")
    val manageEntry = ("Organizacijska Jedinica", "sifrarnici/organizacijskajedinica/manage")
}

class OrgJedinicaSnippet extends SpppSnippet
{
    val requestVar = new RequestVar[SpjDomainModel](OrganizacijskaJedinica.builder().defaultValue())
    {}
    val manageEntryLoc = OrgJedinicaSnippet.manageEntry._2
    val editEntryLoc = OrgJedinicaSnippet.editEntry._2

    def manage(xhtml: NodeSeq): NodeSeq =
    {
        readAllRecords(classOf[OrganizacijskaJedinica]) flatMap
            {
                oj =>
                    bind("oj", chooseTemplate("orgjed", "entry", xhtml),
                        "id" -> Text(oj.getIdString),
                        "naziv" -> Text(oj.getNaziv),
                        "korpro" -> Text(oj.getKorisnikProracuna.getNaziv),
                        "actions" -> createManageActions[OrganizacijskaJedinica](oj))
            }
    }

    def edit(xhtml: NodeSeq): NodeSeq =
    {
        val oj: OrganizacijskaJedinica = selectedRecord
        val ojBuilder = OrganizacijskaJedinica.builder(oj)

        bind("oj", xhtml,
            "id" -> Text(oj.getIdString),
            "naziv" -> SHtml.text(oj.getNaziv, ojBuilder.naziv(_)),
            "korpro" -> generateRecordSelect(oj.getKorisnikProracuna.getId.toString, classOf[KorisnikProracuna], (s: KorisnikProracuna) => ojBuilder.korisnikProracuna(s)),
            "save" -> SHtml.submit("save", () => {requestVar(oj); updateRecord(ojBuilder)}))
    }

    def create(xhtml: NodeSeq): NodeSeq =
    {
        var ojBuilder = OrganizacijskaJedinica.builder()

        bind("oj", xhtml,
            "id" -> SHtml.text("", s => ojBuilder.id(s), "class" -> "numberinput"),
            "naziv" -> SHtml.text("", ojBuilder.naziv(_)),
            "korpro" -> generateRecordSelect("", classOf[KorisnikProracuna], (s: KorisnikProracuna) => ojBuilder.korisnikProracuna(s)),
            "create" -> SHtml.submit("create", () => createRecord(ojBuilder)))
    }
}