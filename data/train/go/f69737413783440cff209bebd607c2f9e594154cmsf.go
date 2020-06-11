package main

import (
	"flag"
	"fmt"
	"log"
	"net/http"
	"sort"
	"sync"
	"text/template"
	"time"

	"github.com/google/gopacket"
	"github.com/google/gopacket/layers"
	"github.com/google/gopacket/pcap"
	"github.com/googollee/go-socket.io"
	"github.com/hypebeast/go-osc/osc"
)

var serverHost = flag.String("s", "127.0.0.1", "Set Pure Data server host")
var serverPort = flag.Int("p", 9001, "Set Pure Data server port")
var device = flag.String("d", "wlan0", "Set device to listen on")

var hostIP string

type activity struct {
	packets      int
	sizeSum      int
	since        time.Time
	instrument   int
	currentLevel int
}

func (activity *activity) increment() {
	activity.packets++
}

func (activity *activity) currentPackets() int {
	return activity.packets
}

func (activity *activity) addPacketSize(size int) {
	activity.sizeSum += size
}

type instrument struct {
	name               string
	mapLevel           func(bps float64) (int, int)
	adjustCurrentLevel func(client *activity, targetLevel int)
	sendMessage        func(client *osc.Client, level int, pitch int, offbeat int, instrument string)
	mapPitchLevel      func(pps float64) int
}

type ticker struct {
	sync.RWMutex
	msgDelay   time.Duration
	resetDelay time.Duration
}

func mapPitchLevel(pps float64) int {
	var level int
	if pps > 200 {
		level = 7
	} else if pps > 150 {
		level = 6
	} else if pps > 100 {
		level = 5
	} else if pps > 75 {
		level = 4
	} else if pps > 50 {
		level = 3
	} else if pps > 20 {
		level = 2
	} else if pps > 5 {
		level = 1
	} else {
		level = 0
	}
	return level
}

func mapChordPitchLevel(pps float64) int {
	var level int
	if pps > 150 {
		level = 4
	} else if pps > 100 {
		level = 3
	} else if pps > 50 {
		level = 2
	} else if pps > 5 {
		level = 1
	} else {
		level = 0
	}
	return level
}

func mapDrumLevel(bps float64) (int, int) {
	var level int
	var offbeat int

	if bps > 5000 {
		level = 4
		offbeat = 3
	} else if bps > 4000 {
		level = 4
		offbeat = 0
	} else if bps > 3000 {
		level = 3
		offbeat = 3
	} else if bps > 2000 {
		level = 3
		offbeat = 0
	} else if bps > 1000 {
		level = 2
		offbeat = 3
	} else if bps > 500 {
		level = 2
		offbeat = 0
	} else if bps > 300 {
		level = 1
		offbeat = 3
	} else if bps > 200 {
		level = 1
		offbeat = 0
	} else if bps > 100 {
		level = 8
		offbeat = 3
	} else if bps > 50 {
		level = 8
		offbeat = 0
	} else if bps > 10 {
		level = 16
		offbeat = 3
	} else if bps > 5 {
		level = 16
		offbeat = 0
	} else {
		level = 0
		offbeat = 0
	}
	return level, offbeat
}

func mapSnareLevel(bps float64) (int, int) {
	var level int
	var offbeat int

	if bps > 15000 {
		level = 4
		offbeat = 3
	} else if bps > 13000 {
		level = 4
		offbeat = 0
	} else if bps > 12000 {
		level = 3
		offbeat = 3
	} else if bps > 7500 {
		level = 3
		offbeat = 0
	} else if bps > 5000 {
		level = 2
		offbeat = 3
	} else if bps > 3500 {
		level = 2
		offbeat = 0
	} else if bps > 2000 {
		level = 1
		offbeat = 3
	} else if bps > 1500 {
		level = 1
		offbeat = 0
	} else if bps > 200 {
		level = 8
		offbeat = 3
	} else if bps > 100 {
		level = 8
		offbeat = 0
	} else if bps > 40 {
		level = 16
		offbeat = 3
	} else if bps > 15 {
		level = 16
		offbeat = 0
	} else {
		level = 0
		offbeat = 0
	}
	return level, offbeat
}

func mapKickLevel(bps float64) (int, int) {
	var level int
	offbeat := 0

	if bps > 4000 {
		level = 3
	} else if bps > 2000 {
		level = 2
	} else if bps > 500 {
		level = 1
	} else if bps > 100 {
		level = 8
	} else if bps > 10 {
		level = 16
	} else {
		level = 0
	}
	return level, offbeat
}

func mapChordLevel(bps float64) (int, int) {
	var level int
	var offbeat int

	if bps > 2000 {
		level = 3
		offbeat = 3
	} else if bps > 1200 {
		level = 3
		offbeat = 0
	} else if bps > 600 {
		level = 2
		offbeat = 3
	} else if bps > 150 {
		level = 2
		offbeat = 0
	} else if bps > 70 {
		level = 1
		offbeat = 3
	} else if bps > 10 {
		level = 1
		offbeat = 0
	} else {
		level = 0
		offbeat = 0
	}
	return level, offbeat
}

