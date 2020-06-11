package net.kemuridama.kafcon.route

import akka.http.scaladsl.model.StatusCodes

import net.kemuridama.kafcon.model.APIResponse
import net.kemuridama.kafcon.service.{UsesBrokerMetricsService, MixinBrokerMetricsService}
import net.kemuridama.kafcon.protocol.{BrokerMetricsJsonProtocol, CombinedBrokerMetricsJsonProtocol}

trait BrokerMetricsAPIRoute
  extends APIRoute
  with UsesBrokerMetricsService
  with BrokerMetricsJsonProtocol
  with CombinedBrokerMetricsJsonProtocol {

  val route = pathPrefix("clusters" / IntNumber / "brokers") { clusterId =>
    pathPrefix("metrics") {
      pathEnd {
        get {
          onSuccess(brokerMetricsService.findByClusterId(clusterId)) { response =>
            complete(APIResponse(Some(response)))
          }
        }
      }
    } ~
    path(IntNumber / "metrics") { id =>
      get {
        onSuccess(brokerMetricsService.findByBrokerId(clusterId, id)) {
          case Some(response) => complete(APIResponse(Some(response)))
          case _ => complete(StatusCodes.NotFound, errorMessage("Not found"))
        }
      }
    }
  }

}

private[route] object BrokerMetricsAPIRoute
  extends BrokerMetricsAPIRoute
  with MixinBrokerMetricsService

trait UsesBrokerMetricsAPIRoute {
  val brokerMetricsAPIRoute: BrokerMetricsAPIRoute
}

trait MixinBrokerMetricsAPIRoute {
  val brokerMetricsAPIRoute = BrokerMetricsAPIRoute
}
