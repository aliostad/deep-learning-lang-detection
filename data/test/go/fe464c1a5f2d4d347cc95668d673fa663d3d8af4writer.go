package writer

import (
	"fmt"
	"io/ioutil"
	"os"
	"path/filepath"
	"time"

	"github.com/tnoda78/posiserver/configuration"
)

func WriteTargetsLoop(config *configuration.Configuration) {
	for _, writeTarget := range config.WriteFiles {
		createDirectory(writeTarget)
		go writeTargetLoop(writeTarget)
	}
}

func createDirectory(writeTarget configuration.WriteFile) {
	directoryName := filepath.Dir(writeTarget.Path)
	os.MkdirAll(directoryName, 0777)
}

func writeTargetLoop(writeTarget configuration.WriteFile) {
	var i = 0

	for {
		fmt.Println(fmt.Printf("[%s] Path: %s, Data: %s", time.Now().Format("2006-01-02 15:04:05"), writeTarget.Path, writeTarget.Data[i]))
		err := ioutil.WriteFile(writeTarget.Path, []byte(writeTarget.Data[i]), 0644)

		if err != nil {
			fmt.Println(err)
		}

		i++

		if i >= len(writeTarget.Data) {
			i = 0
		}

		time.Sleep(time.Duration(writeTarget.Interval) * time.Second)
	}
}
