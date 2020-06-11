package org.gafis



import gafis.internal.elasticsearch.InputDataServiceImpl
import gafis.service.elasticsearch.InputDataService
import org.apache.tapestry5.ioc.{Registry, RegistryBuilder, ServiceBinder}
import org.gafis.internal.elasticsearch.{DataAccessServiceImpl, ManageIndexServiceImpl}
import org.gafis.service.elasticsearch.{DataAccessService, ManageIndexService}
import org.gafis.utils.Constant
import org.junit.Before

import scala.reflect.{ClassTag, classTag}

/**
  * Created by yuchen on 2017/8/20.
  */
class BaseTestCase {
  private var registry:Registry = _
  protected def getService[T:ClassTag]:T={
    registry.getService(classTag[T].runtimeClass.asInstanceOf[Class[T]])
  }
  @Before
  def setup: Unit ={
    Constant.getWebConfig
    val modules = Seq[String](
      //"stark.activerecord.StarkActiveRecordModule",
      "org.gafis.DataSourceModule",
      "org.gafis.TestModule"
      //"stark.webservice.StarkWebServiceModule"
    ).map(Class.forName)
    registry = RegistryBuilder.buildAndStartupRegistry(modules: _*)
  }


}

object TestModule{

  def bind(binder: ServiceBinder): Unit = {
    binder.bind(classOf[DataAccessService],classOf[DataAccessServiceImpl])
    binder.bind(classOf[ManageIndexService],classOf[ManageIndexServiceImpl])
    binder.bind(classOf[InputDataService],classOf[InputDataServiceImpl])
  }

}
