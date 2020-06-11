package au.id.tmm.ausvotes.api

import javax.servlet.ServletContext

import au.id.tmm.ausvotes.api.servlets.DivisionServlet
import au.id.tmm.ausvotes.backend
import com.google.inject.Guice
import net.codingwell.scalaguice.InjectorExtensions._
import org.scalatra.LifeCycle

class ScalatraBootstrap extends LifeCycle {
  override def init(context: ServletContext): Unit = {
    val injector = Guice.createInjector(new au.id.tmm.ausvotes.backend.Module())

    backend.persistence.ManagePersistence.start()
    // TODO flyway migrate

    context.mount(injector.instance[DivisionServlet], "/division")
  }

  override def destroy(context: ServletContext): Unit = {
    backend.persistence.ManagePersistence.shutdown()
  }
}