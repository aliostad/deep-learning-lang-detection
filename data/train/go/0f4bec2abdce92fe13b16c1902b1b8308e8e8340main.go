package main

import (
    // standard
    "fmt"
    "flag"

    // external
    mdg "github.com/jheise/majordomogo/broker"
)
var (
    addr string
    port string
)

func init() {
    flag.StringVar(&addr, "addr", "0.0.0.0", "Address to bind to, default 0.0.0.0")
    flag.StringVar(&port, "port", "9999", "Port to bind to, default 9999")
    flag.Parse()
}

func main() {
    connect := fmt.Sprintf("tcp://%s:%s", addr, port)
    fmt.Printf("Starting broker: %s\n", connect)

    broker, err := mdg.NewBroker(connect)
    if err != nil {
        panic(err)
    }
    defer broker.Close()

    broker.Run()
}
