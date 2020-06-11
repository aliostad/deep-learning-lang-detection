package lt.node.gedcom.model

import _root_.scala.xml._

//import net.liftweb.common._ //{Box, Full, Empty}


object AuditHelper {

  def checkAddFields(fieldNew: List[( /*fieldName:*/ String, /*language:*/ String, /*newValue:*/ String)]): NodeSeq = {
    //for (fn <- fieldNew) println(fn.toString);

    def checkAddField(fieldName: String, language: String, newValue: String): NodeSeq = {
      //println("|" +fieldName + "|" + language + "|" + newValue + "|")
      (language, newValue) match {
        case ("", newV) if newV != "" =>
          <f n={fieldName}>{newV}</f>
        case (lang, newV) if newV != "" =>
          /*val nv: String = "<__>"+newV+"</__>"
//println("nv=|" + nv + "|")
//println(<f n={fieldName}>{for (xx <- (XML.loadString(nv) \ "_")) yield xx}</f>.toString)
val tmpXml = <f n={fieldName}>{for (xx <- (XML.loadString(nv) \ "_")) yield xx}</f>*/
          val tmpXml = <f n={fieldName}>{XML.loadString(newV)}</f>
          tmpXml match {
            case tx if tx.text.size > 0 => tx
            case _ => NodeSeq.Empty
          }
        //<f n={fieldName}>{this.wrapText(this.getLangMsg(XML.loadString(newV), lang), lang)}</f>
        /*<f n={fieldName}>{this.wrapText(newV, lang)}</f>*/
        case _ =>
          NodeSeq.Empty
      }
    }

    <_>{for (fn <- fieldNew) yield checkAddField(fn._1, fn._2, fn._3)}</_>
  }


  def checkChanges(fieldNewOld: List[(String, String, String, String)]): NodeSeq = {
    /**
     *
     * @param fieldName
     * @param language  lt |  en | ...
     * @param newValue sample: <_ d="lt"><lt>nauja informacija</lt></_>
     * @param oldValue sample  <_ d="lt"><lt>sena informacija</lt><en>maybe some info as in lt</en></_>
     * @return
     */
    def checkChange(fieldName: String, language: String, newValue: String, oldValue: String): NodeSeq = {
      language match {
        case "" =>
           println(<_>fieldName=|{fieldName}| language=|""| newValue=|{newValue}| oldValue=|{oldValue}| </_>.text)
          (newValue, oldValue) match {
            case (newV, oldV) if newV != "" && oldV != "" && newV != oldV =>
              <f n={fieldName}><new>{newV}</new><old>{oldV}</old></f>
            case (newV, oldV) if newV != "" && oldV == "" =>
              <f n={fieldName}><new>{newV}</new></f>
            case (newV, oldV) if newV == "" && oldV != "" =>
              <f n={fieldName}><old>{oldV}</old></f>
            case _ => NodeSeq.Empty
          }
        case lang =>
          println(<_>fieldName=|{fieldName}| language=|{lang}| newValue=|{newValue}| oldValue=|{oldValue}| </_>.text)
//        val new_Value = AuditHelper.getLangMsg(XML.loadString/*Unparsed*/(newValue), lang)
//        val old_Value = AuditHelper.getLangMsg(XML.loadString/*Unparsed*/(oldValue), lang)
//        println(<_>language=|{lang}| new_Value=|{new_Value}| old_Value=|{old_Value}| </_>.text)
          (newValue, oldValue) match {
            case (newV, oldV) if newV != "" && oldV != "" && newV != oldV =>
              // println("aaa")
              val new_Value = AuditHelper.getLangMsg(XML.loadString(newValue), lang)
              val old_Value = AuditHelper.getLangMsg(XML.loadString(oldValue), lang)
              <f n={fieldName}><new>{new_Value}</new><old>{old_Value}</old></f>
              //<f n={fieldName}><new>{this.wrapText(this.getLangMsg(XML.loadString(newV), lang), lang)}</new><old>{this.wrapText(this.getLangMsg(XML.loadString(oldV), lang), lang)}</old></f>
              /*<f n={fieldName}><new>{this.wrapText(newV, lang)}</new><old>{this.wrapText(oldV, lang)}</old></f>*/
            case (newV, oldV) if newV != "" && oldV == "" =>
              // println("bbb")
              val new_Value = AuditHelper.getLangMsg(XML.loadString(newValue), lang)
              <f n={fieldName}><new>{new_Value}</new></f>
              //<f n={fieldName}><new>{this.wrapText(this.getLangMsg(XML.loadString(newV), lang), lang)}</new></f>
              /*<f n={fieldName}><new>{this.wrapText(newV, lang)}</new></f>*/
            case (newV, oldV) if newV == "" && oldV != "" =>
              // println("ccc")
              val old_Value = AuditHelper.getLangMsg(XML.loadString(oldValue), lang)
              <f n={fieldName}><old>{old_Value}</old></f>
              //<f n={fieldName}><old>{this.wrapText(this.getLangMsg(XML.loadString(oldV), lang), lang)}</old></f>
              /*<f n={fieldName}><old>{this.wrapText(oldV, lang)}</old></f>*/
            case (newV, oldV) if newV == "" && oldV == "" =>
              // println("ddd")
              NodeSeq.Empty
            case _ => NodeSeq.Empty
          }
      }
    }

    <_>{for (fno <- fieldNewOld) yield checkChange(fno._1, fno._2, fno._3, fno._4)}</_>
  }


//  def checkChange(fieldName: String, language: String, newValue: String, oldValue: String):NodeSeq = {
//    (language, newValue, oldValue) match {
//      case ("", newV, oldV) if newV != null && oldV != null && newV != oldV =>
//        <f n={fieldName}><new>{newV}</new><old>{oldV}</old></f>
//      case (lang, newV, oldV) if newV != null && oldV != null && newV != oldV =>
//        <f n={fieldName}><new>{this.wrapText(newV, lang)}</new><old>{this.wrapText(oldV, lang)}</old></f>
//      case ("", newV, oldV) if newV != null && oldV == null =>
//        <f n={fieldName}><new>{newV}</new></f>
//      case ("", newV, oldV) if newV == null && oldV != null =>
//        <f n={fieldName}><old>{oldV}</old></f>
//      case (lang, newV, oldV) if newV != null && oldV == null =>
//        <f n={fieldName}><new>{this.wrapText(newV, lang)}</new></f>
//      case (lang, newV, oldV) if newV == null && oldV != null =>
//        <f n={fieldName}><old>{this.wrapText(oldV, lang)}</old></f>
//      case _ => NodeSeq.Empty
//    }
//  }


