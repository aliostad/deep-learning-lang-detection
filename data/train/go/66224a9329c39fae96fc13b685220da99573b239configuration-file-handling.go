package main

import (
	"bufio"
	"fmt"
	"io"
	"os"
	"strings"
)

type (
	DispatchFunc  func([]string, DispatchTable)
	DispatchTable map[string]DispatchFunc
)

func onReadConfig(args []string, dispatch DispatchTable) {
	file, err := os.Open(args[0])
	if err != nil {
		panic(err.Error())
	}
	defer file.Close()
	r := bufio.NewReader(file)
	finished := false
	for !finished {
		line, err := r.ReadString('\n')
		if err == io.EOF {
			finished = true
		} else if err != nil {
			panic(err)
		}
		fields := strings.Fields(line)
		if len(fields) > 0 {
			if f, ok := dispatch[fields[0]]; ok {
				f(fields[1:], dispatch)
			}
		}
	}
}

func onDefine(args []string, dispatch DispatchTable) {
	var ok bool
	if _, ok = dispatch[args[0]]; ok {
		fmt.Println("Error in DEFINE: action %q already defined\n", args[0])
		return
	}
	var curaction DispatchFunc
	if curaction, ok = dispatch[args[1]]; !ok {
		fmt.Println("Error in DEFINE: curaction %q not defined\n", args[1])
		return
	}
	dispatch[args[0]] = func(args2 []string, dispatch DispatchTable) {
		curaction(args[2:], dispatch)
	}
}

func main() {
	if len(os.Args) != 2 {
		fmt.Printf("Usage %s CONFIG\n", os.Args[0])
		os.Exit(0)
	}

	dispatch := DispatchTable{
		"CONFIG": onReadConfig,
		"DEFINE": onDefine,
		"PRINT": func(args []string, dispatch DispatchTable) {
			fmt.Println(strings.Join(args, " "))
		},
		"CD": func(args []string, dispatch DispatchTable) {
			fmt.Printf("Change dir to: %q\n", args[0])
		},
	}

	onReadConfig(os.Args[1:], dispatch)
}
