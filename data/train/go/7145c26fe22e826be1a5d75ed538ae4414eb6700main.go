package main

import (
	"log"
	"LoadBalancer/parseConf"
	"encoding/json"
	"LoadBalancer/loadBalancer"
	"net/http"
	"time"
)

type Conf struct {
	CurrentWeight int
	WellNodes     []map[string]string
}

func main() {
	var conf Conf
	conf_bytes, err :=parseConf.ParseJSON("./nodes.conf")
	if err != nil {
		log.Println(err)
	}
	json.Unmarshal(conf_bytes, &conf)

	loadBalancer := &loadBalancer.LoadBalancer{}
	loadBalancer.CurrentWeight = conf.CurrentWeight
	loadBalancer.WellNodes = conf.WellNodes
	loadBalancer.TCPCheck()

	s := &http.Server{
		Addr:           ":8989",
		Handler:        loadBalancer,
		ReadTimeout:    3 * time.Minute,
		WriteTimeout:   3 * time.Minute,
		MaxHeaderBytes: 1 << 20,
	}
	log.Fatal(s.ListenAndServe())

}
