package com.sap.cloud.yaas.wishlist.security

import com.sap.cloud.yaas.servicesdk.patternsupport.traits.YaasAwareTrait
import com.sap.cloud.yaas.wishlist.context.YaasRequest
import play.api.mvc._

import scala.concurrent.Future


/**
  * Enforces necessity of wishlist_view scope if used in the desired endpoint
  */
object ViewActionFilter extends ActionFilter[YaasRequest] {

  def filter[A](input: YaasRequest[A]): Future[Option[Result]] = Future.successful {
    val scope = input.headers.get(YaasAwareTrait.Headers.SCOPES)
    if (scope.contains(Scopes.VIEW_SCOPE)
      || scope.contains(Scopes.MANAGE_SCOPE)) {
      None
    } else {
      throw new ForbiddenException(scope, Seq(Scopes.VIEW_SCOPE, Scopes.MANAGE_SCOPE))
    }
  }

}
