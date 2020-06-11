package sylius

import io.gatling.core.Predef._
import io.gatling.http.Predef._
import sylius.settings._

final object Simulations {
  private def initialiser(settings: Settings) = {
    exec(session => session.set("domain", settings.project.domain))
  }

  def frontendLoadTest(settings: Settings) = {
    scenario(settings.project.name + " Frontend Load Test (" + settings.load.numberOfUsers.toString + " users over " + settings.load.rampingTime.toString + " during " + settings.load.simulationTime.toString + ")")
      .during(settings.load.simulationTime) {
        randomSwitch(
          40d -> exec(initialiser(settings)).exec(Behaviours.browseCatalogAndAbandonCart),
          30d -> exec(initialiser(settings)).exec(Behaviours.browseCatalog),
          20d -> exec(initialiser(settings)).exec(Behaviours.browseAndSearchCatalog),
          10d -> exec(initialiser(settings)).exec(Behaviours.browseCatalogAndCheckoutAsGuest)
        )
      }
  }

  def frontendBrowsingLoadTest(settings: Settings) = {
    scenario(settings.project.name + " Frontend Browsing Load Test (" + settings.load.numberOfUsers.toString + " users over " + settings.load.rampingTime.toString + " during " + settings.load.simulationTime.toString + ")")
      .during(settings.load.simulationTime) {
        randomSwitch(
          70d -> exec(initialiser(settings)).exec(Behaviours.browseCatalog),
          30d -> exec(initialiser(settings)).exec(Behaviours.browseAndSearchCatalog)
        )
      }
  }

  def frontendCheckoutLoadTest(settings: Settings) = {
    scenario(settings.project.name + " Frontend Checkout Load Test (" + settings.load.numberOfUsers.toString + " users over " + settings.load.rampingTime.toString + " during " + settings.load.simulationTime.toString + ")")
      .during(settings.load.simulationTime) {
        exec(initialiser(settings)).exec(Behaviours.checkoutAsGuest)
      }
  }
}