func mapMelodyLevel(bps float64) (int, int) {
	var level int
	var offbeat int

	if bps > 5000 {
		level = 8
		offbeat = 3
	} else if bps > 4000 {
		level = 8
		offbeat = 0
	} else if bps > 3000 {
		level = 7
		offbeat = 3
	} else if bps > 2000 {
		level = 7
		offbeat = 0
	} else if bps > 1000 {
		level = 6
		offbeat = 3
	} else if bps > 500 {
		level = 6
		offbeat = 0
	} else if bps > 300 {
		level = 5
		offbeat = 3
	} else if bps > 200 {
		level = 5
		offbeat = 0
	} else if bps > 100 {
		level = 4
		offbeat = 3
	} else if bps > 70 {
		level = 4
		offbeat = 0
	} else if bps > 50 {
		level = 3
		offbeat = 3
	} else if bps > 30 {
		level = 3
		offbeat = 0
	} else if bps > 20 {
		level = 2
		offbeat = 3
	} else if bps > 10 {
		level = 2
		offbeat = 0
	} else if bps > 5 {
		level = 1
		offbeat = 3
	} else if bps > 3 {
		level = 1
		offbeat = 0
	} else {
		level = 0
		offbeat = 0
	}
	return level, offbeat
}

func adjustDrumLevel(client *activity, targetLevel int) {
	if targetLevel > 4 {
		client.currentLevel = targetLevel
	} else {
		if client.currentLevel > 4 {
			client.currentLevel = 1
		}
		adjustLevel(client, targetLevel)
	}
}

func adjustMelodyLevel(client *activity, targetLevel int) {
	client.currentLevel = targetLevel
}

func adjustLevel(client *activity, targetLevel int) {
	if client.currentLevel < targetLevel {
		client.currentLevel++
	} else if client.currentLevel > targetLevel {
		client.currentLevel--
	}
}

type data struct {
	IP string
}

func index(w http.ResponseWriter, r *http.Request) {
	t, _ := template.ParseFiles("tmpl/index.html")
	fmt.Print(hostIP)
	val := data{hostIP}
	t.Execute(w, val)
}

func serv() *socketio.Server {

	server, err := socketio.NewServer(nil)
	if err != nil {
		log.Fatal(err)
	}
	server.On("connection", func(so socketio.Socket) {
		log.Println("on connection")
		so.Join("chat")
		so.On("disconnection", func() {
			log.Println("on disconnect")
		})
	})
	server.On("error", func(so socketio.Socket, err error) {
		log.Println("error:", err)
	})

	mux := http.NewServeMux()
	mux.HandleFunc("/", index)
	mux.Handle("/socket.io/", server)
	go http.ListenAndServe(":8000", mux)

	return server
}

func oscServ(t *ticker) {
	addr := "0.0.0.0:9001"
	server := &osc.Server{Addr: addr}

	server.Handle("/metro", func(msg *osc.Message) {
		osc.PrintMessage(msg)
		if msg.CountArguments() == 1 {
			fmt.Println("message has attr")
			millis := time.Millisecond * time.Duration(msg.Arguments[0].(int32))

			t.Lock()
			t.msgDelay = millis
			t.resetDelay = millis * 8
			t.Unlock()
		}
	})

	go server.ListenAndServe()
}

