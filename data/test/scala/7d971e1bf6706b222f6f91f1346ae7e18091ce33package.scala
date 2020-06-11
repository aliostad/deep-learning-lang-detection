package model

import play.api.libs.json._
import play.api.libs.functional.syntax._

package object swagger {

  implicit val loginEndpointWrite: Writes[LoginEndpoint] = Writes {
    (loginEndpoint: LoginEndpoint) => JsString(loginEndpoint.url)
  }

  implicit val scopeWrites: Writes[Scope] = (
    (JsPath \ "scope").write[String] and
    (JsPath \ "description").write[String])(unlift(Scope.unapply))

  implicit val implicitWrites: Writes[Implicit] = (
    (JsPath \ "loginEndpoint").write[LoginEndpoint] and
    (JsPath \ "tokenName").write[String])(unlift(Implicit.unapply))

  implicit val grantTypesWrites: Writes[GrantTypes] = (
    (JsPath \ "implicit").write[Implicit] and
    (JsPath \ "authorization_code").write[AuthorizationCode])(unlift(GrantTypes.unapply))

  implicit val tokenRequestEndpointWrites: Writes[TokenRequestEndpoint] = (
    (JsPath \ "url").write[String] and
    (JsPath \ "clientName").write[String] and
    (JsPath \ "clientSecretName").write[String])(unlift(TokenRequestEndpoint.unapply))

  implicit val tokenEndpointWrite: Writes[TokenEndpoint] = (
    (JsPath \ "url").write[String] and
    (JsPath \ "tokenName").write[String])(unlift(TokenEndpoint.unapply))

  implicit val authorizationCodeWrites: Writes[AuthorizationCode] = (
    (JsPath \ "tokenRequestEndpoint").write[TokenRequestEndpoint] and
    (JsPath \ "tokenEndpoint").write[TokenEndpoint])(unlift(AuthorizationCode.unapply))

  implicit val authorizationWrites: Writes[Authorization] = (
    (JsPath \ "type").write[String] and
    (JsPath \ "passAs").write[String] and
    (JsPath \ "keyname").write[String] and
    (JsPath \ "scopes").write[Seq[Scope]] and
    (JsPath \ "grantTypes").write[GrantTypes])(unlift(Authorization.unapply))

  implicit val infoWrites: Writes[Info] = (
    (JsPath \ "title").write[String] and
    (JsPath \ "description").write[String] and
    (JsPath \ "termsOfServiceUrl").write[String] and
    (JsPath \ "contact").write[String] and
    (JsPath \ "license").write[String] and
    (JsPath \ "licenseUrl").write[String])(unlift(Info.unapply))

  implicit val resourceWrites: Writes[Resource] = (
    (JsPath \ "path").write[String] and
    (JsPath \ "description").write[String])(unlift(Resource.unapply))

  implicit val resourceListingWrites: Writes[ResourceListing] = (
    (JsPath \ "apiVersion").write[String] and
    (JsPath \ "swaggerVersion").write[String] and
    (JsPath \ "apis").write[Seq[Resource]] and
    (JsPath \ "authorizations").write[Seq[Authorization]] and
    (JsPath \ "info").write[Info])(unlift(ResourceListing.unapply))
}