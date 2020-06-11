import scala.xml.{Node, XML}
import com.tinkerpop.gremlin.scala._
import org.slf4j.LoggerFactory
import java.io.File
import GraphUtils._
import com.tinkerpop.blueprints.Graph


object LookupLoader {
  private val Log = LoggerFactory.getLogger(getClass)

  def apply(path: File, graph: Graph) {
    def loadInfos(infosXml: Node) =
      infosXml \ "INFO" foreach loadInfo(infosXml.label)

    def loadInfo(infoType: String)(infoXml: Node) {
      val vertex = graph.addV()
      Log trace s"Add vertex $infoType ${(infoXml \ "CD").text}"

      vertex.setProperty("type", infoType)
      (infoXml \ "CD").headOption map (setVertexId(_, vertex, graph))

      val setDmdProperty = setVertexProperty(_: Node, vertex)
      (infoXml \ "CDDT").headOption map setDmdProperty
      (infoXml \ "CDPREV").headOption map setDmdProperty
      (infoXml \ "INVALID").headOption map setDmdProperty
      (infoXml \ "DESC").headOption map setDmdProperty orElse (throw new IllegalStateException("DESC required"))
    }

    val lookupXml = XML loadFile path

    Log debug "Loading Infos"
    lookupXml \ "COMBINATION_PACK_IND" foreach loadInfos
    lookupXml \ "COMBINATION_PROD_IND" foreach loadInfos
    lookupXml \ "BASIS_OF_NAME" foreach loadInfos
    lookupXml \ "NAMECHANGE_REASON" foreach loadInfos
    lookupXml \ "VIRTUAL_PRODUCT_PRES_STATUS" foreach loadInfos
    lookupXml \ "CONTROL_DRUG_CATEGORY" foreach loadInfos
    lookupXml \ "LICENSING_AUTHORITY" foreach loadInfos
    lookupXml \ "ONT_FORM_ROUTE" foreach loadInfos
    lookupXml \ "DT_PAYMENT_CATEGORY" foreach loadInfos
    lookupXml \ "FLAVOUR" foreach loadInfos
    lookupXml \ "COLOUR" foreach loadInfos
    lookupXml \ "BASIS_OF_STRNTH" foreach loadInfos
    lookupXml \ "REIMBURSEMENT_STATUS" foreach loadInfos
    lookupXml \ "SPEC_CONT" foreach loadInfos
    lookupXml \ "DND" foreach loadInfos
    lookupXml \ "VIRTUAL_PRODUCT_NON_AVAIL" foreach loadInfos
    lookupXml \ "DISCONTINUED_IND" foreach loadInfos
    lookupXml \ "DF_INDICATOR" foreach loadInfos
    lookupXml \ "PRICE_BASIS" foreach loadInfos
    lookupXml \ "LEGAL_CATEGORY" foreach loadInfos
    lookupXml \ "AVAILABILITY_RESTRICTION" foreach loadInfos
    lookupXml \ "LICENSING_AUTHORITY_CHANGE_REASON" foreach loadInfos

    Log debug "Loading History Infos"
    lookupXml \ "UNIT_OF_MEASURE" foreach loadInfos
    lookupXml \ "FORM" foreach loadInfos
    lookupXml \ "ROUTE" foreach loadInfos

    Log debug "Loading Supplier Infos"
    lookupXml \ "SUPPLIER" foreach loadInfos
  }
}