  def wrapText(text: String, lang: String): NodeSeq = {
    // see explanation in gedcom-spa/pom.xml  MultiLangText.wrapText(text, lang)
    lang match {
      case "lt" => <lt>{text}</lt>
      case "en" => <en>{text}</en>
      case "de" => <de>{text}</de>
      case "pl" => <pl>{text}</pl>
      case "ru" => <ru>{text}</ru>
      case _    => <xx>{text}</xx>
    }
  }


  def wrapText(text: String): NodeSeq = {
    // see explanation in gedcom-spa/pom.xml  MultiLangText.wrapText(text)
    import net.liftweb.http.S
    this.wrapText(text, S.locale.getLanguage.toLowerCase)
  }


  def getLangMsgXml(dbFieldXml: NodeSeq, lang: String): NodeSeq = {
//    println(<_>getLangMsgXml: dbFieldXml=|{dbFieldXml.toString}| </_>.text)
    AuditHelper.hasLang(dbFieldXml, lang) match {
      case true =>
//        println("true")
        (dbFieldXml \\ lang)
      case _ =>
//        println("false")
        AuditHelper.wrapText("", lang)
    }
  }


  def getLangMsg(dbField: NodeSeq, lang: String): String = {
    getLangMsgXml(dbField, lang).text
  }


  def hasLang(dbFieldXml: NodeSeq, lang: String): Boolean = {
  // see explanation in gedcom-spa/pom.xml  MultiLangText.hasLang(dbFieldXml, lang)
//    println(<_>hasLang: ((x \\ lang)=|{(dbFieldXml \\ lang).toString}| </_>.text)
    dbFieldXml match {
      case x if ((x \\ lang).size == 1) =>
        true
      case x if ((x \\ lang).size == 0) =>
        false
      case _ =>
        true
    }
  }

}

// http://programming-scala.labs.oreilly.com/ch10.html
// http://grahamhackingscala.blogspot.com/2009/11/xml-generation-with-scala.html
// http://stackoverflow.com/questions/2199040/scala-xml-building-adding-children-to-existing-nodes?tab=active#tab-top
// http://www.codecommit.com/blog/scala/working-with-scalas-xml-support  !!!
// http://daily-scala.blogspot.com/2009/12/xml-transformation-1.html
// http://szeiger.de/blog/2009/12/27/a-zipper-for-scala-xml/
// http://scala-programming-language.1934581.n4.nabble.com/Matching-XML-elements-with-a-specific-value-for-an-attribute-td2001793.html
// https://github.com/lift/framework/blob/irc_issue_872_873/core/util/src/test/scala/net/liftweb/util/TimeHelpersSpec.scala

