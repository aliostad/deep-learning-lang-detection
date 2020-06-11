package protocol

import (
	"github.com/funny/link"
	"net"
	"runtime"
	"strings"
	. "tools"
	"tools/codecType"
	"tools/dispatch"
)

var (
	PackCodecType_UnSafe link.CodecType = link.Packet(4, 1024*1024, 4096, link.LittleEndian, codecType.NetCodecType{})
	PackCodecType_Safe   link.CodecType = link.ThreadSafe(PackCodecType_UnSafe)
	PackCodecType_Async  link.CodecType = link.Async(4096, PackCodecType_UnSafe)
)

type TCPHandle interface {
	Handle(net.Conn)
}

func TCPServer(server *link.Server, acceptFunc func(*link.Session), dispatch dispatch.DispatchInterface, proto string) {
	INFO_F("%s: listening on %s", proto, server.Listener().Addr())
	for {
		session, err := server.Accept()
		if err != nil {
			if nerr, ok := err.(net.Error); ok && nerr.Temporary() {
				runtime.Gosched()
				continue
			}

			if !strings.Contains(err.Error(), "use of closed network connection") {
				ERR("listener.Accept() - %s", err)
			}
			break
		}

		go acceptFunc(session)
		if dispatch != nil {
			go SessionReceive(session, dispatch)
		}
	}
	INFO_F("%s: closing on %s", proto, server.Listener().Addr())
}

func SessionReceive(session *link.Session, d dispatch.DispatchInterface) {
	for {
		var msg []byte
		if err := session.Receive(&msg); err != nil {
			break
		}

		d.Process(session, msg)
	}
}
