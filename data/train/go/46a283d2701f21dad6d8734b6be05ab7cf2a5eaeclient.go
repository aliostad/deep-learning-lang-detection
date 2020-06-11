//	 ,+---+
//	+---+´|    HASHBOX SOURCE
//	| # | |    Copyright 2015-2016
//	+---+´

// Hashbox core, version 0.1
package core

import (
	"github.com/fredli74/bytearray"

	"encoding/binary"
	"errors"
	"fmt"
	"net"
	"runtime"
	"sync"
	"sync/atomic"
	"time"
)

const DEFAULT_QUEUE_SIZE int64 = 32 * 1024 * 1024 // 32 MiB max memory
const DEFAULT_CONNECTION_TIMEOUT time.Duration = 5 * time.Minute

type messageDispatch struct {
	msg           *ProtocolMessage
	returnChannel chan interface{}
}

type Client struct {
	// variables used in atomic operations (declared first to make sure they are 32 / 64 bit aligned)
	msgNum              uint32 // protocol message number, 32-bit because there are no 16-bit atomic functions
	sendworkers         int32  // number of active send workers
	transmittedBlocks   int32  // number of transmitted blocks
	skippedBlocks       int32  // number of skipped blocks
	WriteData           int64  // total data written
	WriteDataCompressed int64  // total compressed data written

	Session
	AccessKey Byte128 // = hmac^20000( AccountName "*ACCESS*KEY*PAD*", md5( password ))

	conn        *TimeoutConn
	wg          sync.WaitGroup
	EnablePaint bool

	QueueMax int64 // max size of the outgoing block queue (in bytes)

	sendMutex sync.Mutex // protects from two threads sending at the same time

	// mutex protected
	dispatchMutex  sync.Mutex
	closing        bool
	blockbuffer    map[Byte128]*HashboxBlock
	blockqueuesize int64 // queue size in bytes

	sendqueue []*sendQueueEntry

	handlerErrorSignal chan error

	dispatchChannel chan *messageDispatch
	storeChannel    chan *messageDispatch
}

func NewClient(conn net.Conn, account string, accesskey Byte128) *Client {

	client := &Client{
		conn:      NewTimeoutConn(conn, DEFAULT_CONNECTION_TIMEOUT),
		AccessKey: accesskey,
		Session: Session{
			AccountNameH: Hash([]byte(account)),
		},
		blockbuffer: make(map[Byte128]*HashboxBlock),

		QueueMax: DEFAULT_QUEUE_SIZE,

		dispatchChannel: make(chan *messageDispatch, 1024),
		storeChannel:    make(chan *messageDispatch, 1),
	}
	client.handlerErrorSignal = make(chan error, 1)
	client.wg.Add(1)
	go client.ioHandler()

	{ // Say hello
		r := client.dispatchAndWait(MsgTypeGreeting, &MsgClientGreeting{Version: ProtocolVersion}).(*MsgServerGreeting)
		clientTime := uint64(time.Now().Unix())
		serverTime := binary.BigEndian.Uint64(r.SessionNonce[:]) / 1000000000
		if clientTime < serverTime-600 || clientTime > serverTime+600 {
			panic(errors.New("Connection refused, system time difference between client and server is more than 10 minutes."))
		}

		client.SessionNonce = r.SessionNonce
		client.GenerateSessionKey(client.AccessKey)
	}

	{ // Authenticate
		client.dispatchAndWait(MsgTypeAuthenticate, &MsgClientAuthenticate{
			AccountNameH:    client.AccountNameH,
			AuthenticationH: DeepHmac(1, client.AccountNameH[:], client.SessionKey),
		})
	}

	return client
}

var lastPaint string = "\n"

func (c *Client) Paint(what string) {
	if c.EnablePaint && (what != "\n" || what != lastPaint) {
		fmt.Print(what)
		lastPaint = what
	}
}

