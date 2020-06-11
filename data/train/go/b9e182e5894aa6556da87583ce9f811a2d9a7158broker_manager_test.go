package main

import (
	log "github.com/Sirupsen/logrus"
	"github.com/gtfierro/cs262-project/common"
	"github.com/stretchr/testify/require"
	"net"
	"testing"
	"time"
)

func TestBrokerDeath(t *testing.T) {
	log.Debug("Starting test TestBrokerDeath")
	assert := require.New(t)

	deathChan := make(chan *common.UUID, 5)
	liveChan := make(chan *common.UUID, 5)
	brokerDeath := make(chan bool, 4)
	clock := common.NewFakeClock(time.Now())

	expectMsg1 := make(chan common.Sendable, 5)
	expectMsg2 := make(chan common.Sendable, 5)
	expectMsg2a := make(chan common.Sendable, 5)
	expectMsg3 := make(chan common.Sendable, 5)
	respMsg1 := make(chan common.Sendable, 5)
	respMsg2 := make(chan common.Sendable, 5)
	respMsg2a := make(chan common.Sendable, 5)
	respMsg3 := make(chan common.Sendable, 5)

	tcpAddr, _ := net.ResolveTCPAddr("tcp", "127.0.0.1:56000")
	listener, _ := net.ListenTCP("tcp", tcpAddr)
	go fakeBroker(tcpAddr, expectMsg1, respMsg1, brokerDeath)
	conn1, _ := listener.AcceptTCP()
	uuid1 := common.UUID("1")
	broker1 := common.BrokerInfo{BrokerID: uuid1, ClientBrokerAddr: "0.0.0.0:1001", CoordBrokerAddr: "0.0.0.0:0001"}

	go fakeBroker(tcpAddr, expectMsg2, respMsg2, brokerDeath)
	conn2, _ := listener.AcceptTCP()
	uuid2 := common.UUID("2")
	broker2 := common.BrokerInfo{BrokerID: uuid2, ClientBrokerAddr: "0.0.0.0:1002", CoordBrokerAddr: "0.0.0.0:0002"}

	go fakeBroker(tcpAddr, expectMsg3, respMsg3, brokerDeath)
	conn3, _ := listener.AcceptTCP()
	uuid3 := common.UUID("3")
	broker3 := common.BrokerInfo{BrokerID: uuid3, ClientBrokerAddr: "0.0.0.0:1003", CoordBrokerAddr: "0.0.0.0:0003"}

	bm := NewBrokerManager(new(DummyEtcdManager), 10*time.Second, deathChan, liveChan, nil, nil, clock)

	defer func() {
		bm.TerminateBroker(uuid1)
		bm.TerminateBroker(uuid2)
		bm.TerminateBroker(uuid3)
		listener.Close()
		time.Sleep(50 * time.Millisecond) // Brief pause to let TCP close
	}()

	bm.ConnectBroker(&broker1, NewPassthroughCommConn(conn1))
	bm.ConnectBroker(&broker2, NewPassthroughCommConn(conn2))
	bm.ConnectBroker(&broker3, NewPassthroughCommConn(conn3))

	for i := 0; i < 3; i++ {
		<-liveChan // Clear out the old live channel
	}

	time.Sleep(50 * time.Millisecond) // Give time for heartbeat threads to get current time

	clock.AdvanceNowTime(22 * time.Second) // Force to send out heartbeat requests
	respMsg1 <- new(common.HeartbeatMessage)
	assert.IsType(new(common.RequestHeartbeatMessage), <-expectMsg1)
	respMsg3 <- new(common.HeartbeatMessage)
	assert.IsType(new(common.RequestHeartbeatMessage), <-expectMsg3)

	time.Sleep(50 * time.Millisecond) // Give time for heartbeat threads to get current time

	clock.AdvanceNowTime(12 * time.Second) // Second broker should be considered dead
	assert.Equal(&uuid2, <-deathChan)

	assert.Equal(uuid1, bm.GetLiveBroker().BrokerID)
	assert.Equal(uuid3, bm.GetLiveBroker().BrokerID)

	assert.False(bm.IsBrokerAlive(uuid2))
	close(respMsg2)
	<-brokerDeath // wait for broker to die

	brokerDeathMsg := <-expectMsg1
	assert.IsType(&common.BrokerDeathMessage{}, brokerDeathMsg)
	assert.Equal(common.UUID("2"), brokerDeathMsg.(*common.BrokerDeathMessage).BrokerID)
	brokerDeathMsg = <-expectMsg3
	assert.IsType(&common.BrokerDeathMessage{}, brokerDeathMsg)
	assert.Equal(common.UUID("2"), brokerDeathMsg.(*common.BrokerDeathMessage).BrokerID)

	go fakeBroker(tcpAddr, expectMsg2a, respMsg2a, brokerDeath)
	conn2a, _ := listener.AcceptTCP()
	bm.ConnectBroker(&broker2, NewPassthroughCommConn(conn2a))

	assert.True(bm.IsBrokerAlive(uuid2))
	assert.Equal(&uuid2, <-liveChan)
	ids := []*common.UUID{&bm.GetLiveBroker().BrokerID, &bm.GetLiveBroker().BrokerID, &bm.GetLiveBroker().BrokerID}
	assert.Contains(ids, &uuid2)
}

