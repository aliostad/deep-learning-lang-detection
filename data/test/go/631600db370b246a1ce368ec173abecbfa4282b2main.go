package main

import (
	"math/rand"
	"os"

	"github.com/cloudfoundry-community/cf-subway/broker"
	"github.com/codegangsta/cli"
)

func runBroker(c *cli.Context) {
	subway := broker.NewBroker()
	subway.LoadBackendBrokersFromEnv()

	subway.Run()
}

func main() {
	rand.Seed(4200)

	app := cli.NewApp()
	app.Name = "cf-subway"
	app.Version = "0.1.0"
	app.Usage = "Underground tunnel to multiplex multiple homogenous service brokers"
	app.Commands = []cli.Command{
		{
			Name:   "broker",
			Usage:  "run the broker",
			Flags:  []cli.Flag{},
			Action: runBroker,
		},
	}
	app.Run(os.Args)

}
