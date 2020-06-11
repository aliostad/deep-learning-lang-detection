package connectionmanager

import (
	"fmt"
	"github.com/xweskingx/ACS560_course_project/xmppserver/accountmanager"
	"github.com/xweskingx/ACS560_course_project/xmppserver/conversationmanager"
	"github.com/xweskingx/ACS560_course_project/xmppserver/logger"
	"github.com/xweskingx/ACS560_course_project/xmppserver/xmpp"
	"os"
	"strconv"
	"strings"
	"sync"
)

var manager *ConnectionManager
var once sync.Once

type ConnectionManager struct {
	Connections map[string]chan<- interface{}
	lock        *sync.Mutex
	log         logger.Logger
}

func getBareJid(jid string) string {
	return strings.Split(jid, "@")[0]
}

func (manager ConnectionManager) getConnection(jid string) (conn chan<- interface{}, err error) {
	if manager.Connections[getBareJid(jid)] != nil {
		conn = manager.Connections[getBareJid(jid)]
	}
	return
}

func (manager ConnectionManager) setConnection(jid string, conn chan<- interface{}) {
	manager.Connections[getBareJid(jid)] = conn
}

/* Inject account management into xmpp library */

func (manager ConnectionManager) RouteRoutine(bus <-chan xmpp.Message) {
	var channel chan<- interface{}
	var ok bool
	cm := conversationmanager.GetConversationManager()
	for {
		message := <-bus
		manager.lock.Lock()
		parsed, _ := message.Data.(*xmpp.ClientMessage)
		cm.AddMessageToSUC(parsed.Body, parsed.From, message.To)
		if channel, ok = manager.Connections[message.To]; ok {
			channel <- message.Data
		}

		manager.lock.Unlock()
	}
}

func (manager ConnectionManager) RouteCustomRoutine(bus <-chan xmpp.CustomMessage) {
	var channel chan<- interface{}
	var ok bool

	for {
		message := <-bus
		manager.lock.Lock()

		if channel, ok = manager.Connections[getBareJid(message.To)]; ok {
			channel <- message.Data
		}

		manager.lock.Unlock()
	}
}

func (manager ConnectionManager) ConnectRoutine(bus <-chan xmpp.Connect) {
	for {
		message := <-bus
		manager.lock.Lock()
		manager.log.Info(fmt.Sprintf("%s connected", message.Jid))
		am := accountmanager.GetAccountManager()
		am.RegisterUser(getBareJid(message.Jid))
		manager.Connections[getBareJid(message.Jid)] = message.Receiver
		manager.lock.Unlock()
		//manager.SendRosterUpdate(message.Jid)
	}
}

func (manager ConnectionManager) DisconnectRoutine(bus <-chan xmpp.Disconnect) {
	am := accountmanager.GetAccountManager()

	for {
		message := <-bus
		manager.lock.Lock()
		manager.log.Info(fmt.Sprintf("%s disconnected", message.Jid))
		am.UnRegisterUser(getBareJid(message.Jid))
		delete(manager.Connections, getBareJid(message.Jid))
		manager.lock.Unlock()
		//manager.SendRosterUpdate(message.Jid)
	}

}

func (manager ConnectionManager) SendRosterUpdate(jid string) {
	am := accountmanager.GetAccountManager()
	manager.log.Debug("Sending out roster for version " + strconv.Itoa(am.RosterVersion))
	roster, _ := am.OnlineRoster(jid)
	for _, j := range roster {
		msg := "<iq id='0' to='" + j + "' type='result'><query xmlns='jabber:iq:roster' ver='" + strconv.Itoa(am.RosterVersion) + "'>"
		for _, k := range roster {
			msg = msg + "<item jid='" + k + "'/>"
		}
		msg = msg + "</query></iq>"
		manager.lock.Lock()
		if channel, ok := manager.Connections[j]; ok {
			channel <- msg
		}
		manager.lock.Unlock()
	}
}

func GetConnectionManager() *ConnectionManager {
	once.Do(func() {
		newlog := logger.Logger{LogLevel: 0, TAG: "ConnectionManager"}
		manager = &ConnectionManager{log: newlog, lock: &sync.Mutex{}, Connections: make(map[string]chan<- interface{})}
		manager.log.Init(os.Stdout)
	})
	return manager
}
