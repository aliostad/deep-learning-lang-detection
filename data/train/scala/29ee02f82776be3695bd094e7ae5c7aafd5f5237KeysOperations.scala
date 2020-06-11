package com.github.j5ik2o.reactive.redis

import java.time.ZonedDateTime
import java.util.UUID

import com.github.j5ik2o.reactive.redis.CommandResponseParser._
import com.sun.org.apache.xerces.internal.impl.xpath.regex.ParseException

import scala.concurrent.duration.FiniteDuration

object KeysOperations {

  // --- DEL
  object DelRequest extends SimpleResponseFactory {

    override protected val responseParser = integerReply

    override def receive(requestId: UUID) = {
      case (NumberExpr(n), next) =>
        (DelSucceeded(UUID.randomUUID(), requestId, n), next)
      case (SimpleExpr("QUEUED"), next) =>
        (DelSuspended(UUID.randomUUID(), requestId), next)
      case (ErrorExpr(msg), next) =>
        (DelFailed(UUID.randomUUID(), requestId, new Exception(msg)), next)
      case (expr, o) =>
        logger.error("DEL request = {}", expr)
        throw new ParseException("DEL request", o.offset)
    }

  }

  case class DelRequest(id: UUID, key: String) extends SimpleRequest {
    override val responseFactory: SimpleResponseFactory = DelRequest
    override val message: String                        = s"""DEL $key"""
  }

  sealed trait DelResponse extends Response

  case class DelSuspended(id: UUID, requestId: UUID) extends DelResponse

  case class DelSucceeded(id: UUID, requestId: UUID, value: Int) extends DelResponse

  case class DelFailed(id: UUID, requestId: UUID, ex: Exception) extends DelResponse

  // --- DUMP
  object DumpRequest extends SimpleResponseFactory {

    override protected val responseParser = bulkBytesReply

    override def receive(requestId: UUID) = {
      case (BytesExpr(bytes), next) =>
        (DumpSucceeded(UUID.randomUUID(), requestId, bytes), next)
      case (SimpleExpr("QUEUED"), next) =>
        (DumpSuspended(UUID.randomUUID(), requestId), next)
      case (ErrorExpr(msg), next) =>
        (DumpFailed(UUID.randomUUID(), requestId, new Exception(msg)), next)
      case (expr, o) =>
        logger.error("DUMP request = {}", expr)
        throw new ParseException("DUMP request", o.offset)
    }

  }

  case class DumpRequest(id: UUID, key: String) extends SimpleRequest {
    override val responseFactory: SimpleResponseFactory = DumpRequest
    override val message: String                        = s"""DUMP $key"""
  }

  sealed trait DumpResponse extends Response

  case class DumpSuspended(id: UUID, requestId: UUID) extends DumpResponse

  case class DumpSucceeded(id: UUID, requestId: UUID, value: Array[Byte]) extends DumpResponse

  case class DumpFailed(id: UUID, requestId: UUID, ex: Exception) extends DumpResponse

  // --- EXISTS
  object ExistsRequest extends SimpleResponseFactory {

    override protected val responseParser = integerReply

    override def receive(requestId: UUID) = {
      case (NumberExpr(n), next) =>
        (ExistsSucceeded(UUID.randomUUID(), requestId, n == 1), next)
      case (SimpleExpr("QUEUED"), next) =>
        (ExistsSuspended(UUID.randomUUID(), requestId), next)
      case (ErrorExpr(msg), next) =>
        (ExistsFailed(UUID.randomUUID(), requestId, new Exception(msg)), next)
      case (expr, o) =>
        logger.error("DUMP request = {}", expr)
        throw new ParseException("DUMP request", o.offset)
    }

  }

  case class ExistsRequest(id: UUID, key: String) extends SimpleRequest {
    override val responseFactory: SimpleResponseFactory = ExistsRequest
    override val message: String                        = s"""EXISTS $key"""
  }

  sealed trait ExistsResponse extends Response

  case class ExistsSuspended(id: UUID, requestId: UUID) extends ExistsResponse

  case class ExistsSucceeded(id: UUID, requestId: UUID, value: Boolean) extends ExistsResponse

  case class ExistsFailed(id: UUID, requestId: UUID, ex: Exception) extends ExistsResponse

  // --- EXPIRE
  object ExpireRequest extends SimpleResponseFactory {

    override protected val responseParser = integerReply

    override def receive(requestId: UUID) = {
      case (NumberExpr(n), next) =>
        (ExpireSucceeded(UUID.randomUUID(), requestId, n == 1), next)
      case (SimpleExpr("QUEUED"), next) =>
        (ExpireSuspended(UUID.randomUUID(), requestId), next)
      case (ErrorExpr(msg), next) =>
        (ExpireFailed(UUID.randomUUID(), requestId, new Exception(msg)), next)
      case (expr, o) =>
        logger.error("DUMP request = {}", expr)
        throw new ParseException("DUMP request", o.offset)
    }

  }

  case class ExpireRequest(id: UUID, key: String, seconds: FiniteDuration) extends SimpleRequest {
    override val responseFactory: SimpleResponseFactory = ExpireRequest
    override val message: String                        = s"""EXPIRE $key ${seconds.toSeconds}"""
  }

  sealed trait ExpireResponse extends Response

  case class ExpireSuspended(id: UUID, requestId: UUID) extends ExpireResponse

  case class ExpireSucceeded(id: UUID, requestId: UUID, value: Boolean) extends ExpireResponse

  case class ExpireFailed(id: UUID, requestId: UUID, ex: Exception) extends ExpireResponse

  // --- EXPIREAT
  object ExpireAtRequest extends SimpleResponseFactory {

    override protected val responseParser = integerReply

    override def receive(requestId: UUID) = {
      case (NumberExpr(n), next) =>
        (ExpireAtSucceeded(UUID.randomUUID(), requestId, n == 1), next)
      case (SimpleExpr("QUEUED"), next) =>
        (ExpireAtSuspended(UUID.randomUUID(), requestId), next)
      case (ErrorExpr(msg), next) =>
        (ExpireAtFailed(UUID.randomUUID(), requestId, new Exception(msg)), next)
      case (expr, o) =>
        logger.error("DUMP request = {}", expr)
        throw new ParseException("DUMP request", o.offset)
    }

  }

  case class ExpireAtRequest(id: UUID, key: String, expiresAt: ZonedDateTime) extends SimpleRequest {
    override val responseFactory: SimpleResponseFactory = ExpireRequest
    override val message: String                        = s"""EXPIREAT $key ${expiresAt.toEpochSecond}"""
  }

  sealed trait ExpireAtResponse extends Response

  case class ExpireAtSuspended(id: UUID, requestId: UUID) extends ExpireAtResponse

  case class ExpireAtSucceeded(id: UUID, requestId: UUID, value: Boolean) extends ExpireAtResponse

  case class ExpireAtFailed(id: UUID, requestId: UUID, ex: Exception) extends ExpireAtResponse

  // --- KEYS
  // --- MIGRATE
  // --- MOVE
  // --- OBJECT
  // --- PERSIST
  // --- PEXPIRE
  // --- PEXPIREAT
  // --- PTTL
  // --- RANDOMKEY
  // --- RENAME
  // --- RENAMENX
  // --- RESTORE
  // --- SCAN
  // --- SORT
  // --- TTL
  // --- TYPE
  // --- UNLINK

}
