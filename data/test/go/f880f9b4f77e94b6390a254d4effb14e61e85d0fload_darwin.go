// +build darwin

package load

import (
	"os/exec"
	"strconv"
	"strings"
)

func Get() (Load, error) {
	l := Load{}
	out, err := exec.Command("uptime").Output()
	if err != nil {
		return Load{}, err
	}

	outString := strings.Trim(string(out), "\n")
	loadPrefix := "load averages: "
	loadIndex := strings.Index(outString, loadPrefix)
	loadAveragesString := outString[loadIndex+len(loadPrefix):]
	tokens := strings.Split(loadAveragesString, " ")

	avg1, _ := strconv.ParseFloat(tokens[0], 32)
	avg5, _ := strconv.ParseFloat(tokens[1], 32)
	avg15, _ := strconv.ParseFloat(tokens[2], 32)
	l.Avg1 = float32(avg1)
	l.Avg5 = float32(avg5)
	l.Avg15 = float32(avg15)

	return l, nil
}
