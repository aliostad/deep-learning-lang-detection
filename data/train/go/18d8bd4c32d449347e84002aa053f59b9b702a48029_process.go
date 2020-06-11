package main

import (
	"container/list"
	"fmt"
	"os/exec"
	"strings"
)

const (
	opid = iota
	ppid
	comm
	empty = ""
)

type Process struct {
	Opid  string
	Ppid  string
	Comm  string
	Child *list.List
}

func getCurrentProcess() []string {
	ps := exec.Command("ps", "-e", "-opid,ppid,comm")
	buf, err := ps.Output()
	if err != nil {
		panic(err)
	}

	return strings.Split(string(buf), "\n")
}

func buildProcessList(rows []string) []*Process {
	processList := make([]*Process, len(rows))

	for i := 0; i < len(rows); i++ {
		currentProcess := new(Process)
		currentProcess.Child = list.New()
		processList[i] = currentProcess

		columns := strings.Split(rows[i], " ")

		columnCursor := 0
		for j := 0; j < len(columns); j++ {
			switch {
			case columnCursor == opid && columns[j] != empty:
				currentProcess.Opid = columns[j]
				columnCursor++
			case columnCursor == ppid && columns[j] != empty:
				currentProcess.Ppid = columns[j]
				columnCursor++
				for _, v := range processList {
					if v != nil && currentProcess != nil && v.Opid == currentProcess.Ppid {
						v.Child.PushBack(currentProcess)
					}
				}
			case columnCursor == comm && columns[j] != empty:
				currentProcess.Comm = columns[j]
				columnCursor++
			}
		}
	}

	return processList
}

func printProcessList(processList []*Process) {
	for _, v := range processList {
		switch {
		case v.Child.Len() > 1:
			fmt.Printf("Pid %s(%s) has %d children: [", v.Opid, v.Comm, v.Child.Len())
			for e := v.Child.Front(); e != nil; e = e.Next() {
				fmt.Printf("%s ", e.Value.(*Process).Opid)
			}
			fmt.Printf("]\n")
		case v.Child.Len() == 1:
			fmt.Printf("Pid %s(%s) has 1 child: [", v.Opid, v.Comm)
			fmt.Printf("%s", v.Child.Front().Value.(*Process).Opid)
			fmt.Printf("]\n")
		default:
			fmt.Printf("Pid %s has no child.\n", v.Opid)
		}

	}
}

func main() {
	rows := getCurrentProcess()
	processList := buildProcessList(rows)
	printProcessList(processList)
}
