package sppp.snippet

import net.liftweb.http._
import xml.NodeSeq
import net.liftweb.util.Helpers._
import spj.shared.domain.{Izvod, Konto, SpjDomainModel}
import xml.Text
import sppp.menu.SnippetSiteMap
import java.lang.Long

object KontoSnippet extends SnippetSiteMap
{
    val editEntry = ("EditKonto", "sifrarnici/konto/edit")
    val createEntry = ("CreateKonto", "sifrarnici/konto/create")
    val manageEntry = ("Konto", "sifrarnici/konto/manage")
}

//class KontoSnippet extends SpppSnippet
//{
//
//    val requestVar = new RequestVar[SpjDomainModel](Konto.builder().defaultValue())
//    {}
//    val manageEntryLoc = KontoSnippet.manageEntry._2
//    val editEntryLoc = KontoSnippet.editEntry._2
//
//    def manage(xhtml: NodeSeq): NodeSeq =
//    {
//        readAllRecords(classOf[Konto]) flatMap
//            {
//                ko =>
//                    bind("ko", chooseTemplate("konto", "entry", xhtml),
//                        "id" -> Text(ko.getId().toString),
//                        "naziv" -> Text(ko.getNaziv),
//                        "saldokonto" -> Text(ko.getImaSaldokonto),
//                        "uporaba" -> Text(ko.getKoristiSe),
//                        "obveza" -> Text(ko.getObveza),
//                        "potrazivanje" -> Text(ko.getPotrazivanje),
//                        "actions" -> createManageActions[Konto](ko, classOf[Izvod]))
//            }
//    }
//
//    def edit(xhtml: NodeSeq): NodeSeq = {
//        val konto : Konto = selectedRecord
//
//        bind("ko", xhtml,
//            "id" -> Text(konto.getId().toString),
//            "naziv" -> SHtml.text(konto.getNaziv, konto.setNaziv(_)),
//            "saldokonto" -> SHtml.checkbox(konto.getImaSaldokonto, konto.setImaSaldokonto(_)),
//            "uporaba" -> SHtml.checkbox(konto.getKoristiSe, konto.setKoristiSe(_)),
//            "obveza" -> SHtml.checkbox(konto.getObveza, konto.setObveza(_)),
//            "potrazivanje" -> SHtml.checkbox(konto.getPotrazivanje, konto.setPotrazivanje(_)),
//            "save" -> SHtml.submit("save", () => updateRecord(konto)))
//    }
//
//    def create(xhtml: NodeSeq): NodeSeq = {
//
//        val kontoBuilder = Konto.builder()
//
//        bind("ko", xhtml,
//            "id" -> SHtml.text("", s => kontoBuilder.id(Long.valueOf(s))),
//            "naziv" -> SHtml.text("", kontoBuilder.naziv(_)),
//            "saldokonto" -> SHtml.checkbox(false, kontoBuilder.imaSaldokonto(_)),
//            "uporaba" -> SHtml.checkbox(false, kontoBuilder.koristiSe(_)),
//            "obveza" -> SHtml.checkbox(false, kontoBuilder.obveza(_)),
//            "potrazivanje" -> SHtml.checkbox(false, kontoBuilder.potrazivanje(_)),
//            "create" -> SHtml.submit("create", () => createRecord(kontoBuilder.build())))
//    }
//}