package loadinfo

import (
	"github.com/silenteh/monitoring/jsonutils"
	"github.com/silenteh/monitoring/utils"
	"strings"
)

type Load struct {
	Minute   float64 //
	Minute5  float64 //
	Minute15 float64 //
	Ts       int32
}

func GatherInfo(channel chan string) {
	go func() {
		load := LoadAverage()
		channel <- jsonutils.ToJsonWithMap(&load, "loadAvg")
	}()
}

func LoadAverage() Load {
	load := Load{}
	detectedOs := utils.DetectOS()
	switch detectedOs {
	case utils.DARWIN:
		loadFull := utils.ExecCommand(true, "sysctl", "-n", "vm.loadavg")
		loadFullNoLeftBrackets := strings.Replace(loadFull, "{", "", -1)
		loadFullNoRightBrackets := strings.Replace(loadFullNoLeftBrackets, "}", "", -1)
		loadFullNoNewLine := strings.Replace(loadFullNoRightBrackets, "/n", "", -1)
		loadFullTrim := strings.Trim(loadFullNoNewLine, " ")
		loadFullArray := strings.Split(loadFullTrim, " ")

		load.Ts = utils.UTCTimeStamp()

		for index, element := range loadFullArray {
			i := utils.StringToFloat64(element, false)
			switch index {
			case 0:
				load.Minute = i
				break

			case 1:
				load.Minute5 = i
				break

			case 2:
				load.Minute15 = i
				break
			}
		}

		break
	case utils.LINUX:
		//getconf PAGESIZE
		loadFull := utils.ExecCommand(true, "cat", "/proc/loadavg")
		loadNoNewLine := strings.Replace(loadFull, "\n", "", -1)
		loadFullTrim := strings.Trim(loadNoNewLine, " ")
		loadFullArray := strings.Split(loadFullTrim, " ")

		load.Ts = utils.UTCTimeStamp()

		for index, element := range loadFullArray {
			if index <= 2 {
				i := utils.StringToFloat64(element, false)
				switch index {
				case 0:
					load.Minute = i
					break

				case 1:
					load.Minute5 = i
					break

				case 2:
					load.Minute15 = i
					break
				}
			}
		}
		break
	}
	return load
}