func (c *Client) Close(polite bool) {
	if polite {
		c.dispatchAndWait(MsgTypeGoodbye, nil)
	}

	c.dispatchMutex.Lock()
	if !c.closing {
		c.closing = true
		close(c.dispatchChannel)
		close(c.storeChannel)
	}
	c.dispatchMutex.Unlock()

	c.conn.Close() // This will cancel a blocking IO-read if we have one
	c.wg.Wait()
}

type sendQueueEntry struct {
	state int32 // (atomic alignment) 0 - new, 1 - compressing, 2 - compressed, 3 - sending, 4 - sent
	block *HashboxBlock
}

func (c *Client) sendQueue(what Byte128) {
	c.dispatchMutex.Lock()
	defer c.dispatchMutex.Unlock()
	block := c.blockbuffer[what]
	if block != nil {
		c.sendqueue = append(c.sendqueue, &sendQueueEntry{0, block})
		//		fmt.Printf("+q=%d;", len(c.sendqueue))

		if c.sendworkers < int32(runtime.NumCPU()) {
			atomic.AddInt32(&c.sendworkers, 1)
			go func() {
				defer func() { // a panic was raised inside the goroutine (most likely the channel was closed)
					if r := recover(); !c.closing && r != nil {
						err, _ := <-c.handlerErrorSignal
						if err != nil {
							panic(err)
						} else {
							panic(r)
						}
					}
				}()

				for done := false; !done; {
					var workItem *sendQueueEntry

					c.dispatchMutex.Lock()
					if len(c.sendqueue) > 0 {
						if c.sendqueue[0].state == 2 { // compressed
							c.blockqueuesize -= bytearray.ChunkQuantize(int64(c.sendqueue[0].block.UncompressedSize))
							c.blockqueuesize += bytearray.ChunkQuantize(int64(c.sendqueue[0].block.CompressedSize))
							workItem = c.sendqueue[0] // send it
						} else if c.sendqueue[0].state == 4 { // sent
							c.sendqueue = c.sendqueue[1:] // remove it
							//							fmt.Printf("-q=%d;", len(c.sendqueue))
						} else {
							for i := 0; i < len(c.sendqueue); i++ {
								if c.sendqueue[i].state == 0 { // new
									workItem = c.sendqueue[i] // compress it
									break
								}
							}
						}
						if workItem != nil {
							atomic.AddInt32(&workItem.state, 1)
						}
					} else {
						done = true
						atomic.AddInt32(&c.sendworkers, -1)
						//						fmt.Println("worker stopping")
					}
					c.dispatchMutex.Unlock()

					if workItem != nil {
						switch workItem.state {
						case 0:
							panic("ASSERT!")
						case 1:
							workItem.block.CompressData()
							atomic.AddInt32(&workItem.state, 1)
						case 2:
							panic("ASSERT!")
						case 3:
							atomic.AddInt64(&c.WriteData, int64(workItem.block.UncompressedSize))
							atomic.AddInt64(&c.WriteDataCompressed, int64(workItem.block.CompressedSize))
							atomic.AddInt32(&c.transmittedBlocks, 1) //	c.transmittedBlocks++
							c.Paint("*")
							msg := &ProtocolMessage{Num: uint16(atomic.AddUint32(&c.msgNum, 1) - 1), Type: MsgTypeWriteBlock, Data: &MsgClientWriteBlock{Block: workItem.block}}
							c.storeChannel <- &messageDispatch{msg: msg}
							atomic.AddInt32(&workItem.state, 1)
						default:
							panic("ASSERT!")
						}
					} else {
						time.Sleep(25 * time.Millisecond)
					}
				}
			}()
		}
	}
}

