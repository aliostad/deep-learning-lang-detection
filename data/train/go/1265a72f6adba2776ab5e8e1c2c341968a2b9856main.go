package main

import (
	"github.com/gorilla/websocket"
	"github.com/ilya-shikhaleev/garage-band/lib/game"
	"html/template"
	"log"
	"net/http"
	"net/url"
	"time"
)

const (
	ADDR string = ":12321"
)

var room *game.Room
var rooms []*game.Room

func homeHandler(c http.ResponseWriter, r *http.Request) {
	var homeTempl = template.Must(template.ParseFiles("web/rooms.html"))

	data := struct {
		Rooms       []*game.Room
		Instruments map[game.InstrumentType]string
	}{rooms, room.GetFreeInstruments()}
	homeTempl.Execute(c, data)
}

func wsHandler(w http.ResponseWriter, r *http.Request) {
	//1024 - buffer size
	ws, err := websocket.Upgrade(w, r, nil, 1024, 1024)
	if _, ok := err.(websocket.HandshakeError); ok {
		http.Error(w, "Not a websocket handshake", 400)
		return
	} else if err != nil {
		return
	}

	playerName := "Player"
	params, _ := url.ParseQuery(r.URL.RawQuery)
	if len(params["name"]) > 0 {
		playerName = params["name"][0]
	}

	bandName := "Laja"
	if len(params["band"]) > 0 {
		bandName = params["band"][0]
	}
	instrumentType := game.DEFAULT_INSTRUMENT
	if len(params["instrument"]) > 0 {
		instrumentType = game.InstrumentType(params["instrument"][0])
	}
	instrument := game.CreateInstrument(instrumentType)

	// Get or create a room
	log.Println("login into room: ", bandName)

	// Create Player and Conn
	player := game.NewPlayer(playerName, instrument)
	log.Println("new player: ", playerName, " with instrument", instrument.Name())
	cp := game.NewConnectedPlayer(ws, player, room)

	log.Printf("Player: %s has joined to room: %s", cp.Name(), room.Name())
}

func main() {
	log.Println("new room create")
	room = game.NewRoom("Лажа")
	rooms = make([]*game.Room, 0)
	rooms = append(rooms, room)

	http.HandleFunc("/", homeHandler)
	http.HandleFunc("/ws", wsHandler)

	http.Handle("/img/", http.StripPrefix("/img/", http.FileServer(http.Dir("./web/img/"))))
	http.Handle("/js/", http.StripPrefix("/js/", http.FileServer(http.Dir("./web/js/"))))
	http.Handle("/css/", http.StripPrefix("/css/", http.FileServer(http.Dir("./web/css/"))))
	http.Handle("/font/", http.StripPrefix("/font/", http.FileServer(http.Dir("./web/font/"))))
	http.Handle("/audio/", http.StripPrefix("/audio/", http.FileServer(http.Dir("./web/audio/"))))

	http.HandleFunc("/static/", func(w http.ResponseWriter, r *http.Request) {
		http.ServeFile(w, r, r.URL.Path[1:])
	})

	s := &http.Server{
		Addr:           ADDR,
		Handler:        nil,
		ReadTimeout:    1000 * time.Second,
		WriteTimeout:   1000 * time.Second,
		MaxHeaderBytes: 1 << 20,
	}

	log.Fatal(s.ListenAndServe())
}
