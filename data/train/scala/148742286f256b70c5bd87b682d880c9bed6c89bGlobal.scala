

import my.finder.console.actor.MessageFacade
import my.finder.console.service.{DBMssql, DBMysql, InitJob, IndexManage}

import org.quartz.impl.StdSchedulerFactory
import org.quartz.Scheduler
import play.api._

/**
 *
 */
object Global extends GlobalSettings {

  private var scheduler: Scheduler = null

  override def onStart(app: Application) {
    synchronized {
      IndexManage.init
      DBMysql.init
      DBMssql.init
    }
    scheduler = StdSchedulerFactory.getDefaultScheduler
    scheduler.start()
    InitJob.init(scheduler)
  }

  override def onStop(app: Application) {
    synchronized {
      MessageFacade.shutdown()
      if (scheduler != null) {
        scheduler.shutdown()
      }
    }
  }


}
