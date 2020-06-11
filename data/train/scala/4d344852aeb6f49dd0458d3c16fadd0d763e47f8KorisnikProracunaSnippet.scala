package sppp.snippet

import net.liftweb.http._
import xml.NodeSeq
import net.liftweb.util.Helpers._
import xml.Text
import sppp.menu.SnippetSiteMap
import spj.shared.domain.{OrganizacijskaJedinica, Glava, KorisnikProracuna, SpjDomainModel}
import java.lang.Long

object KorisnikProracunaSnippet extends SnippetSiteMap
{
    val editEntry = ("EditKorisnikProracuna", "sifrarnici/korisnikproracuna/edit")
    val createEntry = ("CreateKorisnikProracuna", "sifrarnici/korisnikproracuna/create")
    val manageEntry = ("KorisnikProracuna", "sifrarnici/korisnikproracuna/manage")
}

class KorisnikProracunaSnippet extends SpppSnippet
{
    val requestVar = new RequestVar[SpjDomainModel](KorisnikProracuna.builder().defaultValue())
    {}

    val manageEntryLoc = KorisnikProracunaSnippet.manageEntry._2
    val editEntryLoc = KorisnikProracunaSnippet.editEntry._2

    def manage(xhtml: NodeSeq): NodeSeq =
    {
        readAllRecords(classOf[KorisnikProracuna]) flatMap
            {
                korpro =>
                    bind("korpro", chooseTemplate("korisnikProracuna", "entry", xhtml),
                        "id" -> Text(korpro.getIdString),
                        "naziv" -> Text(korpro.getNaziv),
                        "glava" -> Text(korpro.getGlava.getNaziv),
                        "actions" -> createManageActions[KorisnikProracuna](korpro, classOf[OrganizacijskaJedinica]))
            }
    }

    def edit(xhtml: NodeSeq): NodeSeq =
    {
        val korpro: KorisnikProracuna = selectedRecord
        val korproBuilder = KorisnikProracuna.builder(korpro)

        bind("korpro", xhtml,
            "id" -> Text(korpro.getIdString),
            "naziv" -> SHtml.text(korpro.getNaziv, korproBuilder.naziv(_)),
            "glava" -> generateRecordSelect(korpro.getGlava.getId.toString, classOf[Glava], (s: Glava) => korproBuilder.glava(s)),
            "save" -> SHtml.submit("save", () => {requestVar(korpro); updateRecord(korproBuilder)}))
    }

    def create(xhtml: NodeSeq): NodeSeq =
    {
        val korisnikProracunaBuilder = KorisnikProracuna.builder();

        bind("korpro", xhtml,
            "id" -> SHtml.text("", s => korisnikProracunaBuilder.id(s), "class" -> "numberinput2-5"),
            "naziv" -> SHtml.text("", korisnikProracunaBuilder.naziv(_)),
            "glava" -> generateRecordSelect("", classOf[Glava], (s: Glava) => korisnikProracunaBuilder.glava(s)),
            "create" -> SHtml.submit("save", () => createRecord(korisnikProracunaBuilder)))
    }
}