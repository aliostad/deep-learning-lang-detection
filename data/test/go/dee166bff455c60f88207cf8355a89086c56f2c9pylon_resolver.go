package gateway

import (
	"errors"
)

// A mapped list of every Redis command as of 3.2.0.
//
// It's recommended to copy this entire file and write it your own way for a custom resolver, as this is Pylon-specific.
// A regular proxy could get away with a lot less blacklisting.
var Commands = map[string]int{
	"APPEND": Write,
	"AUTH":   Blacklist,

	"BGWRITEAOF": Blacklist,
	"BGSAVE":     Blacklist,
	"BITCOUNT":   Read,
	"BITFIELD":   Write,
	"BITOP":      Write,
	"BITPOS":     Read,
	"BLPOP":      Blacklist,
	"BRPOP":      Blacklist,
	"BRPOPLPUSH": Blacklist,

	"CLIENT":  Blacklist,
	"CLUSTER": Blacklist,
	"COMMAND": Blacklist,
	"CONFIG":  Blacklist,

	"DBSIZE":  Blacklist,
	"DEBUG":   Blacklist,
	"DECR":    Write,
	"DECRBY":  Write,
	"DEL":     Write,
	"DISCARD": Blacklist,
	"DUMP":    Read,

	"ECHO":     Read,
	"EVAL":     Blacklist,
	"EVALSHA":  Blacklist,
	"EXEC":     Blacklist,
	"EXISTS":   Read,
	"EXPIRE":   Write,
	"EXPIREAT": Write,

	"FLUSHALL": Blacklist,
	"FLUSHDB":  Blacklist,

	"GEOADD":            Write,
	"GEOHASH":           Read,
	"GEOPOS":            Read,
	"GEODIST":           Read,
	"GEORADIUS":         Read,
	"GEORADIUSBYMEMBER": Read,
	"GET":               Read,
	"GETBIT":            Read,
	"GETRANGE":          Read,
	"GETSET":            Blacklist,

	"HDEL":         Write,
	"HEXISTS":      Read,
	"HGET":         Read,
	"HGETALL":      Read,
	"HINCRBY":      Write,
	"HINCRBYFLOAT": Write,
	"HKEYS":        Read,
	"HLEN":         Read,
	"HMGET":        Read,
	"HMSET":        Write,
	"HSCAN":        Read,
	"HSET":         Write,
	"HSETNX":       Write,
	"HSTRLEN":      Read,
	"HVALS":        Read,

	"INCR":        Write,
	"INCRBY":      Write,
	"INCRBYFLOAT": Write,
	"INFO":        Blacklist,

	"KEYS": Read,

	"LASTSAVE": Blacklist,
	"LINDEX":   Read,
	"LINSERT":  Write,
	"LLEN":     Read,
	"LPOP":     Write,
	"LPUSH":    Write,
	"LPUSHX":   Write,
	"LRANGE":   Read,
	"LREM":     Write,
	"LSET":     Write,
	"LTRIM":    Write,

	"MGET":    Read,
	"MIGRATE": Blacklist,
	"MONITOR": Blacklist,
	"MOVE":    Blacklist,
	"MSET":    Write,
	"MSETNX":  Write,
	"MULTI":   Blacklist,

	"OBJECT": Blacklist,

	"PERSIST":      Write,
	"PEXPIRE":      Write,
	"PEXPIREAT":    Write,
	"PFADD":        Write,
	"PFCOUNT":      Read,
	"PFMERGE":      Write,
	"PING":         Read,
	"PSETEX":       Write,
	"PSUBSCRIBE":   Blacklist,
	"PUBSUB":       Blacklist,
	"PTTL":         Read,
	"PUBLISH":      Blacklist,
	"PUNSUBSCRIBE": Blacklist,
	"PYLON":        Internal,

	"QUIT": Silenced,

	"RANDOMKEY": Read,
	"READONLY":  Blacklist,
	"READWRITE": Blacklist,
	"RENAME":    Write,
	"RENAMENX":  Write,
	"RESTORE":   Write,
	"ROLE":      Blacklist,
	"RPOP":      Write,
	"RPOPLPUSH": Write,
	"RPUSH":     Write,
	"RPUSHX":    Write,

	"SADD":        Write,
	"SAVE":        Blacklist,
	"SCAN":        Read,
	"SCARD":       Read,
	"SCRIPT":      Blacklist,
	"SDIFF":       Read,
	"SDIFFSTORE":  Write,
	"SELECT":      Silenced,
	"SET":         Write,
	"SETBIT":      Write,
	"SETEX":       Write,
	"SETNX":       Write,
	"SETRANGE":    Write,
	"SHUTDOWN":    Blacklist,
	"SINTER":      Read,
	"SINTERSTORE": Write,
	"SISMEMBER":   Read,
	"SLAVEOF":     Blacklist,
	"SLOWLOG":     Blacklist,
	"SMEMBERS":    Read,
	"SMOVE":       Write,
	"SORT":        Read,
	"SPOP":        Write,
	"SRANDMEMBER": Read,
	"SREM":        Write,
	"SSCAN":       Read,
	"STRLEN":      Read,
	"SUBSCRIBE":   Blacklist,
	"SUNION":      Read,
	"SUNIONSTORE": Write,
	"SYNC":        Blacklist,

	"TIME": Read,
	"TTL":  Read,
	"TYPE": Read,

	"UNSUBSCRIBE": Blacklist,
	"UNWATCH":     Blacklist,

	"WAIT":  Blacklist,
	"WATCH": Blacklist,

	"ZADD":             Write,
	"ZCARD":            Read,
	"ZCOUNT":           Read,
	"ZINCRBY":          Write,
	"ZINTERSTORE":      Write,
	"ZLEXCOUNT":        Read,
	"ZRANGE":           Read,
	"ZRANGEBYLEX":      Read,
	"ZRANGEBYSCORE":    Read,
	"ZRANK":            Read,
	"ZREM":             Write,
	"ZREMRANGEBYLEX":   Write,
	"ZREMRANGEBYRANK":  Write,
	"ZREMRANGEBYSCORE": Write,
	"ZREVRANGE":        Read,
	"ZREVRANGEBYSCORE": Read,
	"ZREVRANGEBYLEX":   Read,
	"ZREVRANK":         Read,
	"ZSCAN":            Read,
	"ZSCORE":           Read,
	"ZUNIONSTORE":      Write,
}

// Default resolver for regular reads and writes.
func PylonRWResolver(cmd string) (int, error) {

	i, ok := Commands[cmd]

	if !ok {
		return Unknown, ErrBadCmd
	}

	if i == Blacklist {
		return i, ErrBlacklisted
	}

	if i == Silenced {
		return i, errors.New("OK")
	}

	return i, nil

}
