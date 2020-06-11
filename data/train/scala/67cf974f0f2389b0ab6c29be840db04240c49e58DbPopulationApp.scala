package au.id.tmm.ausvotes.backend.persistence.population

import au.id.tmm.ausvotes.backend.Module
import au.id.tmm.ausvotes.backend.persistence.ManagePersistence
import au.id.tmm.ausvotes.core.model.SenateElection
import au.id.tmm.utilities.concurrent.FutureUtils.await
import com.google.inject.{Guice, Injector}
import net.codingwell.scalaguice.InjectorExtensions._

object DbPopulationApp {
  def main(args: Array[String]): Unit = {
    val injector = Guice.createInjector(new Module())

    try {
      ManagePersistence.start()
      ManagePersistence.migrateSchema()

      doPopulation(injector)
    } finally {
      ManagePersistence.shutdown()
    }
  }

  private def doPopulation(injector: Injector): Unit = {
    val dbPopulator = injector.instance[DbPopulator]

    await(dbPopulator.populateAsRequired(SenateElection.`2016`))
  }
}
