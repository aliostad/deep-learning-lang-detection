package system

import(
	"bufio"
	"io"
	"strconv"
	"strings"

	"github.com/ProhtMeyhet/libgosimpleton/iotool"
)

type Load struct {
	// number of jobs in the run queue (state  R)  or waiting for
	// disk I/O (state D) averaged over 1, 5, and 15 minutes
	one,
	five,
	fifteen		float32

	//  number of currently runnable kernel scheduling entities (processes, threads)
	runable		uint64

	// number of kernel scheduling  entities  that  currently  exist  on  the  system
	allEntities	uint64

	// PID of the process that was most recently created on the system.
	mostRecentPid	uint64

	// "cache"
	loadavg,
	complete	string
}

// return average system load
func AverageLoad() (load *Load, e error) {
	load = &Load{}
	return load, load.parse()
}

func (load *Load) parse() (e error) {
	handler, e := iotool.Open(iotool.ReadOnly(), PROC_LOAD_AVERAGE); if e != nil { return }
	return load.scan(handler)
}

func (load *Load) scan(handler io.Reader) (e error) {
	load.loadavg = ""; load.complete = ""
	scanner := bufio.NewScanner(handler); scanner.Split(bufio.ScanWords)

// one
	if !scanner.Scan() { return UNEXPECTED_LOADAVG_FORMAT_ERROR }
		scanned := string(scanner.Bytes()); load.loadavg += scanned + " "
		toobig, _ := strconv.ParseFloat(scanned, 32)
		load.one = float32(toobig)

// five
	if !scanner.Scan() { return UNEXPECTED_LOADAVG_FORMAT_ERROR }
		scanned = string(scanner.Bytes()); load.loadavg += scanned + " "
		toobig, _ = strconv.ParseFloat(scanned, 32)
		load.five = float32(toobig)

// fifteen
	if !scanner.Scan() { return UNEXPECTED_LOADAVG_FORMAT_ERROR }
		scanned = string(scanner.Bytes()); load.loadavg += scanned + " "
		toobig, _ = strconv.ParseFloat(scanned, 32)
		load.fifteen = float32(toobig)

// runnable + allEntities
	if !scanner.Scan() { return UNEXPECTED_LOADAVG_FORMAT_ERROR }
		scanned = string(scanner.Bytes()); load.complete += load.loadavg + scanned
		split := strings.Split(scanned, PROC_ENTITIES_SEPARATOR)
		if len(split) != 2 { return UNEXPECTED_LOADAVG_FORMAT_ERROR }
		load.runable, _ = strconv.ParseUint(split[0], 10, 0)
		load.allEntities, _ = strconv.ParseUint(split[1], 10, 0)

// most recent pid
	if !scanner.Scan() { return UNEXPECTED_LOADAVG_FORMAT_ERROR }
		scanned = string(scanner.Bytes()); load.complete += " " + scanned
		load.mostRecentPid, _ = strconv.ParseUint(string(scanner.Bytes()), 10, 0)

	return
}

func (load *Load) One() float32 {
	return load.one
}

func (load *Load) Five() float32 {
	return load.five
}

func (load *Load) Fifteen() float32 {
	return load.fifteen
}

func (load *Load) Runable() uint64 {
	return load.runable
}

func (load *Load) AllEntities() uint64 {
	return load.allEntities
}

func (load *Load) MostRecentPid() uint64 {
	return load.mostRecentPid
}

func (load *Load) String() string {
	return load.loadavg
}

func (load *Load) Complete() string {
	return load.complete
}
