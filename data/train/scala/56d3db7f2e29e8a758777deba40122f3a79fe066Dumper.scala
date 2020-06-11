package redis.interchange.hrd

import redis.clients.util.SafeEncoder
import collection.SortedSet
import redis.clients.jedis.{Pipeline, JedisPool, Jedis}

/**
 * @author Roman Kashitsyn
 */

class Dumper(val host: String = "localhost", val port: Int = 6379) {

  def importAll(dump: String) {
    val parser = new HrdParser
    val dmp = parser.parseAll(parser.dump, dump)
    dmp match {
      case parser.Success(_, _) => dumpToRedis(dmp.get)
      case parser.Error(msg, _) => throw new RuntimeException("Invalid redis HRD: " + msg)
    }
  }

  private def dumpToRedis(dump: RedisDump) {
    val jedis = new Jedis(host, port)
    dump.values.foreach(dumpEntry(jedis, _))
    dump.expiration.foreach(dumpExpiration(jedis, _))
    jedis.disconnect()
  }

  private def dumpEntry(jedis: Jedis, e: (Any, Any)) {
    val (k, v) = e
    val key = toBytes(k)
    withPipeline(jedis) { pipeline =>
        v match {
          case l: List[Any] => l.foreach(v => pipeline.lpush(key, toBytes(v)))
          case m: Map[Any, Any] => m.foreach(tuple => pipeline.hset(key, toBytes(tuple._1), toBytes(tuple._2)))
          case s: SortedSet[(Double, Any)] => s.foreach(e => pipeline.zadd(key, e._1, toBytes(e._2)))
          case s: Set[Any] => s.foreach(e => pipeline.sadd(key, toBytes(e)))
          case v: Any => pipeline.set(key, toBytes(v))
        }
    }

  }

  private def toBytes(obj: Any): Array[Byte] = obj match {
    case bytes: Array[Byte] => bytes
    case number: Double => SafeEncoder.encode(number.toString)
    case string: String => SafeEncoder.encode(string)
  }

  private def dumpExpiration(jedis: Jedis, e: (Any, Expiration)) {
    val (k, v) = e
    val key = toBytes(k)
    withPipeline(jedis) { pipeline =>
      v match {
        case ts: UnixTimestamp => pipeline.expireAt(key, ts.timestamp)
        case ts: ExpirationTimeSpan => pipeline.expire(key, ts.timeSpan.seconds.toInt)
      }
    }
  }

  private def withPipeline[A](jedis: Jedis)(func: Pipeline => A): A = {
    val pipe = jedis.pipelined()
    val res = func(pipe)
    pipe.sync()
    res
  }
}
