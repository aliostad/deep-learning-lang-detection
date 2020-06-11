package com.nefariouszhen.khronos.db

import java.util.concurrent.ScheduledExecutorService

import com.bazaarvoice.ostrich.dropwizard.healthcheck.CachingHealthCheck
import com.nefariouszhen.khronos.db.index.Mustang
import com.nefariouszhen.khronos.metrics.MetricsRegistry
import com.nefariouszhen.khronos.util.{DropwizardPrivateModule, Executors, ManagedExecutor}
import io.dropwizard.setup.Environment
import net.codingwell.scalaguice.InjectorExtensions._

abstract class DatabaseModule extends DropwizardPrivateModule {
  def doConfigure(): Unit = {
    bind[DatabaseResource].asEagerSingleton()
    bind[DatabaseHealthCheck].asEagerSingleton()
    bind[Mustang].asEagerSingleton()

    val executor = Executors.newScheduledThreadPool("khronos.db", numThreads = 1)
    bind[ScheduledExecutorService].toInstance(executor)

    bind[MetricsRegistry].asEagerSingleton()
    expose[MetricsRegistry]

    bind[Multiplexus].asEagerSingleton()
    expose[Multiplexus]
  }

  def install(env: Environment): Unit = {
    env.healthChecks().register("tsdb", new CachingHealthCheck(injector.instance[DatabaseHealthCheck]))

    env.jersey().register(injector.instance[DatabaseResource])

    env.lifecycle().manage(injector.instance[Mustang])
    env.lifecycle().manage(injector.instance[Multiplexus])
    env.lifecycle().manage(new ManagedExecutor(injector.instance[ScheduledExecutorService]))
  }
}
