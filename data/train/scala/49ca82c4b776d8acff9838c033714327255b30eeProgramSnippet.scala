package sppp.snippet

import sppp.menu.SnippetSiteMap
import xml.{Text, NodeSeq}
import net.liftweb.http.{SHtml, RequestVar}
import spj.shared.domain.{GlavniProgram, Program, SpjDomainModel}
import net.liftweb.util.Helpers._
import java.lang.Long

object ProgramSnippet extends SnippetSiteMap
{
    val editEntry = ("EditProgram", "sifrarnici/program/edit")
    val createEntry = ("CreateProgram", "sifrarnici/program/create")
    val manageEntry = ("Program", "sifrarnici/program/manage")
}

class ProgramSnippet extends SpppSnippet
{
    val requestVar = new RequestVar[SpjDomainModel](Program.builder().defaultValue())
    {}
    val manageEntryLoc = ProgramSnippet.manageEntry._2
    val editEntryLoc = ProgramSnippet.editEntry._2

    def manage(xhtml: NodeSeq) =
    {
        readAllRecords(classOf[Program]) flatMap
            {
                prog =>
                    bind("prog", chooseTemplate("program", "entry", xhtml),
                        "id" -> Text(prog.getIdString),
                        "naziv" -> Text(prog.getNaziv),
                        "opis" -> Text(prog.getOpis),
                        "opciCilj" -> Text(prog.getOpciCilj),
                        "pokazateljUspijeha" -> Text(prog.getPokazateljUspijeha),
                        "zakonskaOsnova" -> Text(prog.getZakonskaOsnova),
                        "brojZaposlenih" -> Text(prog.getBrojZaposlenih),
                        "glavniProgram" -> Text(prog.getGlavniProgram.getNaziv),
                        "actions" -> createManageActions[Program](prog))
            }
    }

    def edit(xhtml: NodeSeq) =
    {

        val prog: Program = selectedRecord
        val progBuilder = Program.builder(prog)

        bind("prog", xhtml,
            "id" -> Text(prog.getIdString),
            "naziv" -> SHtml.text(prog.getNaziv, progBuilder.naziv(_)),
            "opis" -> SHtml.text(prog.getOpis, progBuilder.opis(_)),
            "opciCilj" -> SHtml.text(prog.getOpciCilj, progBuilder.opciCilj(_)),
            "pokazateljUspijeha" -> SHtml.text(prog.getPokazateljUspijeha, progBuilder.pokazateljUspijeha(_)),
            "zakonskaOsnova" -> SHtml.text(prog.getZakonskaOsnova, progBuilder.zakonskaOsnova(_)),
            "brojZaposlenih" -> SHtml.text(prog.getBrojZaposlenih, s => progBuilder.brojZaposlenih(s), "class" -> "numberinput"),
            "glavniProgram" -> generateRecordSelect(prog.getGlavniProgram.getIdString, classOf[GlavniProgram], (s: GlavniProgram) => progBuilder.glavniProgram(s)),
            "save" -> SHtml.submit("save", () => {requestVar(prog); updateRecord(progBuilder)}))
    }

    def create(xhtml: NodeSeq) =
    {
        var progBuilder = Program.builder()

        bind("prog", xhtml,
            "id" -> SHtml.text("", s => progBuilder.id(s), "class" -> "numberinput4"),
            "naziv" -> SHtml.text("", progBuilder.naziv(_)),
            "opis" -> SHtml.text("", progBuilder.opis(_)),
            "opciCilj" -> SHtml.text("", progBuilder.opciCilj(_)),
            "pokazateljUspijeha" -> SHtml.text("", progBuilder.pokazateljUspijeha(_)),
            "zakonskaOsnova" -> SHtml.text("", progBuilder.zakonskaOsnova(_)),
            "brojZaposlenih" -> SHtml.text("", s => progBuilder.brojZaposlenih(s), "class" -> "numberinput"),
            "glavniProgram" -> generateRecordSelect("", classOf[GlavniProgram], (s: GlavniProgram) => progBuilder.glavniProgram(s)),
            "create" -> SHtml.submit("create", () => createRecord(progBuilder)))
    }
}
