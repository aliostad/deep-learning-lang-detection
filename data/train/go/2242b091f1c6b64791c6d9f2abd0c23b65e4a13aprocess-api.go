package processes

import(
	"fmt"
	"strings"
	"strconv"

	"github.com/ProhtMeyhet/libgosimpleton/iotool"
	"github.com/ProhtMeyhet/libgosimpleton/system/user"
)

// find processes by your custom order. iterates over every process, your function
// must give back true if found and false if not. if true, processes will contain
// this ProcessInfo. do not, i repeat, do not retain the *ProcessInfo - it is reused.
func FindBy(filter func(*ProcessInfo) bool) (processes []*ProcessInfo) {
	process := &ProcessInfo{}
	for process.findBy(filter) {
		processes = append(processes, process.MakeCopy())
	}; return
}

/* TODO
func FindFirstBy(filter func(*ProcessInfo) bool) (process *ProcessInfo) {
	process := &ProcessInfo{}
	process.findBy(filter)
	return
}

func FindLastBy(filter func(*ProcessInfo) bool) (process *ProcessInfo) {
	find := &ProcessInfo{}
	for find.findBy(filter) {
		process = find
	}; return
}*/

// find by a generating func
func FindByGenerator(generator func() func(*ProcessInfo) bool) (processes []*ProcessInfo) {
	return FindBy(generator())
}

// walk over every process and do your thing
func Walk(stick func(*ProcessInfo)) {
	process := &ProcessInfo{}
	for process.findBy(func(process *ProcessInfo) bool {
		stick(process.MakeCopy()); return false
	}) {}
}

// walk by generating func
func WalkByGenerator(generator func() func(*ProcessInfo)) {
	Walk(generator())
}

// find a process by pid
func Find(aid uint64) (process *ProcessInfo, e error) {
	process = &ProcessInfo{ id: aid }
	return process, process.findById()
}

// find a process by pid given as string
func FindByStringId(aid string) (process *ProcessInfo, e error) {
	pid, e := strconv.ParseUint(aid, 10, 0); if e != nil { return }
	return Find(pid)
}

// find processes by name
func FindByName(aname string) (processes []*ProcessInfo) {
	return FindBy(func(process *ProcessInfo) bool {
		return Contains(process, aname)
	})
}

// find processes by their exact name
func FindByExactName(aname string) (processes []*ProcessInfo) {
	return FindBy(func(process *ProcessInfo) bool {
		return Exact(process, aname)
	})
}

// today is the oldest you've ever been ...
func FindOldestByName(aname string) (oldest *ProcessInfo) {
	min := uint64(0)
	Walk(func(process *ProcessInfo) {
		if !Contains(process, aname) { return }
		if min == 0 || min >= process.relativeStartTime {
			min = process.relativeStartTime
			oldest = process
		}
	}); return
}

// ... and the youngest you'll ever be again
func FindYoungestByName(aname string) (youngest *ProcessInfo) {
	max := uint64(0)
	Walk(func(process *ProcessInfo) {
		if !Contains(process, aname) { return }
		if process.relativeStartTime >= max {
			max = process.relativeStartTime
			youngest = process
		}
	}); return
}

// read from /proc/self/
func Self() (process *ProcessInfo) {
	process = &ProcessInfo{}
	handler, _ := iotool.Open(iotool.ReadOnly(), fmt.Sprintf(PROC_STAT_FILE, "self"))
	process.scanStat(handler); return
}

/***** current user *****/

// find all current users processes
func FindMyAll() (processes []*ProcessInfo) {
	user, e := user.Current(); if e != nil { return }
	return FindBy(func(process *ProcessInfo) bool {
		return User(process, user)
	})
}

// find a process by pid
func FindMy(aid uint64) (process *ProcessInfo, e error) {
	user, e := user.Current(); if e != nil { return }
	process, e = Find(aid); if e != nil { return }
	if !User(process, user) { return }
	return
}

/***** filters *****/

// contains
func Contains(process *ProcessInfo, aname string) bool {
	return strings.Contains(process.name, aname)
}

// exact name
func Exact(process *ProcessInfo, aname string) bool {
	return process.name == aname
}

// user id
func User(process *ProcessInfo, user user.UserInterface) bool {
	return uint32(process.owner) == user.Id()
}
