package dispatch

import (
	"fmt"
	"log"
	"strconv"
	"strings"

	"climax.com/mqtt.sa/etcd"
)

var dispatchCount = 0
var h HostInfo

//HostInfo stores the information of nodes
type HostInfo struct {
	Count         int64
	HostsInfoList []string
}

// GetMqttPanel function
func GetMqttPanel() {

	resp := etcd.Select("/mqtt/panel")

	for _, ev := range resp.Kvs {
		k := string(ev.Key)
		v := string(ev.Value)

		if v == "undefined" {
			dispatch(k)
		}
	}
}

//dispatch ...
func dispatch(panelInfo string) {
	hostCount := GetHostsCount()
	fmt.Println("hostCount: ", hostCount)

	if int64(dispatchCount) < hostCount {
		dispatchAlogrithm(panelInfo)
	} else {
		dispatchCount = 0
		dispatchAlogrithm(panelInfo)
	}

}

func dispatchAlogrithm(panelInfo string) {
	fmt.Println("dispatchCount: ", dispatchCount)
	host := h.HostsInfoList[dispatchCount]
	//set to h.HostsInfoList to etcd
	//get value from etcd
	resp := etcd.Select(host)

	var connectedValue string
	for _, ev := range resp.Kvs {
		connectedValue = string(ev.Value)
		fmt.Println("key: ", string(ev.Key))
		fmt.Println("connectedValue: ", connectedValue)
	}

	connectedValueToInt, err := strconv.Atoi(connectedValue)
	connectedValueToInt++
	connectedValue = strconv.Itoa(connectedValueToInt)

	if err != nil {
		log.Fatal(err)
	}

	etcd.Upsert(host, connectedValue)

	//upsert /mqtt/panel/001d940361c0 10.0.1.xx
	hostSplit := strings.Split(host, "/")
	hostIP := hostSplit[len(hostSplit)-1]
	etcd.Upsert(panelInfo, hostIP)

	dispatchCount++

	//upsert /mqtt/sa/connected/10.15.1.1/001d940361c0 001d940361c0
	mac := getPanelMac(panelInfo)
	key := "/mqtt/sa/connected/" + hostIP + "/" + mac
	etcd.Upsert(key, mac)
}

//GetHostsCount function
func GetHostsCount() int64 {
	resp := etcd.Select("/mqtt/sa/host/")
	h.HostsInfoList = make([]string, resp.Count)
	for i, ev := range resp.Kvs {
		h.HostsInfoList[i] = string(ev.Key) //get host information from etcd
	}

	h.Count = resp.Count //get hosts count

	for _, value := range h.HostsInfoList {
		fmt.Println("value: " + value)
	}
	return resp.Count
}

func getPanelMac(panelInfo string) string {
	str := strings.Split(panelInfo, "/")
	return str[len(str)-1]
}