func (c *Client) singleExchange(outgoing *messageDispatch) *ProtocolMessage {
	// Send an outgoing message
	WriteMessage(c.conn, outgoing.msg)

	// Wait for the reply
	incoming := ReadMessage(c.conn)
	if incoming.Num != outgoing.msg.Num {
		panic(errors.New("ASSERT! Jag kan inte programmera"))
	}
	if outgoing.returnChannel != nil {
		outgoing.returnChannel <- incoming
		close(outgoing.returnChannel)
	}

	// Handle block queue
	switch d := incoming.Data.(type) {
	case *MsgServerError:
		panic(errors.New("Received error from server: " + string(d.ErrorMessage)))
	case *MsgServerAcknowledgeBlock:
		var skipped bool = false

		c.dispatchMutex.Lock()
		block := c.blockbuffer[d.BlockID]
		if block != nil {
			if block.CompressedSize < 0 { // no encoded data = never sent
				skipped = true
				c.blockqueuesize -= bytearray.ChunkQuantize(int64(block.UncompressedSize))
			} else {
				c.blockqueuesize -= bytearray.ChunkQuantize(int64(block.CompressedSize))
			}
			block.Release()
			delete(c.blockbuffer, d.BlockID)
		}
		c.dispatchMutex.Unlock()

		if skipped {
			atomic.AddInt32(&c.skippedBlocks, 1) //c.skippedBlocks++
			c.Paint("-")
		}
	case *MsgServerReadBlock:
		c.sendQueue(d.BlockID)
	case *MsgServerWriteBlock:
	}
	return incoming
}

func (c *Client) ioHandler() {
	defer func() {
		if r := recover(); !c.closing && r != nil { // a panic was raised inside the goroutine
			//			fmt.Println("ioHandler error:", r)
			c.handlerErrorSignal <- r.(error)
			close(c.handlerErrorSignal)
		}

		c.dispatchMutex.Lock()
		if !c.closing {
			c.closing = true
			close(c.dispatchChannel)
			close(c.storeChannel)
		}
		c.dispatchMutex.Unlock()

		c.wg.Done()
	}()

	for {
		select {
		case outgoing, ok := <-c.storeChannel:
			if !ok {
				return
			}
			c.singleExchange(outgoing)
		default:
			select {
			case outgoing, ok := <-c.dispatchChannel:
				if !ok {
					return
				}
				c.singleExchange(outgoing)
			default:
				continue
			}
		}
	}
}

// dispatchMessage returns a result channel if a returnChannel was specified, otherwise it just returns nil
func (c *Client) dispatchMessage(msgType uint32, msgData interface{}, returnChannel chan interface{}) {
	defer func() {
		if r := recover(); !c.closing && r != nil { // a panic was raised (most likely the channel was closed)
			err, _ := <-c.handlerErrorSignal
			if err != nil {
				panic(err)
			} else {
				panic(r)
			}
		}
	}()

	if !c.closing {
		msg := &ProtocolMessage{Num: uint16(atomic.AddUint32(&c.msgNum, 1) - 1), Type: msgType, Data: msgData}
		c.dispatchChannel <- &messageDispatch{msg: msg, returnChannel: returnChannel}
	} else {
		if returnChannel != nil {
			close(returnChannel)
		}
	}
}

// dispatchAndWait will always return the response you were waiting for or throw a panic, so there is no need to check return values
func (c *Client) dispatchAndWait(msgType uint32, msgData interface{}) interface{} {
	waiter := make(chan interface{}, 1)
	c.dispatchMessage(msgType, msgData, waiter)
	select {
	case R, ok := <-waiter:
		if !ok {
			panic(errors.New("Server disconnected while waiting for a response"))
		}
		switch t := R.(type) {
		case *ProtocolMessage:
			switch dt := t.Data.(type) {
			case *MsgServerError:
				panic(errors.New("Received error from server: " + string(dt.ErrorMessage)))
			default:
				return t.Data
			}
		}
	case err := <-c.handlerErrorSignal:
		if err != nil {
			panic(err)
		}
		panic(errors.New("Connection was closed while waiting for a response"))
	}
	panic(errors.New("ASSERT! We should not reach this point"))
}

