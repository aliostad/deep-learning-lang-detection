package org.musicpimp.http

import com.mle.android.http.Protocols
import play.api.libs.json.Json

/**
 *
 * @author mle
 */
/**
 * Legacy endpoint maintained so that we can parse old JSON, `toEndpoint`
 * then converts to the new format.
 */
case class OldEndpoint(name: String,
                       host: String,
                       port: Int,
                       username: String,
                       password: String,
                       endpointType: EndpointTypes.EndpointType,
                       protocol: Protocols.Protocol = Protocols.Http) {
  def toEndpoint = Endpoint(Endpoint.newID, name, host, port, username, password, endpointType, protocol = protocol)
}

object OldEndpoint {
  // needed for JSON formats

  import Endpoint.protocolFormat
  import Endpoint.endTypeFormat

  implicit val oldEndpointFormat = Json.format[OldEndpoint]
}
