package cl

import (
	"bufio"
	"fmt"
	"os"
	"strings"
	"time"
)

func readLine(question, defaultValue string) string {

	if defaultValue != "" {
		fmt.Printf("%s: [%s] ", question, defaultValue)
	} else {
		fmt.Printf("%s: ", question)
	}

	bio := bufio.NewReader(os.Stdin)
	line, _, _ := bio.ReadLine()

	lineStr := string(line)

	if lineStr == "" {
		return defaultValue
	} else {
		return lineStr
	}

}

func getUserProcessID() (string, error) {

	processList, err := getProcesses()

	if err != nil {
		return "", err
	}

	if len(processList) == 0 {
		return "", fmt.Errorf("No process running")
	}

	if len(processList) == 1 {
		fmt.Printf("Process ID: '%s'\n", processList[0].Id)
		return processList[0].Id, nil
	}

	processIDList := make([]string, 0)
	for _, process := range processList {
		processIDList = append(processIDList, process.Id)
	}

	userProcessID := readLine("Process ID ("+strings.Join(processIDList, ",")+")", "")

	userProcessID = strings.ToLower(userProcessID)
	userProcessID = strings.Trim(userProcessID, " \n\r\t")

	found := false
	for _, process := range processList {

		if process.Id == userProcessID {
			found = true
		}
	}

	if !found {
		return "", fmt.Errorf("Unable to find %s among the processes running ("+strings.Join(processIDList, ",")+")", userProcessID)
	}

	return userProcessID, nil
}

var timeFormat string = "2006-01-02 15:04:05"

func formatTime(ts int64) string {
	timeObj := time.Unix(ts, 0)
	return timeObj.Format(timeFormat)
}