func (c *Client) GetAccountInfo() *MsgServerAccountInfo {
	r := c.dispatchAndWait(MsgTypeAccountInfo, &MsgClientAccountInfo{AccountNameH: c.AccountNameH}).(*MsgServerAccountInfo)
	return r
}
func (c *Client) ListDataset(datasetName string) *MsgServerListDataset {
	r := c.dispatchAndWait(MsgTypeListDataset, &MsgClientListDataset{AccountNameH: c.AccountNameH, DatasetName: String(datasetName)}).(*MsgServerListDataset)
	return r
}
func (c *Client) AddDatasetState(datasetName string, state DatasetState) {
	c.dispatchAndWait(MsgTypeAddDatasetState, &MsgClientAddDatasetState{AccountNameH: c.AccountNameH, DatasetName: String(datasetName), State: state})
}
func (c *Client) RemoveDatasetState(datasetName string, stateID Byte128) {
	c.dispatchAndWait(MsgTypeRemoveDatasetState, &MsgClientRemoveDatasetState{AccountNameH: c.AccountNameH, DatasetName: String(datasetName), StateID: stateID})
}

func (c *Client) VerifyBlock(blockID Byte128) bool {
	r := c.dispatchAndWait(MsgTypeAllocateBlock, &MsgClientAllocateBlock{BlockID: blockID})
	switch r.(type) {
	case *MsgServerAcknowledgeBlock:
		return true
	case *MsgServerReadBlock:
		return false
	default:
		panic(errors.New("Unknown response from server"))
	}
	return false
}

func (c *Client) StoreData(dataType byte, data bytearray.ByteArray, links []Byte128) Byte128 {
	// Create a block
	block := NewHashboxBlock(dataType, data, links)
	return c.StoreBlock(block)
}

// StoreBlock is blocking if the blockbuffer is full
func (c *Client) StoreBlock(block *HashboxBlock) Byte128 {
	// Add the block to the io queue
	for full := true; full; { //
		c.dispatchMutex.Lock()
		if c.closing {
			c.dispatchMutex.Unlock()
			panic(errors.New("Connection closed"))
		} else if c.blockqueuesize+bytearray.ChunkQuantize(int64(block.UncompressedSize))*2 < c.QueueMax {
			if c.blockbuffer[block.BlockID] == nil {
				c.blockbuffer[block.BlockID] = block
				c.blockqueuesize += bytearray.ChunkQuantize(int64(block.UncompressedSize))
			} else {
				block.Release()
				c.dispatchMutex.Unlock()
				return block.BlockID
			}
			full = false
		}
		c.dispatchMutex.Unlock()

		if full {
			time.Sleep(25 * time.Millisecond)
		}
	}

	// Put an allocate block on the line
	c.dispatchMessage(MsgTypeAllocateBlock, &MsgClientAllocateBlock{BlockID: block.BlockID}, nil)
	return block.BlockID
}
func (c *Client) ReadBlock(blockID Byte128) *HashboxBlock {
	b := c.dispatchAndWait(MsgTypeReadBlock, &MsgClientReadBlock{BlockID: blockID}).(*MsgServerWriteBlock)
	b.Block.UncompressData()
	return b.Block
}
func (c *Client) Commit() {
	for done := false; !done; time.Sleep(100 * time.Millisecond) {
		func() {
			done = c.Done()
		}()
	}
}
func (c *Client) Done() bool {
	c.dispatchMutex.Lock()
	defer c.dispatchMutex.Unlock()
	return c.closing || len(c.blockbuffer) == 0
}

const hashPadding_accesskey = "*ACCESS*KEY*PAD*" // TODO: move to client source

// binary.BigEndian.Get and binary.BigEndian.Put  much faster than
// binary.Read and binary.Write

func (c *Client) GetStats() (tranismitted int32, skipped int32, queued int32, queuesize int64) {
	c.dispatchMutex.Lock()
	defer c.dispatchMutex.Unlock()
	return c.transmittedBlocks, c.skippedBlocks, int32(len(c.blockbuffer)), c.blockqueuesize
}
