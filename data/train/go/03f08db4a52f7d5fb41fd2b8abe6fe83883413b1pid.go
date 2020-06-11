package utils

import (
	"fmt"
	"os"
	"strconv"
)

type Process string

func (p Process) Val() string {
	return string(p)
}

const (
	PROCESS_ANALYZER  Process = "analyzer"
	PROCESS_GUARDIAN  Process = "gaurdian"
	PROCESS_RECORDER  Process = "recorder"
	PROCESS_JANITOR   Process = "janitor"
	PROCESS_GENERATOR Process = "generator"
	PROCESS_AGENT     Process = "goaway-agent"
	PROCESS_SERVER    Process = "goaway-server"
)

func RegPid(process Process) {

	f, err := os.OpenFile("/var/run/goaway/"+process.Val()+".pid", os.O_RDWR|os.O_CREATE, 0644)
	if err != nil {
		fmt.Println(err.Error())
	}
	f.WriteString(strconv.Itoa(os.Getpid()))
	f.Close()
}
