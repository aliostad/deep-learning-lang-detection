package org.purview.qtui.meta

import com.trolltech.qt.QSignalEmitter
import org.purview.core.analysis.Analyser
import org.purview.core.analysis.Metadata
import org.purview.core.data.ImageMatrix
import org.purview.core.report.ReportEntry
import org.purview.core.session.AnalysisSession
import org.purview.core.session.AnalysisStats
import scala.actors.Actor

case class Analysis(matrix: ImageMatrix, name: String, analysers: Seq[Analyser[ImageMatrix]]) extends QSignalEmitter {

  def analyser: String = stats.oldAnalyser
  val analyserChanged = new Signal1[String]

  def status: String = stats.oldStatus
  val statusChanged = new Signal1[String]

  def progress: Float = stats.oldProgress
  val progressChanged = new Signal1[Float]

  def subProgress: Float = stats.oldSubProgress
  val subProgressChanged = new Signal1[Float]

  val error = new Signal1[String]

  def hasFinished = _done
  val finished = new Signal0

  @volatile private var _done = false
  @volatile private var _results: Option[Map[Metadata, Seq[ReportEntry]]] = None
  def results = _results

  private val stats = new AnalysisStats {
    var oldProgress = 0f
    var oldSubProgress = 0f
    var oldStatus = ""
    var oldAnalyser = ""

    override def reportProgress(progress: Float) =
      if((oldProgress * 100).toInt != (progress * 100).toInt) {
        oldProgress = progress
        progressChanged.emit(progress)
      }

    override def reportSubProgress(progress: Float) =
      if((oldSubProgress * 100).toInt != (progress * 100).toInt) {
        oldSubProgress = progress
        subProgressChanged.emit(progress)
      }

    override def reportStatus(status: String) =
      if(oldStatus != status) {
        oldStatus = status
        statusChanged.emit(status)
      }

    override def reportAnalyser(analyser: String) =
      if(oldAnalyser != analyser) {
        oldAnalyser = analyser
        analyserChanged.emit(analyser)
      }
  }

  def analyse(): Unit = Actor.actor {
    val report = try
      new AnalysisSession(analysers, matrix).run(stats)
    catch {
      case err =>
        val str = err.getMessage + "\n" + err.getStackTraceString
        error.emit(str)
        println(str)
        throw new Throwable("Error in analyser", err)
    }
    val sortedReport = for {
      (analyser, entries) <- report
      sortedEntries = entries.toSeq.sortBy(_.level.name)
    } yield (analyser, sortedEntries)
    stats.reportStatus("Done")
    stats.reportAnalyser("None")
    _results = Some(sortedReport)
    _done = true
    finished.emit()
  }

  var reportEntryChanged: List[Option[ReportEntry] => Any] = Nil

  def changeReportEntry(reportEntry: Option[ReportEntry]) =
    reportEntryChanged.foreach(_(reportEntry))
}
