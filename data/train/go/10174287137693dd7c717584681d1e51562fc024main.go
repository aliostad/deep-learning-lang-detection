package main

import (
	"flag"
	"time"

	"github.com/sheki/mongoproxy"
)

var (
	tenS         = 10 * time.Second
	readTimeout  = flag.Duration("read_timeout", tenS, "read time out for connections")
	writeTimeout = flag.Duration("write_timeout", tenS, "write time out for connections")

	listenAddr       = flag.String("listen_addr", ":6000", "address to listen for incomming requests")
	mongoAddr        = flag.String("mongo_addr", ":27017", "address of the mongo to proxy")
	maxMongoConn     = flag.Uint("max_mongo_conn", 100, "max connections to mongo")
	dispatchQueueLen = flag.Uint("dispatch_queue_len", 10000, "dispatch queue length")
)

func main() {

	flag.Parse()

	proxy := mongoproxy.Proxy{
		ListenerTimeout:     *readTimeout,
		DispatcherTimeout:   *writeTimeout,
		ListenAddr:          *listenAddr,
		MongoAddr:           *mongoAddr,
		MaxMongoConnections: *maxMongoConn,
		DispatchQueueLen:    *dispatchQueueLen,
	}
	proxy.Start()
}
