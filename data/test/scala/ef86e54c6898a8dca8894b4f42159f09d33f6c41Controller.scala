package io.blep.tda

import io.blep.tda.BootstrapView.resultContainer
import io.blep.tda.ThreadDumpAnalyzer.ThreadDump
import org.scalajs.dom
import org.scalajs.dom.html.{Button, TextArea}
import org.scalajs.dom.raw.{CustomEvent, Event, Element}

import scala.scalajs.js.JSApp
import scala.scalajs.js.annotation.{JSExport, JSExportNamed}
import scala.util.{Failure, Success, Try}

@JSExportNamed
class Configuration(
                     val plainDumpId: String,
                     val analyzeBtnId: String,
                     val resetBtnId: String,
                     val alertContainerId: String,
                     val resultContainerId:String,
                     val viewType:String
                     )

class Controller(val configuration: Configuration) {

  def buildViewFactory(typ:String):ThreadDump => View = typ match {
    case "bootstrap" => td => new BootstrapView(td)
  }

  val viewFactory = buildViewFactory(configuration.viewType)

  val analyzeBtn: Button = dom.document.getElementById(configuration.analyzeBtnId).asInstanceOf[Button]
  val resetBtn: Button = dom.document.getElementById(configuration.resetBtnId).asInstanceOf[Button]

  analyzeBtn.onclick = { (e: Any) => {
    reset(e)
    val plainDumpArea: TextArea = dom.document.getElementById(configuration.plainDumpId).asInstanceOf[TextArea]
    val dumpTxt: String = plainDumpArea.value
    val triedDump: Try[ThreadDump] = Try(ThreadDumpAnalyzer.parseDump(dumpTxt))
    triedDump match {
      case Success(threadDump: ThreadDump) => viewFactory(threadDump).displayResults
        switchTabs
      case Failure(e) => error(configuration.alertContainerId, e)
    }
  }
  }

  def switchTabs={
    val event = dom.document.createEvent("Event")
    event.initEvent("analysis_finished",true,true)
    dom.document.body.dispatchEvent(event)
  }

  dom.document.getElementById(configuration.resultContainerId).appendChild(resultContainer)

  def reset(e:Any)={
    val nodes = resultContainer.childNodes
    for (i <- 1 to nodes.length) resultContainer.removeChild(nodes(0))
  }
  resetBtn.onclick = reset _

  def error(containerId: String, t: Throwable) = {
    val id1: Element = dom.document.getElementById(containerId)

    id1.appendChild(BootstrapView.buildAlert(t.getMessage))
  }
}


object Controller extends JSApp {

  @JSExport
  def init(conf: Configuration) = new Controller(conf)


  @JSExport
  override def main() = {}
}
