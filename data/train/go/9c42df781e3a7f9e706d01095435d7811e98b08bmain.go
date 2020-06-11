package main

import (
	"fmt"
	"github.com/alrs/muninplugin"
	"io/ioutil"
	"log"
	"os"
	"strconv"
	"strings"
)

const loadFile = "/proc/loadavg"

func load() (l float32, err error) {
	loadSlice, err := ioutil.ReadFile(loadFile)
	if err != nil {
		return
	}
	loadString := string(loadSlice)
	values := strings.Split(loadString, " ")
	floatLoad, err := strconv.ParseFloat(values[1], 32)
	return float32(floatLoad), err
}

func main() {
	p := muninplugin.NewPlugin()
	p.GraphTitle = "Example Golang Load"

	p.MakeMetric("load")
	systemLoad, err := load()
	if err != nil {
		log.Fatal(err)
	}

	p.Metrics["load"].Value = systemLoad
	p.Metrics["load"].Warning = 24.99
	p.Metrics["load"].Critical = 25.0
	p.Metrics["load"].Min = 0.0
	p.Metrics["load"].Max = 500.00

	if len(os.Args) > 1 && os.Args[1] == "config" {
		fmt.Println(p.Config())
		os.Exit(0)
	}

	fmt.Println(p.Metrics.Values())
}
