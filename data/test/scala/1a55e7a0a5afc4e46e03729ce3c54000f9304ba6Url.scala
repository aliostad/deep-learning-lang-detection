package models

import java.net.URL

import akka.util.ByteString
import redis.ByteStringFormatter

/**
 *  Here's our little case class that we use to store in redis.
  *  The key is our "short" url and the value is the actual URL.
  *  Note that Redis requires byteStrings so I have an implicit
  *  serializer to manage the conversions
 *
 */

object Url {
  implicit val byteStringFormatter = new ByteStringFormatter[URL] {
    def serialize(data: URL): ByteString = {
      ByteString(data.toString)
    }
    def deserialize(bs: ByteString): URL = {
      new URL(bs.utf8String)
    }
  }

}

case class Url(short: String, orig: URL)