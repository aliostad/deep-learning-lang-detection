package peerManager

import (
	//"testing"
	//"hyperchain/consensus/testEnv/eventManager"
	//"hyperchain/consensus/testEnv/connectInit"
	//"golang.org/x/net/context"
)

//
//func TestCC(t *testing.T){
//	manager:=eventManager.NewManagerImpl()
//
//	manager.RegistReceiver(eventManager.ConsensusMsgEventConst,&TestReceiver{})
//	manager.Start()
//
//	server:=NewServer(":2333",manager)
//	go server.Start()
//
//	con,_:=GetConnectionWithAddr("127.0.0.1:2333")
//	client:=GetClientWithConn(con)
//	client.Chat(context.Background(),&connectInit.Message{})
//}