func main() {
	flag.Parse()

	devices, err := pcap.FindAllDevs()
	if err != nil {
		log.Fatal(err)
	}

	filter := ""
	for _, dev := range devices {
		if dev.Name == *device {
			fmt.Println(dev)
			for _, address := range dev.Addresses {
				filter = fmt.Sprintf("not ip host %s ", address.IP)
				hostIP = address.IP.String()
				break
			}
		}
	}

	handle, err := pcap.OpenLive(*device, 65536, true, 0)
	if err != nil {
		defer handle.Close()
		panic(err)
	}

	err = handle.SetBPFFilter(filter)
	if err != nil {
		log.Fatal(err)
	}

	fmt.Println(handle.LinkType())
	packetSource := gopacket.NewPacketSource(handle, handle.LinkType())
	fmt.Println("Connection to ", *serverHost, *serverPort)
	client := osc.NewClient(*serverHost, *serverPort)

	var clients = struct {
		sync.RWMutex
		m              map[string]*activity
		instrumentPool []int
	}{m: make(map[string]*activity)}

	instruments := map[int]*instrument{
		0: &instrument{"snare", mapSnareLevel, adjustDrumLevel, sendDrumMessage, mapPitchLevel},
		1: &instrument{"kick", mapKickLevel, adjustDrumLevel, sendDrumMessage, mapPitchLevel},
		2: &instrument{"bass", mapMelodyLevel, adjustMelodyLevel, sendMelodyMessage, mapPitchLevel},
		3: &instrument{"hh", mapDrumLevel, adjustDrumLevel, sendDrumMessage, mapPitchLevel},
		4: &instrument{"melody", mapMelodyLevel, adjustMelodyLevel, sendMelodyMessage, mapPitchLevel},
		5: &instrument{"melody2", mapMelodyLevel, adjustMelodyLevel, sendMelodyMessage, mapPitchLevel},
		6: &instrument{"chords", mapChordLevel, adjustLevel, sendMelodyMessage, mapChordPitchLevel},
		7: &instrument{"conga", mapDrumLevel, adjustDrumLevel, sendDrumMessage, mapPitchLevel},
		8: &instrument{"clap", mapDrumLevel, adjustDrumLevel, sendDrumMessage, mapPitchLevel},
	}

	server := serv()
	t := &ticker{msgDelay: time.Duration(2) * time.Second, resetDelay: time.Duration(16) * time.Second}
	oscServ(t)

	go func() {
		for {
			clients.Lock()

			var keys []string
			for k := range clients.m {
				keys = append(keys, k)
			}
			sort.Strings(keys)

			delayValue := 0
			if len(keys) > 4 {
				delayValue = 1
			}
			sendDelayMessage(client, delayValue)

			server.BroadcastTo("chat", "chat clear", "")
			for _, key := range keys {
				value := clients.m[key]
				elapsed := time.Since(value.since)
				pps := float64(value.currentPackets()) / elapsed.Seconds()
				bps := float64(value.sizeSum) / elapsed.Seconds()

				instrument, ok := instruments[value.instrument]
				info := ""

				if ok {
					targetLevel, offbeat := instrument.mapLevel(bps)
					if targetLevel == 0 {
						clients.instrumentPool = append(clients.instrumentPool, value.instrument)
						sort.Ints(clients.instrumentPool)
						delete(clients.m, key)
					}
					pitch := instrument.mapPitchLevel(pps)
					instrument.adjustCurrentLevel(value, targetLevel)
					instrument.sendMessage(client, value.currentLevel, pitch, offbeat, instrument.name)

					info = fmt.Sprintf("MAC: %s, instrument: %s, pps: %.2f, bps: %.2f, elapsed: %.2f, level: %d, pitch: %d", key, instrument.name, pps, bps, elapsed.Seconds(), value.currentLevel, pitch)
					fmt.Println(info)
					server.BroadcastTo("chat", "chat message", info)
				} else {
					clients.instrumentPool = append(clients.instrumentPool, value.instrument)
					sort.Ints(clients.instrumentPool)
					delete(clients.m, key)
				}
			}

			if len(keys) > 0 {
				fmt.Println()
			}
			clients.Unlock()

			t.RLock()
			var dl = t.msgDelay
			fmt.Println("msg tick at", t.msgDelay)
			t.RUnlock()
			time.Sleep(dl)
		}
	}()

	go func() {
		for {
			clients.Lock()

			for _, value := range clients.m {
				value.since = time.Now()
				value.packets = 0
				value.sizeSum = 0
			}
			clients.Unlock()

			t.RLock()
			var dl = t.resetDelay
			fmt.Println("reset tick at", t.resetDelay)
			t.RUnlock()
			time.Sleep(dl)
		}
	}()

	for packet := range packetSource.Packets() {
		// fmt.Println(packet)
		// Let's see if the packet is an ethernet packet
		ethernetLayer := packet.Layer(layers.LayerTypeEthernet)
		if ethernetLayer != nil {
			// fmt.Println("Ethernet layer detected.")
			ethernetPacket, _ := ethernetLayer.(*layers.Ethernet)
			// fmt.Println("Source MAC: ", ethernetPacket.SrcMAC, "Destination MAC: ", ethernetPacket.DstMAC)
			// Ethernet type is typically IPv4 but could be ARP or other
			// fmt.Println("Ethernet type: ", ethernetPacket.EthernetType)

			clients.Lock()
			packetLength := len(ethernetPacket.Payload)

			_, ok := clients.m[ethernetPacket.DstMAC.String()]
			if ok {
				p := clients.m[ethernetPacket.DstMAC.String()]
				p.increment()
				p.addPacketSize(packetLength)
			} else {
				var instrument int
				if len(clients.instrumentPool) != 0 {
					instrument = clients.instrumentPool[0]
					clients.instrumentPool = append(clients.instrumentPool[:0], clients.instrumentPool[0+1:]...)
				} else {
					instrument = len(clients.m)
				}
				clients.m[ethernetPacket.DstMAC.String()] = &activity{1, packetLength, time.Now(), instrument, 0}
			}
			clients.Unlock()
		}
	}
}

func sendDrumMessage(client *osc.Client, level int, pitch int, offbeat int, instrument string) {
	msg := osc.NewMessage("/instrument/" + instrument)
	msg.Append(int32(level))
	msg.Append(int32(offbeat))
	client.Send(msg)
}

func sendMelodyMessage(client *osc.Client, level int, pitch int, offbeat int, instrument string) {
	msg := osc.NewMessage("/instrument/" + instrument)
	msg.Append(int32(level))
	msg.Append(int32(pitch))
	msg.Append(int32(offbeat))
	client.Send(msg)
}

func sendDelayMessage(client *osc.Client, value int) {
	msg := osc.NewMessage("/instrument/delay")
	msg.Append(int32(value))
	//fmt.Println("sending delay", value)
	client.Send(msg)
}
