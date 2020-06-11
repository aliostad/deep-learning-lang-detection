package resources

import (
	"github.com/silenteh/gantryos/utils"
	"strings"
)

type load struct {
	Minute   float64 //
	Minute5  float64 //
	Minute15 float64 //
	Ts       int32
}

func newLoad() load {
	return load{
		Minute:   -1,
		Minute5:  -1,
		Minute15: -1,
		Ts:       utils.UTCTimeStamp(),
	}

}

func loadAverage() load {
	load := newLoad()
	detectedOs := detectOS()
	switch detectedOs {
	case BSD:
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
	case LINUX:
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
