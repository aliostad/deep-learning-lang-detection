package main

import (
	"fmt"
	"time"
)

const (
	CHECK_INTERNVAL_IN_SECONDS = 5
)

func GetForegroundApp() {
	fmt.Println()
	fmt.Println(time.Now().String())

	hwnd := GetForegroundWindow()
	if hwnd == 0 {
		return
	}

	processID := GetWindowProcessId(hwnd)
	fmt.Println("pid:", processID)

	processHandle := OpenProcess(processID)
	if processHandle == 0 {
		return
	}

	windowText := GetWindowText(hwnd)
	fmt.Println("wnd:", windowText)

	if IsImmersiveProcess(processHandle) {
		CloseHandle(processHandle)
		hwnd, processID = GetUniversalApp(hwnd, processID)
		processHandle = OpenProcess(processID)
		fmt.Println("pid:", processID)
	}

	commandLine := GetProcessCommandLine(processHandle)
	fmt.Println("cmd:", commandLine)

	logger.Log(windowText, commandLine)
}
