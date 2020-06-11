package libclient

import (
	"os"
	"time"
)

type ProcessManagerClient struct {
	*Connection
}

func ConnectProcessManager() (pm *ProcessManagerClient, err error) {
	conn, err := Connect("/system/socket/ProcessSocket")
	if err != nil {
		return nil, err
	}
	pm = &ProcessManagerClient{conn}
	createProcessEventHandlers()
	pm.eventHandler = processEventHandler
	return
}

// register to ProcessManager
func (conn *ProcessManagerClient) Register(data map[string]string) {
	flexibleData := make(map[string]interface{}, len(data))
	for key, val := range data {
		flexibleData[key] = val
	}
	flexibleData["pid"] = os.Getpid()
	conn.Send("register", flexibleData)
}

// processmanager loop
func RunProcess(data map[string]string) {
	var err error
	for {
		Process, err = ConnectProcessManager()

		// wait five seconds before trying again...
		if err != nil {
			time.Sleep(5)
		} else {
			Process.Register(data)
			Process.Run()
		}
	}
}

// event handler
func processEventHandler(conn *Connection, command string, params map[string]interface{}) {
	if ProcessEventHandlers[command] != nil {
		ProcessEventHandlers[command](conn, command, params)
	}
}
