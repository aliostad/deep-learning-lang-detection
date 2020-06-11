package main

import (
	"fmt"
	"log"
	"net"
	"time"
)

//成功连接的地址
var servers map[string]*Client = make(map[string]*Client, 0)

//连接其他机器
func handlerBrokers(brokers []string) {

	if len(brokers) > 0 {
		for _, broker := range brokers {
			if broker == thisBroker || broker == "" {
				continue
			} else {
				log.Println("Trying to connect the others broker ", broker)
				clientServe(broker)
			}
		}
	}
}

func clientServe(server string) {
	var t1 = time.NewTimer(HEATBEAT)

	//成功连接
	if _, ok := servers[server]; ok {
		return
	}

	//log.Println(server)
	tcpAddr, err := net.ResolveTCPAddr("tcp4", server)
	if err != nil {
		log.Println(err, server)
		deleteBroker(server)
		return
	}

	conn, err := net.DialTCP("tcp", nil, tcpAddr)
	if err != nil {
		deleteBroker(server)
		return
	}

	client := NewSerClient(server, conn)

	//send auth
	msg := &Message{BUFAUTH, &AuthMessage{thisBroker, thisBroker}}
	client.SendMessage(msg)

	go func(client *Client) {
		for {
			select {
			case <-t1.C:
				words := fmt.Sprintf("%s", "ping")
				tmp := &IMMessage{-1, -1, -1, -1, words}
				msg := &Message{BUFVERSION, tmp}
				err := client.SendBuffMessage(msg)
				if err != nil {
					log.Println("ping err so delete server  ", server)
					delete(servers, server)
					deleteBroker(server)
				} else {
					t1.Reset(HEATBEAT)
				}

			}
		}
	}(client)
	//目标对方的连接
	servers[server] = client
	log.Println(" connected  broker ", server)
}

func RedirectServer(client *Client, msg *Message) {
	if msg.version == BUFVERSION && client.key != thisBroker {
		if imsg, ok := msg.body.(*IMMessage); ok {
			if imsg.Sender <= -1 && imsg.Receiver <= -1 {
				client.SetTimeOut()
			} else {
				go func() {
					for k, v := range servers {
						if k == thisBroker {
							continue
						}
						v.SendMessage(msg)
					}
				}()
			}
		}
	}
}
