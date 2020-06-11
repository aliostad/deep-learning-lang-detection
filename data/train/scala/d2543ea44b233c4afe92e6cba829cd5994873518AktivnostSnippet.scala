package sppp.snippet

import sppp.menu.SnippetSiteMap
import xml.{Text, NodeSeq}
import net.liftweb.http.{SHtml, RequestVar}
import spj.shared.domain._
import net.liftweb.util.Helpers._
import xml.Text

object AktivnostSnippet extends SnippetSiteMap
{
    val editEntry = ("EditAktivnost", "sifrarnici/aktivnost/edit")
    val createEntry = ("CreateAktivnost", "sifrarnici/aktivnost/create")
    val manageEntry = ("Aktivnost", "sifrarnici/aktivnost/manage")
}

class AktivnostSnippet extends SpppSnippet
{
    val requestVar = new RequestVar[SpjDomainModel](Aktivnost.builder().defaultValue())
    {}
    val manageEntryLoc = AktivnostSnippet.manageEntry._2
    val editEntryLoc = AktivnostSnippet.editEntry._2

    def manage(xhtml: NodeSeq) =
    {
        readAllRecords(classOf[Aktivnost]) flatMap
            {
                akt =>
                    bind("akt", chooseTemplate("aktivnost", "entry", xhtml),
                        "id" -> Text(akt.getIdString),
                        "naziv" -> Text(akt.getNaziv),
                        "zakonska" -> Text(akt.getZakonskaOsnova),
                        "opis" -> Text(akt.getOpis),
                        "opciCilj" -> Text(akt.getOpciCilj),
                        "program" -> Text(akt.getProgram.getNaziv),
                        "funkcija" -> Text(akt.getFunkcija.getNaziv),
                        "mjesto" -> Text(akt.getMjesto.getNaziv),
                        "izvor" -> Text(akt.getIzvorFinanciranja.getNaziv),
                        "pokuspjeha" -> Text(akt.getPokazateljUspijeha),
                        "actions" -> createManageActions[Aktivnost](akt))
            }
    }

    def edit(xhtml: NodeSeq) =
    {

        val akt: Aktivnost = selectedRecord
        val aktBuilder = Aktivnost.builder(akt)

        bind("akt", xhtml,
            "id" -> Text(akt.getIdString),
            "naziv" -> SHtml.text(akt.getNaziv, aktBuilder.naziv(_)),
            "zakonska" -> SHtml.text(akt.getZakonskaOsnova, aktBuilder.zakonskaOsnova(_)),
            "opis" -> SHtml.text(akt.getOpis, aktBuilder.opis(_)),
            "opciCilj" -> SHtml.text(akt.getOpciCilj, aktBuilder.opciCilj(_)),
            "program" -> generateRecordSelect(akt.getProgram.getIdString, classOf[Program], (s: Program) => aktBuilder.program(s)),
            "funkcija" -> generateRecordSelect(akt.getProgram.getIdString, classOf[Funkcija], (s: Funkcija) => aktBuilder.funkcija(s)),
            "mjesto" -> generateRecordSelect(akt.getProgram.getIdString, classOf[Mjesto], (s: Mjesto) => aktBuilder.mjesto(s)),
            "izvor" -> generateRecordSelect(akt.getProgram.getIdString, classOf[IzvorFinanciranja], (s: IzvorFinanciranja) => aktBuilder.izvoriFinanciranja(s)),
            "pokuspjeha" -> SHtml.text(akt.getPokazateljUspijeha, aktBuilder.pokazateljUspijeha(_)),
            "save" -> SHtml.submit("save", () =>
            {
                requestVar(akt);
                updateRecord(aktBuilder)
            }))
    }

    def create(xhtml: NodeSeq) =
    {
        var aktBuilder = Aktivnost.builder()

        bind("akt", xhtml,
            "id" -> SHtml.text("", s => aktBuilder.id(s), "class" -> "numberinput_akt6"),
            "naziv" -> SHtml.text("", aktBuilder.naziv(_)),
            "zakonska" -> SHtml.text("", aktBuilder.zakonskaOsnova(_)),
            "opis" -> SHtml.text("", aktBuilder.opis(_)),
            "opciCilj" -> SHtml.text("", aktBuilder.opciCilj(_)),
            "program" -> generateRecordSelect("", classOf[Program], (s: Program) => aktBuilder.program(s)),
            "funkcija" -> generateRecordSelect("", classOf[Funkcija], (s: Funkcija) => aktBuilder.funkcija(s)),
            "mjesto" -> generateRecordSelect("", classOf[Mjesto], (s: Mjesto) => aktBuilder.mjesto(s)),
            "izvor" -> generateRecordSelect("", classOf[IzvorFinanciranja], (s: IzvorFinanciranja) => aktBuilder.izvoriFinanciranja(s)),
            "pokuspjeha" -> SHtml.text("", aktBuilder.pokazateljUspijeha(_)),
            "create" -> SHtml.submit("create", () => createRecord(aktBuilder)))
    }
}
