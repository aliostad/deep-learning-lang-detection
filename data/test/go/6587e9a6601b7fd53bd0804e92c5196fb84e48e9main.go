package main

import (
	"flag"
	"fmt"
	"strings"

	"github.com/golang/glog"
	"github.com/yinqiwen/ssf"
)

const wordCountEventType = int32(100)

func main() {
	zkmode := false
	a := flag.String("listen", "127.0.0.1:48100", "listen addr")
	home := flag.String("home", "./", "application home dir")
	flag.BoolVar(&zkmode, "zk", false, "use zookeeper")
	cluster := flag.String("cluster", "example/127.0.0.1:48100,127.0.0.1:48101,127.0.0.1:48102", "cluster name&servers")
	dispatch := flag.String("dispatch", "wc/ssf.RawMessage,main.Word", "message dispatch config, format <processor>/<proto name>[,<proto name>][&<processor>/<proto name>[,<proto name>...]")
	flag.Parse()
	defer glog.Flush()

	var cfg ssf.ClusterConfig
	cfg.ListenAddr = *a
	cfg.ProcHome = *home
	cs := strings.Split(*cluster, "/")
	if len(cs) != 2 {
		fmt.Printf("Invalid cluster args.\n")
		flag.PrintDefaults()
		return
	}
	cfg.ClusterName = cs[0]
	if zkmode {
		cfg.ZookeeperServers = strings.Split(cs[1], ",")
	} else {
		cfg.SSFServers = strings.Split(cs[1], ",")
	}

	cfg.Dispatch = make(map[string][]string)
	disItems := strings.Split(*dispatch, "&")
	for _, item := range disItems {
		mapping := strings.Split(item, "/")
		if len(mapping) != 2 {
			fmt.Printf("Invalid dispatch arg:%s\n", *dispatch)
			flag.PrintDefaults()
			return
		}
		names := strings.Split(mapping[1], ",")
		cfg.Dispatch[mapping[0]] = names
	}
	ssf.Start(&cfg)
}
