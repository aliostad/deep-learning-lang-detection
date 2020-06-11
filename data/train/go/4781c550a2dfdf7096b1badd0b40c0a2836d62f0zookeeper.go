package main

import (
	"encoding/json"
	"strconv"
	"strings"
	"time"

	"github.com/samuel/go-zookeeper/zk"
)

type Broker struct {
	host string
	port float64
}

func ConnectToZk() *zk.Conn {
	zkServers := strings.Split(*zookeepers, ",")
	conn, _, err := zk.Connect(zkServers, time.Second)
	must(err)
	return conn
}

func GetTopicsFromZk(conn *zk.Conn) []string {
	topics, _, err := conn.Children("/brokers/topics")
	must(err)

	return topics
}

/*func GetBrokersFromZk(conn *zk.Conn) []string {
	brokerIds, _, err := conn.Children("/brokers/ids")
	must(err)

	brokerAddrs := make([]string, len(brokerIds))
	for i, brokerId := range brokerIds {
		brokerAddr, _, err := conn.Get("/brokers/ids/" + brokerId)
		must(err)
		var addr Broker
		err = json.Unmarshal(brokerAddr, &addr)
		must(err)
		brokerAddrs[i] = addr.host + ":" + strconv.FormatFloat(addr.port, 'f', -1, 64)
	}
	return brokerAddrs
}*/

func GetBrokersFromZk(conn *zk.Conn) []string {
	brokerIds, _, err := conn.Children("/brokers/ids")
	must(err)
	brokerAddrs := make([]string, len(brokerIds))
	for i, brokerId := range brokerIds {
		brokerAddr, _, err := conn.Get("/brokers/ids/" + brokerId)
		must(err)
		var addr interface{}
		jsonErr := json.Unmarshal(brokerAddr, &addr)
		must(jsonErr)
		addrMap := addr.(map[string]interface{})
		host := addrMap["host"].(string)
		port := strconv.FormatFloat(addrMap["port"].(float64), 'f', -1, 64)
		brokerAddrs[i] = host + ":" + port
	}
	return brokerAddrs
}
