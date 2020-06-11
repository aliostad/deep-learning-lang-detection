package main

import (
	log "code.google.com/p/log4go"
	"github.com/bmizerany/pat"
	"github.com/pmylund/go-cache"
	"io/ioutil"
	"net"
	"net/http"
	"time"
	. "utils"
)

// this file process local http request that contain commands to stop, start or restart a process
var snoozedProcesses *cache.Cache

const (
	PORT_FILE = "/tmp/errplane-agent.port"
)

func startLocalServer() {
	snoozedProcesses = cache.New(0, 0)

	m := pat.New()

	m.Get("/stop_monitoring/:process", http.HandlerFunc(stopMonitoring))
	m.Get("/start_monitoring/:process", http.HandlerFunc(startMonitoring))
	m.Get("/restart_process/:process", http.HandlerFunc(restartProcess))

	// Register this pat with the default serve mux so that other packages
	// may also be exported. (i.e. /debug/pprof/*)
	http.Handle("/", m)
	c, err := net.Listen("tcp4", "localhost:")
	if err != nil {
		log.Error("Error while opening port for listening: %s", err)
		return
	}

	_, port, _ := net.SplitHostPort(c.Addr().String())
	if err := ioutil.WriteFile(PORT_FILE, []byte(port), 0644); err != nil {
		log.Error("Error while writing port number to %s", PORT_FILE)
		return
	}

	log.Info("Started listening for command on %s", c.Addr().String())
	log.Info("Wrote port to %s", PORT_FILE)

	err = http.Serve(c, nil)
	if err != nil {
		log.Error("ListenAndServe: ", err)
	}
}

func getProcess(processName string) (*Process, error) {
	monitoredProcesses, err := GetMonitoredProcesses(nil)
	if err != nil {
		return nil, err
	}

	// find the process and add it to our cache
	for _, process := range monitoredProcesses {
		if process.Name == processName {
			return process, nil
		}
	}
	return nil, nil
}

type InvalidProcessName struct{}

func (self *InvalidProcessName) Error() string {
	return "Invalid process name"
}

func snoozeProcess(processName string, duration time.Duration) error {
	log.Info("Trying to snooze %s", processName)

	process, err := getProcess(processName)
	if err != nil {
		return err
	}
	if process != nil {
		log.Info("Snoozed %s", processName)
		snoozedProcesses.Set(processName, true, duration)
		return nil
	}
	return &InvalidProcessName{}
}

func unsnoozeProcess(processName string) error {
	log.Info("Trying to unsnooze %s", processName)

	process, err := getProcess(processName)
	if err != nil {
		return err
	}
	if process != nil {
		log.Info("Unsnoozed %s", processName)
		snoozedProcesses.Delete(processName)
		return nil
	}
	return &InvalidProcessName{}
}

func stopMonitoring(w http.ResponseWriter, req *http.Request) {
	var err error
	// make sure that we're monitoring that process
	processName := req.URL.Query().Get(":process")
	duration := req.URL.Query().Get("duration")
	timeDuration := time.Duration(-1)
	if duration != "" {
		timeDuration, err = time.ParseDuration(duration)
		if err != nil {
			w.WriteHeader(http.StatusBadRequest)
			return
		}
	}

	if err := snoozeProcess(processName, timeDuration); err != nil {
		log.Warn("Error while snoozing process. Error: %s", err)
		if _, ok := err.(*InvalidProcessName); ok {
			w.WriteHeader(http.StatusBadRequest)
		} else {
			w.WriteHeader(http.StatusInternalServerError)
		}
		return
	}
	log.Info("Stopped monitoring '%s'", processName)
	w.WriteHeader(http.StatusOK)
}

func startMonitoring(w http.ResponseWriter, req *http.Request) {
	processName := req.URL.Query().Get(":process")

	if err := unsnoozeProcess(processName); err != nil {
		log.Warn("Error while unsnoozing process. Error: %s", err)
		if _, ok := err.(*InvalidProcessName); ok {
			w.WriteHeader(http.StatusBadRequest)
		} else {
			w.WriteHeader(http.StatusInternalServerError)
		}
		return
	}
	log.Info("Started monitoring '%s'", processName)
	w.WriteHeader(http.StatusOK)
}

func restartProcess(w http.ResponseWriter, req *http.Request) {
	processName := req.URL.Query().Get(":process")

	process, err := getProcess(processName)

	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	log.Info("Restarting '%s'", processName)

	snoozedProcesses.Set(process.Name, true, -1)
	defer snoozedProcesses.Delete(process.Name)
	stopProcess(process)
	startProcess(process)
}
