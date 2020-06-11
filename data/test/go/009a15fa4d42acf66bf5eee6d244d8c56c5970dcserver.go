package s

import (
	_ "fmt"
	"net"
)

type ServerContext interface {
	Get() *ReqInts
	Reply(*ReplyInts)
}

type Dispatcher interface {
	Do(ServerContext)
}

type Server interface {
	Bind(addr string, dispatch Dispatcher)
	Run()
}

func NewServer() Server {
	return new(server)
}

type server struct {
	addr     string
	dispatch Dispatcher
}

func (s *server) Bind(addr string, dispatch Dispatcher) {
	s.addr = addr
	s.dispatch = dispatch
}

func (s *server) Run() {
	if len(s.addr) == 0 || s.dispatch == nil {
		panic("bind nothing")
	}

	go s.run()
}

func (s *server) run() {
	addr, err := net.ResolveUDPAddr("udp", s.addr)
	if err != nil {
		panic(err)
	}

	conn, err := net.ListenUDP("udp", addr)
	if err != nil {
		panic(err)
	}

	defer conn.Close()
	for {
		buf := make([]byte, 64*1024)
		n, remote, err := conn.ReadFromUDP(buf)
		if err != nil {
			if e, ok := err.(net.Error); ok && e.Timeout() {
				continue
			}

			break
		}

		req, err := ParseReqInts(buf[:n])
		if err == nil {
			context := &serverContext{req, remote, conn}
			go s.dispatch.Do(context)
		}
	}
}

type serverContext struct {
	req    *ReqInts
	remote *net.UDPAddr
	conn   *net.UDPConn
}

func (c *serverContext) Get() *ReqInts {
	return c.req
}

func (c *serverContext) Reply(reply *ReplyInts) {
	buf := reply.Bytes()
	c.conn.WriteToUDP(buf, c.remote)
}
