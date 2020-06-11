package sppp.snippet

import sppp.menu.SnippetSiteMap
import xml.{Text, NodeSeq}
import net.liftweb.http.{SHtml, RequestVar}
import spj.shared.domain.{Konto, Izvod, SpjDomainModel}
import net.liftweb.util.Helpers._
import java.lang.Long

object IzvodSnippet extends SnippetSiteMap
{
    val editEntry = ("EditIzvod", "sifrarnici/izvod/edit")
    val createEntry = ("CreateIzvod", "sifrarnici/izvod/create")
    val manageEntry = ("Izvod", "sifrarnici/izvod/manage")
}

//class IzvodSnippet extends SpppSnippet
//{
//    val requestVar = new RequestVar[SpjDomainModel](Izvod.builder().defaultValue())
//    {}
//    val manageEntryLoc = IzvodSnippet.manageEntry._2
//    val editEntryLoc = IzvodSnippet.editEntry._2
//
//    def manage(xhtml: NodeSeq): NodeSeq =
//    {
//        readAllRecords(classOf[Izvod]) flatMap
//            {
//                iz =>
//                    bind("iz", chooseTemplate("izvod", "entry", xhtml),
//                        "id" -> Text(iz.getId.toString),
//                        "brojIzvoda" -> Text(iz.getBrojIzvoda.toString),
//                        "datum" -> Text(iz.getDatum()),
//                        "iznos" -> Text(iz.getIznos.toString),
//                        "opis" -> Text(iz.getOpis),
//                        "konto" -> Text(iz.getKonto.getIdentifier),
//                        "zakljucen" -> Text(iz.getZakljucen),
//                        "actions" -> createManageActions[Izvod](iz))
//            }
//
//    }
//
//    def edit(xhtml: NodeSeq): NodeSeq =
//    {
//        val izvod: Izvod = selectedRecord
//
//        bind("iz", xhtml,
//            "id" -> Text(izvod.getId.toString),
//            "brojIzvoda" -> SHtml.text(izvod.getBrojIzvoda.toString, s => izvod.setBrojIzvoda(Integer.valueOf(s))),
//            "datum" -> SHtml.text(izvod.getDatum, s => izvod.setDatum(s), "class" -> "date"),
//            "iznos" -> SHtml.text(izvod.getIznos.toString, s => izvod.setIznos(Long.valueOf(s))),
//            "opis" -> SHtml.text(izvod.getOpis, izvod.setOpis(_)),
//            "konto" -> generateRecordSelect(izvod.getKonto.getId.toString, classOf[Konto], (konto: Konto) => izvod.setKonto(konto)),
//            "zakljucen" -> SHtml.checkbox(izvod.getZakljucen, izvod.setZakljucen(_)),
//            "save" -> SHtml.submit("save", () => updateRecord(izvod)))
//    }
//
//    def create(xhtml: NodeSeq): NodeSeq =
//    {
//        val izvodBuilder = Izvod.builder()
//
//        bind("iz", xhtml,
//            "id" -> SHtml.text("", s => izvodBuilder.id(Long.valueOf(s))),
//            "brojIzvoda" -> SHtml.text("", s => izvodBuilder.brojIzvoda(Integer.valueOf(s))),
//            "datum" -> SHtml.text("", s => izvodBuilder.datum(s), "class" -> "date"),
//            "iznos" -> SHtml.text("", s => izvodBuilder.iznos(Long.valueOf(s))),
//            "opis" -> SHtml.text("", izvodBuilder.opis(_)),
//            "konto" -> generateRecordSelect("", classOf[Konto], (konto: Konto) => izvodBuilder.konto(konto)),
//            "zakljucen" -> SHtml.checkbox(false, izvodBuilder.zakljucen(_)),
//            "create" -> SHtml.submit("create", () => createRecord(izvodBuilder.build())))
//    }
//}

