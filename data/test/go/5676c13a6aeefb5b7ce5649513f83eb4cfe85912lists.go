package main

import "fmt"
import "os"
import "os/exec"
import "time"

type ManagedProcess struct {
	ApplicationName string
	Process *os.Process
	PID int
	// add more here if needed
}


func main(){
	fmt.Println("hello world")

	var processes [32]ManagedProcess
	
	for i := 0; i < 32; i++ {
		cmd, err := execute_cmd("./servertest")

		if(err != nil) {
			continue
		}		

		// todo: factor into managed process
		var process ManagedProcess
		process.ApplicationName = "test_outputonly"
		process.Process = cmd.Process
		process.PID = cmd.Process.Pid
		
		processes[i] = process
		
		fmt.Println("New server Pid=", cmd.Process.Pid)
	}
	
	fmt.Println("Thorium.NET is running ... ")
	
	time.Sleep(10);

	fmt.Println("Thorium.NET is shutting down ... ")
	
	for i := 0; i < 32; i++ {
		err := processes[i].Process.Kill()

		if (err != nil) {
			fmt.Println(err)
		}	
	}
}

func execute_cmd(command string) (*exec.Cmd, error) {
	cmd := exec.Command(command)
	err := cmd.Start()
	if (err != nil) {
		fmt.Println("Error: ", err)
		fmt.Println("User Commmand: ", command)
	}
	return cmd, err
}

// todo
//func startProcess(applicationName string) *ManagedProcess {

