package ssf

import (
	"fmt"
	"io"
	"net"
	"path/filepath"
	"strings"
	"sync/atomic"
	"time"
	"unsafe"

	"github.com/golang/glog"
	"github.com/golang/protobuf/proto"
)

type ipchannel struct {
	name     string
	ech      chan []byte
	closech  chan int
	unixConn net.Conn
}

func (ic *ipchannel) evloop() {
	for ssfRunning {
		if nil == ic.unixConn {
			time.Sleep(10 * time.Millisecond)
			continue
		}
		select {
		case ev := <-ic.ech:
			if len(ev) > 0 {
				ic.unixConn.Write(ev)
			}
		case _ = <-ic.closech:
			ic.unixConn.Close()
			ic.unixConn = nil
			glog.Infof("Processor:%s disconnect.", ic.name)
		}
	}
}

func (ic *ipchannel) Read(p []byte) (n int, err error) {
	if nil == ic.unixConn {
		return 0, io.EOF
	}
	return ic.unixConn.Read(p)
}

func (ic *ipchannel) Close() error {
	if nil == ic.unixConn || !ssfRunning {
		if nil != ic.unixConn {
			ic.unixConn.Close()
			ic.unixConn = nil
		}
		return nil
	}
	ic.closech <- 1
	return nil
}

func (ic *ipchannel) Write(p []byte) (n int, err error) {
	select {
	case ic.ech <- p:
		return len(p), nil
	default:
		glog.Warningf("Discard msg to processor:%s since it's too slow", ic.name)
		return 0, nil
	}
}

type dispatchTable struct {
	allChannels map[string]*ipchannel
	routeTable  map[string][]*ipchannel
}

var ssfDispatchTable unsafe.Pointer

func init() {
	dis := new(dispatchTable)
	dis.allChannels = make(map[string]*ipchannel)
	dis.routeTable = make(map[string][]*ipchannel)
	atomic.StorePointer(&ssfDispatchTable, unsafe.Pointer(dis))
}

func ps(args []string, wr io.Writer) error {
	for _, ic := range getDispatchTable().allChannels {
		status := "connected"
		if ic.unixConn == nil {
			status = "disconnect"
		}
		fmt.Fprintf(wr, "%s     %s\n", ic.name, status)
	}
	return nil
}

type writeBack struct {
	wr io.Writer
}

func cd(args []string, wr io.Writer) error {
	name := args[0]
	ic := getIPChannelsByName(name)
	if nil == ic || ic.unixConn == nil {
		return ErrNoProcessor
	}
	if rw, ok := wr.(io.ReadWriter); ok {
		fmt.Fprintf(wr, "Enter interactive mode for processor:%s\n", name)
		var adminReq AdminRequest
		adminReq.Line = proto.String("help")
		LocalRPC(name, &adminReq, &writeBack{wr}, 0)
		buf := make([]byte, 1024)
		for {
			n, err := rw.Read(buf)
			if nil != err {
				break
			}
			if n > 1024 {
				fmt.Fprintf(rw, "Too long command from input.\n")
				continue
			}
			adminReq.Line = proto.String(strings.TrimSpace(string(buf[0:n])))
			res, err := LocalRPC(name, &adminReq, &writeBack{wr}, 0)
			if nil != err {
				fmt.Fprintf(wr, "%v\n", err)
				if err == ErrProcessorDisconnect {
					break
				}
				continue
			}
			adminRes, ok := res.(*AdminResponse)
			if !ok {
				fmt.Fprintf(wr, "Invalid response while receive %T\n", res)
				continue
			}
			if adminRes.GetClose() {
				break
			}
		}
	}
	fmt.Fprintf(wr, "Exit interactive mode for processor:%s\n", name)
	return nil
}

func getDispatchTable() *dispatchTable {
	return (*dispatchTable)(atomic.LoadPointer(&ssfDispatchTable))
}
func saveDispatchTable(dis *dispatchTable) {
	atomic.StorePointer(&ssfDispatchTable, unsafe.Pointer(dis))
}

func updateDispatchTable(cfg map[string][]string) {
	newDispatch := new(dispatchTable)
	newDispatch.allChannels = make(map[string]*ipchannel)
	newDispatch.routeTable = make(map[string][]*ipchannel)

	oldDispatch := getDispatchTable()
	for proc, types := range cfg {
		if ic, ok := oldDispatch.allChannels[proc]; ok {
			newDispatch.allChannels[proc] = ic
		} else {
			ic := new(ipchannel)
			ic.name = proc
			ic.ech = make(chan []byte, 100000)
			ic.closech = make(chan int)
			newDispatch.allChannels[proc] = ic
			go ic.evloop()
		}

		for _, t := range types {
			newDispatch.routeTable[t] = append(newDispatch.routeTable[t], newDispatch.allChannels[proc])
		}
	}
	saveDispatchTable(newDispatch)
}

func getIPChannelsByType(msgType string) []*ipchannel {
	ics, ok := getDispatchTable().routeTable[msgType]
	if ok {
		return ics
	}
	return nil
}

func getIPChannelsByName(processor string) *ipchannel {
	ic, ok := getDispatchTable().allChannels[processor]
	if ok {
		return ic
	}
	return nil
}

func addIPChannel(unixConn net.Conn) *ipchannel {
	addr := filepath.Base(unixConn.RemoteAddr().String())
	extension := filepath.Ext(addr)
	proc := addr[0 : len(addr)-len(extension)]
	ic := getIPChannelsByName(proc)
	if nil != ic {
		glog.Infof("Processor:%s connected.", proc)
		ic.unixConn = unixConn
	} else {
		glog.Warningf("No processor:%s defined in IPC disptach table.", proc)
	}
	return ic
}

func dispatch(event *Event) error {
	if len(event.GetTo()) > 0 {
		ic := getIPChannelsByName(event.GetTo())
		if nil == ic {
			return ErrNoProcessor
		}
		return writeEvent(event, ic)
	}
	node := getNodeByHash(event.GetHashCode())
	if nil == node {
		return ErrNoNode
	}
	if isSelfNode(node) {
		ics := getIPChannelsByType(event.GetMsgType())
		if len(ics) == 0 {
			return ErrNoProcessor
		}
		for _, ic := range ics {
			//ic.Write(event.Raw)
			writeEvent(event, ic)
		}
		return nil
	}
	return emitEvent(event)
}

type procIPCEventHandler struct {
}

func (ipc *procIPCEventHandler) OnEvent(event *Event, conn io.ReadWriteCloser) {
	if event.GetType() == EventType_NOTIFY {
		switch event.GetMsgType() {
		case proto.MessageName((*HeartBeat)(nil)):
			var hbres HeartBeat
			hbres.Res = proto.Bool(true)
			notify(&hbres, 0, conn)
		case proto.MessageName((*AdminEvent)(nil)):
			event.decode()
			attach := getSessionAttach(event.GetHashCode())
			if nil != attach {
				attach.(*writeBack).wr.Write([]byte(event.Msg.(*AdminEvent).GetContent()))
			}

		default:
			dispatch(event)
		}
	} else {
		if event.GetTo() != getProcessorName() {
			dispatch(event)
			return
		}
		event.decode()
		if event.GetType() == EventType_RESPONSE {
			triggerClientSessionRes(event.Msg, event.GetHashCode())
		} else {
			//hanlder event
		}
	}
}
