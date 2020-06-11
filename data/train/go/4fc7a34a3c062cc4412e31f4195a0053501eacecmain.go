package main

import (
	//"fmt"
	"log/manager"
	"log/provider"
	"time"
)

const (
	PATH     = "path"
	PREFIX   = "prefix"
	LOG_SIZE = "log_size"
)

func output() {
	//with out format 
	manager.Trace("hello Trace")
	manager.Debug("hello Debug")
	manager.Info("hello Info")
	manager.Warn("hello Warn")
	manager.Error("hello Error")
	manager.Critical("hello Critical")

	manager.Tracef("%s", "hello Trace")
	manager.Debugf("%s", "hello Debug")
	manager.Infof("%s", "hello Info")
	manager.Warnf("%s", "hello Warn")
	manager.Errorf("%s", "hello Error")
	manager.Criticalf("%s", "hello Critical")
}
func main() {

	manager.Run()
	defer manager.Stop()

	output()

	fileArgs := provider.Arg{
		Driver: "hello test",
		Extras: map[string]interface{}{
			provider.PATH:   "./testlog.log",
			provider.PREFIX: "[lewgun]",
			//provider.WRITE_TYPE: provider.SINGLE_APPEND,
			provider.WRITE_TYPE: provider.MULTI_APPEND,
			provider.LOG_SIZE:   1,
			provider.FLAG:       provider.Lshortfile | provider.LstdFlags,
			provider.LOG_COUNT:  3,
		},
	}

	err := manager.Open(provider.FILE, manager.LEVEL_ALL, &fileArgs)
	if err != nil {
		panic(err)
	}
	for i := 0; i < 100000; i++ {

		output()
	}

	logger := manager.Current()
	logger.Println("hello", 1, 2.3)
	logger.Panic("with std log, crashed")

	for {

		time.Sleep(time.Second * 3)
	}

}
