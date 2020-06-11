package main

import (
	"encoding/json"
	"fmt"
	"github.com/gorilla/websocket"
	// "math/rand"
	"net/http"
	// "strconv"
	"time"
)

type Message struct {
	Value      int
	Id         int
	SensorType int
}

var upgrader = websocket.Upgrader{
	ReadBufferSize:  1024,
	WriteBufferSize: 1024,
}

var m Message

func simulation(updates chan measurement) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {

		conn, err := upgrader.Upgrade(w, r, nil)
		if err != nil {
			fmt.Println(err)
			return
		}

		msg := "connected"
		msgBytes := []byte(msg)
		if err = conn.WriteMessage(websocket.TextMessage, msgBytes); err != nil {
			fmt.Println(err)
		}

		for {

			_, p, err := conn.ReadMessage()
			if err != nil {
				return
			}

			_ = json.Unmarshal(p, &m)
			// fmt.Printf("%d: %d, %d\n", m.Id, m.Value, m.SensorType)

			measured := measurement{
				sensorId:   m.Id,
				sensorType: m.SensorType,
				value:      m.Value,
			}

			updates <- measured
		}
	}
}

func managerws(reads chan *readInstrument) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {

		conn, err := upgrader.Upgrade(w, r, nil)
		if err != nil {
			fmt.Println(err)
			return
		}

		readTicker := time.NewTicker(time.Millisecond * 100).C
		for {
			select {
			case <-readTicker:
				for i := 0; i < NUM_SENSORS; i++ {
					read := &readInstrument{
						key:  i,
						resp: make(chan *Instrument)}
					reads <- read
					r := <-read.resp
					// fmt.Println(r)
					if err := conn.WriteJSON(r); err != nil {
						return
					}
				}
			}
		}
	}
}

func StartServer(updates chan measurement, reads chan *readInstrument) {
	go func() {
		fmt.Println("Server started")
		http.HandleFunc("/simulation", simulation(updates))
		http.HandleFunc("/managerws", managerws(reads))
		// http.HandleFunc("/manager", manager(reads))
		http.Handle("/", http.FileServer(http.Dir("./webui")))
		err := http.ListenAndServe(":8080", nil)
		if err != nil {
			panic("Error: " + err.Error())
		}

	}()
}
