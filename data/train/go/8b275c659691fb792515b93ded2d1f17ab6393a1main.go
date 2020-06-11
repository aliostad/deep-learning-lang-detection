package main

import (
	"math/rand"
	"time"
	"os"
	"log"
)

func main() {

	rand.Seed(int64(time.Now().Nanosecond()))

	manager := NewEventManager()

	backlog := 25

	datastore := NewDataStore("cobweb.conf", backlog)
	id := manager.AddProcessor(datastore)
	manager.Subscribe(id, "AddNode")
	//manager.Subscribe(id, "SetAlias")
	manager.Subscribe(id, "CheckIfKnown")
	manager.Subscribe(id, "GetNodeList")
	manager.Subscribe(id, "DeleteNode")
	manager.Subscribe(id, "GetPort")
	manager.Subscribe(id, "GetFrontendPort")
	manager.Subscribe(id, "GetNode")
	manager.Subscribe(id, "SavePortMapping")
	manager.Subscribe(id, "LoadPortMapping")

	aliassystem := NewAliasSystem(backlog)
	id = manager.AddProcessor(aliassystem)
	manager.Subscribe(id,"GetAlias")
	manager.Subscribe(id,"SetAlias")
	manager.Subscribe(id,"GetAliasList")
	manager.Subscribe(id,"DelAlias")
	manager.Subscribe(id,"GetAliasFromId")
	manager.Subscribe(id,"GetIdFromAlias")


	connAcceptor := NewConnectionAcceptor(backlog)
	id = manager.AddProcessor(connAcceptor)
	manager.Subscribe(id, "GetTlsConfig")
	manager.Subscribe(id, "GetGlobalID")
	//produces NewAdminConnection NewUnauthenticatedConnection


	adminHandler := NewAdminHandler(backlog)
	id = manager.AddProcessor(adminHandler)
	manager.Subscribe(id, "NewAdminConnection")
	// produces AddNode DeleteNode GetNodeList

	connauthenticator := NewConnectionAuthenticator(backlog)
	id = manager.AddProcessor(connauthenticator)
	manager.Subscribe(id, "NewUnauthenticatedConnection")
	// produces NewAuthenticatedConnection

	requestdispatcher := NewRequestDispatcher(backlog)
	id = manager.AddProcessor(requestdispatcher)
	manager.Subscribe(id, "NewAuthenticatedConnection")
	// produces UpdateRequest ConnectRequest

	updatemanager := NewUpdateManager(backlog)
	id = manager.AddProcessor(updatemanager)
	manager.Subscribe(id, "UpdateRequest")
	manager.Subscribe(id, "AnnounceOffline")
	manager.Subscribe(id, "GetBestNextNodeID")
	manager.Subscribe(id, "CheckIfReachable")
	manager.Subscribe(id, "GetListOfOnlineNodes")
	manager.Subscribe(id, "GetListOfOnlineNodes2")

	connecthandler := NewConnectHandler(backlog)
	id = manager.AddProcessor(connecthandler)
	manager.Subscribe(id, "ConnectRequest")

	forwarder := NewForwarder(backlog)
	id = manager.AddProcessor(forwarder)
	manager.Subscribe(id, "ConnectForwardRequest")
	manager.Subscribe(id, "InitialConnectRequest")

	localconnectauthenticator := NewLocalConnectAuthenticator(backlog)
	id = manager.AddProcessor(localconnectauthenticator)
	manager.Subscribe(id, "ConnectLocalRequest")

	echoserver := NewEchoServer(backlog)
	id = manager.AddProcessor(echoserver)
	manager.Subscribe(id, "EchoServerRequest")

	portmapper := NewPortMapper(backlog)
	id = manager.AddProcessor(portmapper)
	manager.Subscribe(id,"AddPortMapEntry")
	manager.Subscribe(id,"DelPortMapEntry")
	manager.Subscribe(id,"GetPortMapEntry")
	manager.Subscribe(id,"GetPortMap")
	
	conndispatcher := NewLocalConnectionDispatcher(backlog)
	id = manager.AddProcessor(conndispatcher)
	manager.Subscribe(id,"AuthenticatedLocalClient")
	
	maildb := NewMailDB(backlog)
	id = manager.AddProcessor(maildb)
	manager.Subscribe(id,"SaveMail")
	manager.Subscribe(id,"GetMailList")
	manager.Subscribe(id,"GetMail")
	manager.Subscribe(id,"DeleteMail")
	
	acl := NewAccessControlList(backlog)
	id = manager.AddProcessor(acl)
	manager.Subscribe(id,"AddToACL")
	manager.Subscribe(id,"DelFromACL")
	manager.Subscribe(id,"GetACL")
	manager.Subscribe(id,"SetPolicy")
	manager.Subscribe(id,"GetPolicy")
	manager.Subscribe(id,"GetAccess")
	
	mailserver := NewMailServer(backlog)
	id = manager.AddProcessor(mailserver)
	manager.Subscribe(id,"MailServerRequest")
	
	fileserver := NewFileServer(backlog)
	id = manager.AddProcessor(fileserver)
	manager.Subscribe(id,"FileServerRequest")
	
	pchan := make(chan int)
	datastore.PushEvent(NewEvent("GetFrontendPort",pchan))
	
	frontend := NewWebFrontend(backlog,<-pchan)
	_ = manager.AddProcessor(frontend)
	
	
	//Write own id to file
	ret := make(chan string)
	connAcceptor.PushEvent(NewEvent("GetGlobalID",ret))
	file,_ := os.Create("myid.txt")
	file.Write([]byte(<-ret))
	file.Close()	
	log.Print("Wrote own id to file")
	<- make(chan int) //run forever
}
