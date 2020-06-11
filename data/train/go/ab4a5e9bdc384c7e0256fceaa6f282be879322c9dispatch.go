package tcpserver

import (
	"fmt"
	"os"
	"time"

	"github.com/garyburd/redigo/redis"
	"github.com/zheng-ji/goSnowFlake"
)

//消息逻辑处理层，存储消息，分发消息，离线消息发送到push
type Dispatch struct {
	iw      *goSnowFlake.IdWorker
	sub     *Subscribe
	outChan chan *Packet
	quit    chan bool
	pool    *redis.Pool
}

//0 < workerId < 1024
func NewDispatch(config *DispatchConfig) *Dispatch {
	iw, err := goSnowFlake.NewIdWorker(config.WorkerId)
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	d := &Dispatch{
		iw:      iw,
		outChan: make(chan *Packet, 1024),
		quit:    make(chan bool),
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
	d.sub = NewSubscribe(&CustomProto{}, config.NsqdHost, MESSAGE_TOPIC_LOGIC, MESSAGE_CHANNEL_LOGIC_IM, d.outChan)

	return d
}

func (d *Dispatch) Run() {
	for {
		select {
		case p := <-d.outChan:
			d.handle(p)
		case <-d.quit:
			return
		}
	}
}

//处理消息分发
func (d *Dispatch) handle(p *Packet) {
	p.Ct = (time.Now().UnixNano() / 1000000) //设置ms时间戳
	switch p.Mt {
	case MESSAGE_TYPE_P2P:
		//单聊
		d.handleP2p(p)
	case MESSAGE_TYPE_GROUP:
		//群消息
		d.handleGroup(p)
	case MESSAGE_TYPE_ROOM:
		//聊天室消息
		d.handleRoom(p)
	default:
		fmt.Printf("unknown message type: %d\n", p.Mt)
	}
}

func (d *Dispatch) isOnline(uid int64) bool {
	conn := d.pool.Get()
	defer conn.Close()

	key := fmt.Sprintf("%s%d", KEY_PREFIX_USER_ONLINE, uid)
	b, _ := redis.Bool(conn.Do("EXISTS", key))
	return b
}

func (d *Dispatch) handleP2p(p *Packet) {
	if id, err := d.iw.NextId(); err != nil {
		fmt.Println(err)
		return
	} else {
		p.Mid = id
	}

	if d.isOnline(p.Rid) {
		d.sub.Publish(MESSAGE_TOPIC_DISPATCH, p)
	} else {
		d.sub.Publish(MESSAGE_TOPIC_OFFLINE, p)
	}
}

func (d *Dispatch) handleGroup(p *Packet) {
	//获取群成员
	members := []int64{}
	for _, member := range members {
		if member == p.Sid {
			continue
		}

		if id, err := d.iw.NextId(); err == nil {
			packet := &Packet{
				Ver: p.Ver,
				Mt:  p.Mt,
				Mid: id,
				Sid: p.Rid,
				Rid: member,
				Ext: p.Ext,
				Pl:  p.Pl,
			}

			if d.isOnline(packet.Rid) {
				d.sub.Publish(MESSAGE_TOPIC_DISPATCH, packet)
			} else {
				d.sub.Publish(MESSAGE_TOPIC_OFFLINE, packet)
			}
		}
	}
}

func (d *Dispatch) handleRoom(p *Packet) {
	//获取聊天室成员
	members := []int64{}
	for _, member := range members {
		if member == p.Sid {
			continue
		}

		if id, err := d.iw.NextId(); err == nil {
			packet := &Packet{
				Ver: p.Ver,
				Mt:  p.Mt,
				Mid: id,
				Sid: p.Rid,
				Rid: member,
				Ext: p.Ext,
				Pl:  p.Pl,
			}

			if d.isOnline(packet.Rid) {
				d.sub.Publish(MESSAGE_TOPIC_DISPATCH, packet)
			} else {
				d.sub.Publish(MESSAGE_TOPIC_OFFLINE, packet)
			}
		}
	}
}

func (d *Dispatch) Close() {
	d.quit <- true
}
