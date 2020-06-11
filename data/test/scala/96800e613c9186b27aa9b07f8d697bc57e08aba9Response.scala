package com.isaacloud.sdk.utils

import com.isaacloud.sdk.errors._
import org.apache.http.client.methods.CloseableHttpResponse
import org.json4s.jackson.JsonMethods._

import scala.util.{Success, Try}

private[sdk] case class Response(body: String, response: CloseableHttpResponse) {

  def status: Int = response.getStatusLine.getStatusCode

  def paginator = response.getHeaders("Paginator").headOption

  def checkResponse() = if (status >= 300) errorManage

  def headers: Map[String, Any] = response.getAllHeaders.map(h => (h.getName, h.getValue)).toMap

  private def errorManage = {
    val error = Try(parse(body)) match {
      case Success(o) => o
      case _ => parse( s"""{"code": $status }""")
    }

    status match {
      case 502 => throw BadGateWayError(error)
      case 500 => throw ServerError(error)
      case 400 => throw BadRequestError(error)
      case 401 => throw UnauthorizedError(error)
      case 403 => throw AuthenticationError(error)
      case 404 => throw NotFoundError(error)
      case 408 => throw TimeoutError(error)
      case 409 => throw ConflictError(error)
      case _ =>   throw OtherConnectionError(error)
    }
  }
}