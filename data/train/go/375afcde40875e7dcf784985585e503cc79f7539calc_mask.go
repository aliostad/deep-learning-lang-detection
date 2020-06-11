package main

import (
	"fmt"
	"flag"
	"strings"
)

const PROCESS_CREATE_PROCESS = 0x0080
const PROCESS_CREATE_THREAD = 0x0002
const PROCESS_DUP_HANDLE = 0x0040
const PROCESS_SET_INFORMATION = 0x0200
const PROCESS_SET_QUOTA = 0x0100
const PROCESS_QUERY_LIMITED_INFORMATION = 0x1000
const PROCESS_QUERY_INFORMATION = 0x0400
const PROCESS_SUSPEND_RESUME = 0x0800
const PROCESS_TERMINATE = 0x0001
const PROCESS_VM_OPERATION = 0x0008
const PROCESS_VM_READ = 0x0010
const PROCESS_VM_WRITE = 0x0020
const SYNCHRONIZE = 0x00100000

func main(){
	maskParameter := flag.String("m",""," ACCESS_MASK separated by |")
	osVersionParameter := flag.Int("v",6,"Windows OS version")
	flag.Parse()

	maskArray := strings.Split(*maskParameter,"|")
	maskResult := 0x0
	for _,mask := range maskArray {

		mask = strings.TrimSpace(mask)

		switch mask {
			case "PROCESS_CREATE_PROCESS":
				maskResult |= PROCESS_CREATE_PROCESS
				break
			case "PROCESS_CREATE_THREAD":
				maskResult |= PROCESS_CREATE_THREAD
				break
			case "PROCESS_DUP_HANDLE":
				maskResult |= PROCESS_DUP_HANDLE
				break
			case "PROCESS_QUERY_INFORMATION":
				maskResult |= PROCESS_QUERY_INFORMATION
				maskResult |= PROCESS_QUERY_LIMITED_INFORMATION
				break
			case "PROCESS_QUERY_LIMITED_INFORMATION":
				if *osVersionParameter < 6 {
					fmt.Println("PROCESS_QUERY_LIMITED_INFORMATION is not available in Windows < 6.x. Ignoring")
					break
				}
				maskResult |= PROCESS_QUERY_LIMITED_INFORMATION
				break
			case "PROCESS_SET_INFORMATION":
				maskResult |= PROCESS_SET_INFORMATION
				break
			case "PROCESS_SET_QUOTA":
				maskResult |= PROCESS_SET_QUOTA
				break
			case "PROCESS_SUSPEND_RESUME":
				maskResult |= PROCESS_SUSPEND_RESUME
				break
			case "PROCESS_TERMINATE":
				maskResult |= PROCESS_TERMINATE
				break
			case "PROCESS_VM_OPERATION":
				maskResult |= PROCESS_VM_OPERATION
				break
			case "PROCESS_VM_READ":
				maskResult |= PROCESS_VM_READ
				break
			case "PROCESS_VM_WRITE":
				maskResult |= PROCESS_VM_WRITE
				break
			case "SYNCHRONIZE":
				maskResult |= SYNCHRONIZE
				break
			default:
				fmt.Println("Unknown mask value:",mask)
		}
	}
	fmt.Printf("%#x\n",maskResult)
}
