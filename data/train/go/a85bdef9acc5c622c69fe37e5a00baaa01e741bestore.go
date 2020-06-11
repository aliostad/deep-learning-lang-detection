package tcpserver

import (
	"fmt"
	"time"

	"github.com/garyburd/redigo/redis"
)

var (
	KEY_PREFIX_USER_OFFLINE_MSGS  = "user#offline#msgs#"
	KEY_PREFIX_GROUP_OFFLINE_MSGS = "group#offline#msgs#"
)

//存储消息服务
type StoreSrv struct {
	dispatchSub  *Subscribe
	offlineSub   *Subscribe
	dispatchChan chan *Packet
	offlineChan  chan *Packet
	quit         chan bool
	message      *MysqlMessage
	pool         *redis.Pool
}

func NewStoreSrv(config *StoreConfig) *StoreSrv {
	ps := &StoreSrv{
		dispatchChan: make(chan *Packet, 1024),
		offlineChan:  make(chan *Packet, 1024),
		quit:         make(chan bool),
		pool: &redis.Pool{
			MaxIdle:     5,
			IdleTimeout: 300 * time.Second,
			// Other pool configuration not shown in this example.
			Dial: func() (redis.Conn, error) {
				c, err := redis.Dial("tcp", config.RedisHost)
				if err != nil {
					return nil, err
				}
				if _, err := c.Do("AUTH", config.RedisPwd); err != nil {
					c.Close()
					return nil, err
				}
				if _, err := c.Do("SELECT", config.RedisDb); err != nil {
					c.Close()
					return nil, err
				}
				return c, nil
			},
		},
	}

	ps.dispatchSub = NewSubscribe(&CustomProto{}, config.NsqdHost, MESSAGE_TOPIC_DISPATCH, MESSAGE_CHANNEL_DISPATCH_STORE, ps.dispatchChan)
	ps.offlineSub = NewSubscribe(&CustomProto{}, config.NsqdHost, MESSAGE_TOPIC_OFFLINE, MESSAGE_CHANNEL_OFFLINE_STORE, ps.offlineChan)
	ps.message = NewMysqlMessage(config.DbHost, config.DbUser, config.DbPwd, config.DbName, config.DbCharset)

	return ps
}

func (ss *StoreSrv) Run() {
	conn := ss.pool.Get()
	defer conn.Close()

	proto := &CustomProto{}

	for {
		select {
		case p := <-ss.dispatchChan:
			ss.message.Save(p)
		case p := <-ss.offlineChan:
			ss.message.Save(p)
			switch p.Mt {
			case MESSAGE_TYPE_P2P:
				//单聊
				//点对点缓存到redis list， 保留最近200条聊天记录
				key := fmt.Sprintf("%s%d", KEY_PREFIX_USER_OFFLINE_MSGS, p.Rid)
				conn.Do("RPUSH", key, proto.Serialize(p))
				conn.Do("LTRIM", key, 0, 200)
			case MESSAGE_TYPE_GROUP:
				//群消息
				//群消息缓存到redis list， 保留最近500条聊天记录
				key := fmt.Sprintf("%s%d", KEY_PREFIX_GROUP_OFFLINE_MSGS, p.Rid)
				conn.Do("RPUSH", key, proto.Serialize(p))
				conn.Do("LTRIM", key, 0, 500)
			case MESSAGE_TYPE_ROOM:
				//聊天室消息
				//聊天室不提供离线功能
			default:
				fmt.Printf("unknown message type: %d\n", p.Mt)
			}
		case <-ss.quit:
			return
		}
	}
}

func (ss *StoreSrv) Close() {
	ss.quit <- true
	ss.message.Close()
}
