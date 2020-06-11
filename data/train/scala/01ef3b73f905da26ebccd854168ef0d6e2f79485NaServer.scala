package org.krazykat.ontapi.models.naServer

case class NaServer(
  filer: Filer,
  userCreds: UserCredentials,
  ontapiVersionOpt: Option[OntapiVersion] = Some(OntapiVersion(1,0,false))
)

object NaServer {
  implicit def toNaServer(naServer: NaServer): netapp.manage.NaServer = {
    val ans = new netapp.manage.NaServer(naServer.filer.address)
    naServer.ontapiVersionOpt map { ontapiVersion =>
      ans.setApiVersion(ontapiVersion.major, ontapiVersion.minor)
    }
    ans.setServerType(netapp.manage.NaServer.SERVER_TYPE_FILER)
    ans.setTransportType(
      naServer.filer.isHttps match {
        case true => netapp.manage.NaServer.TRANSPORT_TYPE_HTTPS
        case false => netapp.manage.NaServer.TRANSPORT_TYPE_HTTP
      }    
    )
    ans.setPort(naServer.filer.port)
    ans.setStyle(netapp.manage.NaServer.STYLE_LOGIN_PASSWORD)
    ans.setAdminUser(naServer.userCreds.username, naServer.userCreds.password)
    ans
  }
}