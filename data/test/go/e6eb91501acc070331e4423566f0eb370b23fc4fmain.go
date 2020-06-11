package main

import (
	"math/rand"
	"os"

	"github.com/codegangsta/cli"
	"github.com/dingotiles/dingo-postgresql-broker/clicmd"
)

func main() {
	rand.Seed(5000)

	app := cli.NewApp()
	app.Name = "dingo-postgresql-broker"
	app.Version = "0.1.0"
	app.Usage = "Cloud Foundry service broker to run Patroni clusters"
	app.Commands = []cli.Command{
		{
			Name:  "broker",
			Usage: "run the broker",
			Flags: []cli.Flag{
				cli.StringFlag{
					Name:  "config, c",
					Value: "config.yml",
					Usage: "path to YAML config file",
				},
			},
			Action: clicmd.RunBroker,
		},
	}
	app.Run(os.Args)
}
