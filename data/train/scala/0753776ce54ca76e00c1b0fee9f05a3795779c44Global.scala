import com.tinkerpop.blueprints.impls.orient.OrientGraph
import datasource.ManageDataSource
import play.api._

/**
 * Created by kanhasatya on 8/17/14.
 */
object Global extends GlobalSettings {



  override def onStart(app : Application){

    //val factory = ManageDataSource.instantiate("/home/kanhasatya/runnable/orientdb-community-1.7.7/databases/TrackMyExpenses","local")
    val factory = ManageDataSource.instantiate("localhost/TrackMyExpenses","remote")




    Logger.info("App started")
  }

  override def onStop(app : Application): Unit ={
    ManageDataSource.shutDown
    Logger.info("App shutting down")
  }


}



