func TestBrokerDeathWithClientReassignRequest(t *testing.T) {
	log.Debug("Starting test TestBrokerDeathWithClientReassignRequest")
	assert := require.New(t)

	deathChan := make(chan *common.UUID, 5)
	liveChan := make(chan *common.UUID, 5)
	brokerDeathChan := make(chan bool, 4)
	brokerReassignChan := make(chan *BrokerReassignment, 10)
	clock := common.NewFakeClock(time.Now())

	expectMsg1 := make(chan common.Sendable, 5)
	expectMsg2 := make(chan common.Sendable, 5)
	expectMsg2a := make(chan common.Sendable, 5)
	expectMsg3 := make(chan common.Sendable, 5)
	respMsg1 := make(chan common.Sendable, 5)
	respMsg2 := make(chan common.Sendable, 5)
	respMsg2a := make(chan common.Sendable, 5)
	respMsg3 := make(chan common.Sendable, 5)

	tcpAddr, _ := net.ResolveTCPAddr("tcp", "127.0.0.1:56000")
	listener, _ := net.ListenTCP("tcp", tcpAddr)
	go fakeBroker(tcpAddr, expectMsg1, respMsg1, brokerDeathChan)
	conn1, _ := listener.AcceptTCP()
	uuid1 := common.UUID("1")
	broker1 := common.BrokerInfo{BrokerID: uuid1, ClientBrokerAddr: "0.0.0.0:1001", CoordBrokerAddr: "0.0.0.0:0001"}

	go fakeBroker(tcpAddr, expectMsg2, respMsg2, brokerDeathChan)
	conn2, _ := listener.AcceptTCP()
	uuid2 := common.UUID("2")
	broker2 := common.BrokerInfo{BrokerID: uuid2, ClientBrokerAddr: "0.0.0.0:1002", CoordBrokerAddr: "0.0.0.0:0002"}

	go fakeBroker(tcpAddr, expectMsg3, respMsg3, brokerDeathChan)
	conn3, _ := listener.AcceptTCP()
	uuid3 := common.UUID("3")
	broker3 := common.BrokerInfo{BrokerID: uuid3, ClientBrokerAddr: "0.0.0.0:1003", CoordBrokerAddr: "0.0.0.0:0003"}

	msgBuf := make(chan *MessageFromBroker, 100)
	bm := NewBrokerManager(new(DummyEtcdManager), 10*time.Second, deathChan, liveChan, msgBuf, brokerReassignChan, clock)

	defer func() {
		bm.TerminateBroker(uuid1)
		bm.TerminateBroker(uuid2)
		bm.TerminateBroker(uuid3)
		listener.Close()
		time.Sleep(50 * time.Millisecond) // Brief pause to let TCP close
	}()

	bm.ConnectBroker(&broker1, NewPassthroughCommConn(conn1))
	bm.ConnectBroker(&broker2, NewPassthroughCommConn(conn2))
	bm.ConnectBroker(&broker3, NewPassthroughCommConn(conn3))

	for i := 0; i < 3; i++ {
		<-liveChan // Clear out the old live channel
	}

	// Clear out expected messages to move on to responses
	sendDummyMessage(conn1, expectMsg1)
	sendDummyMessage(conn2, expectMsg2)
	sendDummyMessage(conn3, expectMsg3)

	// Set up broker 1 with 1 publisher, broker 2 with 2 clients, broker 3 with 1 client
	publishMessage := &common.BrokerPublishMessage{
		MessageIDStruct: common.MessageIDStruct{1}, UUID: "pub0",
		Metadata: make(map[string]interface{}), Value: "1",
	}
	publishMessage.Metadata["Building"] = "Soda"
	respMsg1 <- publishMessage
	respMsg2 <- &common.BrokerQueryMessage{Query: queryStr, UUID: common.UUID("11")}
	sendDummyMessage(conn2, expectMsg2)
	respMsg2 <- &common.BrokerQueryMessage{Query: queryStr + " and Room = '2'", UUID: common.UUID("12")}
	respMsg3 <- &common.BrokerQueryMessage{Query: queryStr + " and Room = '3'", UUID: common.UUID("13")}

	clientResp := make(chan common.Sendable)
	go func() {
		resp, _ := bm.HandlePubClientRemapping(&common.BrokerRequestMessage{LocalBrokerAddr: "0.0.0.0:1002",
			IsPublisher: false, UUID: common.UUID("12")})
		clientResp <- resp
	}()

	time.Sleep(50 * time.Millisecond)      // Give time for heartbeat threads to get current time
	clock.AdvanceNowTime(12 * time.Second) // single heartbeat interval since we sent a request
	time.Sleep(50 * time.Millisecond)

	respMsg := <-clientResp

	assert.False(bm.IsBrokerAlive(common.UUID("2")))

	common.AssertStrEqual(assert, &common.BrokerAssignmentMessage{
		BrokerInfo: common.BrokerInfo{BrokerID: common.UUID("1"), ClientBrokerAddr: "0.0.0.0:1001",
			CoordBrokerAddr: "0.0.0.0:0001"},
	}, respMsg)

	<-deathChan

	// since broker is dead now, BrokerDeathMessages should be sent out
	resp1 := (<-expectMsg1).(*common.BrokerDeathMessage)
	assert.Equal(common.BrokerInfo{BrokerID: common.UUID("2"), ClientBrokerAddr: "0.0.0.0:1002", CoordBrokerAddr: "0.0.0.0:0002"}, resp1.BrokerInfo)
	respMsg1 <- &common.AcknowledgeMessage{MessageID: resp1.MessageID}
	resp3 := (<-expectMsg3).(*common.BrokerDeathMessage)
	assert.Equal(common.BrokerInfo{BrokerID: common.UUID("2"), ClientBrokerAddr: "0.0.0.0:1002", CoordBrokerAddr: "0.0.0.0:0002"}, resp3.BrokerInfo)
	respMsg3 <- &common.AcknowledgeMessage{MessageID: resp3.MessageID}

	// client 3 needs a new broker as well
	resp, _ := bm.HandlePubClientRemapping(&common.BrokerRequestMessage{LocalBrokerAddr: "0.0.0.0:1002",
		IsPublisher: false, UUID: common.UUID("12")})
	common.AssertStrEqual(assert, &common.BrokerAssignmentMessage{
		BrokerInfo: common.BrokerInfo{BrokerID: common.UUID("3"), ClientBrokerAddr: "0.0.0.0:1003",
			CoordBrokerAddr: "0.0.0.0:0003"},
	}, resp)

	close(respMsg2)
	<-brokerDeathChan // wait for death

	go fakeBroker(tcpAddr, expectMsg2a, respMsg2a, brokerDeathChan)
	conn2a, _ := listener.AcceptTCP()
	bm.ConnectBroker(&broker2, NewPassthroughCommConn(conn2a))

	assert.True(bm.IsBrokerAlive(uuid2))
	assert.Equal(&uuid2, <-liveChan)
}
