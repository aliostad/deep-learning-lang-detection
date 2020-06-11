package com.nvbn.skateability.app

import android.os.{Environment, Bundle}
import android.view.{Menu, MenuItem}
import android.widget.Button
import java.io.{FileOutputStream, File}
import android.util.Log
import org.scaloid.common._
import scala.concurrent.Future
import utils.{HasSettings, Futerable}


class TumblerActivity extends SActivity with Futerable with HasSettings {
  implicit val tag = LoggerTag("TubmlerActivity")

  override def onCreate(savedInstanceState: Bundle) {
    super.onCreate(savedInstanceState)
    setContentView(R.layout.activity_tumbler)
    manageService(settings.serviceRunned(false))
    initBtn()
    updateBtn()
    startService[SyncService]
  }

  def initBtn() = find[Button](R.id.tracking_btn) onClick {
    manageService(!settings.serviceRunned(false))
    updateBtn()
  }

  def manageService(run: Boolean) = {
    if (run)
      startService[DataService]
    else
      stopService[DataService]
    settings.serviceRunned = run
  }

  def updateBtn() = find[Button](R.id.tracking_btn).setText(
    if (settings.serviceRunned(false))
      R.string.stop_tracking
    else
      R.string.start_tracking
  )

  override def onCreateOptionsMenu(menu: Menu) = {
    getMenuInflater.inflate(R.menu.log, menu)
    true
  }

  def saveLog() = Future {
    val file = new File(Environment.getExternalStorageDirectory, "out.csv")
    file.createNewFile()
    info("Log saved")
    val stream = new FileOutputStream(file.getAbsolutePath)
    for (entry <- DataEntry.all)
      stream.write(entry.pretty.toCharArray.map(_.toByte))
    stream.close()
    toast("Log saved!")
  }

  override def onOptionsItemSelected(item: MenuItem) = item.getItemId match {
    case R.id.action_save_log =>
      saveLog()
      true
    case R.id.action_show_log =>
      startActivity[LogActivity]
      true
    case _ => super.onOptionsItemSelected(item)
  }
}
