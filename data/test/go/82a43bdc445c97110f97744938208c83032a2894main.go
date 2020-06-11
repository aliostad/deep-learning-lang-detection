package main

import (
	"bufio"
	"encoding/json"
	"flag"
	"github.com/FogCreek/mini"
	"github.com/gorilla/mux"
	"github.com/gorilla/sessions"
	"github.com/gorilla/websocket"
	"log"
	"net/http"
	"os"
	"time"
)

type connection struct {
	ws   *websocket.Conn
	file *os.File
	send chan []byte
	d    *dataSource
}

func (c *connection) reader() {
	for message := range c.send {
		err := c.ws.WriteMessage(websocket.TextMessage, message)
		if err != nil {
			log.Println(err)
			return
		}
	}
	c.ws.Close()
}

type fileData struct {
	Time     time.Time `json:"time"`
	Weight   float64   `json:"weight"`
	Unit     string    `json:"unit"`
	Location string    `json:"location"`
}

func (c *connection) fileReader(location string) {

	f, err := os.OpenFile("data.csv", os.O_APPEND|os.O_WRONLY|os.O_CREATE, 0644)
	if err != nil {
		log.Println(err)
		return
	}
	c.file = f
	w := bufio.NewWriter(c.file)
	defer w.Flush()

	for message := range c.send {
		var data fileData

		json.Unmarshal(message, &data)
		data.Location = location

		result, err := json.Marshal(data)
		if err != nil {
			continue
		}

		output := string(result)
		log.Println(output)
		_, err = w.WriteString(output + "\n")
		if err != nil {
			log.Println(err)
			return
		}
	}

}

var upgrader = websocket.Upgrader{
	ReadBufferSize:  1024,
	WriteBufferSize: 1024,
	CheckOrigin:     func(r *http.Request) bool { return true },
}

func ScaleHandler(instrument *dataSource, w http.ResponseWriter, r *http.Request) {

	ws, err := upgrader.Upgrade(w, r, nil)
	if err != nil {
		log.Println(err)
		return
	}
	c := &connection{send: make(chan []byte), ws: ws, d: instrument}
	c.d.register <- c
	defer func() { c.d.unregister <- c }()
	c.reader()
}

func StartRecordingHandler(file *connection, w http.ResponseWriter, r *http.Request) {
	decoder := json.NewDecoder(r.Body)

	session, _ := store.Get(r, "ohaus")

	session.Values["recording"] = true

	var datum fileData
	err := decoder.Decode(&datum)
	if err != nil {
		log.Fatal(err)
	}

	session.Save(r, w)
	file.send = make(chan []byte)
	file.d.register <- file
	defer func() { file.d.unregister <- file }()
	file.fileReader(datum.Location)
}

func StopRecordingHandler(file *connection, w http.ResponseWriter, r *http.Request) {

	file.d.unregister <- file
	file.file.Close()
}

var store = sessions.NewCookieStore([]byte("something-very-secret"))

func main() {
	var test bool
	flag.BoolVar(&test, "test", false, "use a random number generator instead of a live feed")
	flag.Parse()

	conf, err := mini.LoadConfiguration("config.ini")
	if err != nil {
		log.Fatal(err)
	}

	sessionKey := conf.StringFromSection("", "session-key", "some-secret-key")
	store = sessions.NewCookieStore([]byte(sessionKey))

	instrument := newDataSource()
	instrument.port = conf.StringFromSection("", "port", "/dev/ttyUSB0")
	go instrument.read(test)

	file := &connection{d: instrument}

	r := mux.NewRouter()

	r.HandleFunc("/ws", func(w http.ResponseWriter, r *http.Request) {
		ScaleHandler(instrument, w, r)
	})

	r.HandleFunc("/record", func(w http.ResponseWriter, r *http.Request) {
		StartRecordingHandler(file, w, r)
	})

	r.HandleFunc("/stop", func(w http.ResponseWriter, r *http.Request) {
		StopRecordingHandler(file, w, r)
	})

	http.Handle("/", r)

	r.PathPrefix("/").Handler(http.FileServer(http.Dir("./public/")))
	http.ListenAndServe(":8081", nil)
}
