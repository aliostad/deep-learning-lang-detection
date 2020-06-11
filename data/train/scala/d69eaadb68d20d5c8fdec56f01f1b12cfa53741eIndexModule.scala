package com.nefariouszhen.hackathon.index

import com.nefariouszhen.hackathon.util.DropwizardPrivateModule
import net.codingwell.scalaguice.InjectorExtensions._
import com.yammer.dropwizard.config.Environment

class IndexModule extends DropwizardPrivateModule {
  def doConfigure(): Unit = {
    bind[Index].asEagerSingleton()

    bind[IndexResource].asEagerSingleton()
  }

  def install(env: Environment): Unit = {
    env.manage(injector.instance[Index])

    env.addResource(injector.instance[IndexResource])
  }
}
