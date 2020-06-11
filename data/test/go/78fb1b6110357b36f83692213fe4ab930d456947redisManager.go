package proxy

import (
	"net"
	"bufio"
	"log"
)

type RedisManager struct {
	server *Server
	rc	[]*redisConn
}

func (manager *RedisManager) add(addr string) {
	rc, err := net.Dial("tcp", addr)
	if err != nil {
		log.Fatal(err)
	}
	redisConn := &redisConn{
		conn: rc,
		server: manager.server,
		br: bufio.NewReader(rc),
		bw: bufio.NewWriter(rc),
	}
	manager.rc = append(manager.rc ,redisConn)
}

func (manager *RedisManager) remove(addr string) {
	for i := 0; i < len(manager.rc); i++ {
		if manager.rc[i].conn.RemoteAddr().String() == addr{
			manager.rc[i].conn.Close()
			manager.rc[i] = nil
			break
		}
	}
}
