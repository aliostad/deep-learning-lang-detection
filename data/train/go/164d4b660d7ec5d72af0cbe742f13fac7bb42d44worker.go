package main

import (
	"bufio"
	"flag"
	"fmt"
	"log"
	"os"
	"time"

	"github.com/daemonl/connor"
)

var brokerAddress string

func init() {
	flag.StringVar(&brokerAddress, "broker", "127.0.0.1:5555", "broker's worker address")
}

func main() {
	err := do()
	if err != nil {
		fmt.Fprintln(os.Stderr, err.Error())
		os.Exit(1)
		return
	}
	fmt.Println("Clean Exit")
}

func logf(s string, p ...interface{}) {
	log.Printf(s+"\n", p...)
}

func do() error {
	for {
		// Establish a connection, retry indefinately.
		conn := connor.TinyHandshakeDial(brokerAddress)
		logf("Connected [%s]", brokerAddress)

		scanner := bufio.NewScanner(conn)
		for scanner.Scan() {
			line := scanner.Text()
			logf("Got %s", line)
			time.Sleep(time.Second)
			conn.Write([]byte("hello " + line + "\n"))
		}
		conn.Close()
		logf("Connection Ended [%s]", brokerAddress)
	}
}
