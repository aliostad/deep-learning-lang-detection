package org.musicpimp.http

import com.mle.android.http.{IEndpoint, Protocols}
import play.api.libs.json.Json

/**
 * Use [[Endpoint]].
 *
 * @author mle
 */
case class AlmostOldEndpoint(name: String,
                             host: String,
                             port: Int,
                             username: String,
                             password: String,
                             endpointType: EndpointTypes.EndpointType,
                             ssid: Option[String] = None,
                             autoSync: Boolean = true,
                             protocol: Protocols.Protocol = Protocols.Http) extends IEndpoint {
  def toEndpoint = Endpoint(Endpoint.newID, name, host, port, username, password, endpointType,None, ssid, autoSync, protocol)
}

object AlmostOldEndpoint {

  import Endpoint.{protocolFormat, endTypeFormat}

  implicit val json = Json.format[AlmostOldEndpoint]
}