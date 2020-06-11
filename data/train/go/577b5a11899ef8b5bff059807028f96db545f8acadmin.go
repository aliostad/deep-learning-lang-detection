// Command freestore_admin runs a sample controller of servers.
package main

import (
	"flag"
	"log"

	"github.com/mateusbraga/freestore/pkg/comm"
	"github.com/mateusbraga/freestore/pkg/view"
)

func main() {
	leave := flag.String("leave", "", "Process to leave the system")
	//initialProcess := flag.String("initial", "", "Process to ask for the initial view")
	flag.Parse()

	if *leave != "" {
		leavingProcess := view.Process{*leave}

		log.Printf("Asking %v to leave\n", leavingProcess)

		sendLeaveProcess(leavingProcess)
	}
}

func sendLeaveProcess(process view.Process) {
	err := comm.SendRPCRequest(process, "AdminService.Leave", struct{}{}, &struct{}{})
	if err != nil {
		log.Println(err)
		return
	}
}
