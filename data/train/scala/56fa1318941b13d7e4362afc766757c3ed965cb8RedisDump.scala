package redis.interchange.hrd

/**
 * Represents dump of redis database.
 * @author <a href="mailto:roman.kashitsyn@gmail.com">Roman Kashitsyn</a>
 */

class RedisDump (entries: List[(RedisKey, Any)]) {
  val values: Map[Any, Any] = Map() ++ entries.map(e => (e._1.key, e._2))
  val expiration: Map[Any, Expiration] = expireKeys.toMap

  private def expireKeys = for {
    entry <- entries
    exp = entry._1.expiration
    if !exp.isEmpty
  } yield (entry._1.key, exp.get)

  def apply(key: Any) = values(key)

  def timeToLive(key: Any) = expiration(key)

  override def toString = {
    def formatKey(e: (RedisKey, Any)): String = {
      e._1.key + ": " + e._2.toString
    }
    "RedisDump[" + entries.map(formatKey).mkString("  ") + "]"
  }

}
