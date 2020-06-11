package sppp.snippet

import net.liftweb.http._
import xml.NodeSeq
import net.liftweb.util.Helpers._
import spj.shared.domain.{KorisnikProracuna, Razdjel, Glava, SpjDomainModel}
import java.lang.Long
import xml.Text
import sppp.menu.SnippetSiteMap

object GlavaSnippet extends SnippetSiteMap
{
    val editEntry = ("EditGlava", "sifrarnici/glava/edit")
    val createEntry = ("CreateGlava", "sifrarnici/glava/create")
    val manageEntry = ("Glava", "sifrarnici/glava/manage")
}

class GlavaSnippet extends SpppSnippet
{
    val requestVar = new RequestVar[SpjDomainModel](Glava.builder().defaultValue())
    {}
    val manageEntryLoc = GlavaSnippet.manageEntry._2
    val editEntryLoc = GlavaSnippet.editEntry._2

    def manage(xhtml: NodeSeq): NodeSeq =
    {
        readAllRecords(classOf[Glava]) flatMap
            {
                gl =>
                    bind("gl", chooseTemplate("glava", "entry", xhtml),
                        "id" -> Text(gl.getIdString),
                        "nazivGlave" -> Text(gl.getNaziv),
                        "nazivRazdjela" -> Text(gl.getRazdjel.getNaziv),
                        "actions" -> createManageActions[Glava](gl, classOf[KorisnikProracuna]))
            }
    }

    def edit(xhtml: NodeSeq): NodeSeq =
    {
        val gl: Glava = selectedRecord
        val glBuilder = Glava.builder(gl)

        bind("gl", xhtml,
            "id" -> Text(gl.getIdString),
            "nazivGlave" -> SHtml.text(gl.getNaziv, glBuilder.naziv(_)),
            "nazivRazdjela" -> Text(gl.getRazdjel.getNaziv),
            "save" -> SHtml.submit("save", () =>{requestVar(gl); updateRecord(glBuilder)}))
    }

    def create(xhtml: NodeSeq): NodeSeq =
    {
        var glBuilder = Glava.builder()

        bind("gl", xhtml,
            "id" -> SHtml.text("", s => glBuilder.id(s), "class" -> "numberinput2"),
            "nazivGlave" -> SHtml.text("", glBuilder.naziv(_)),
            "nazivRazdjela" -> generateRecordSelect("", classOf[Razdjel], (s: Razdjel) => glBuilder.razdjel(s)),
            "create" -> SHtml.submit("create", () => createRecord(glBuilder)))
    }
}