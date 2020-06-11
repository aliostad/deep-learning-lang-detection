package processcache

import (
    "golang.org/x/sys/windows"
	"sync"
    "time"
	"unsafe"
	"log"
)
type processEntry struct {
    pe windows.ProcessEntry32
    name string
}
var processMap map[uint64]*processEntry
var processMapLock sync.RWMutex

func init()  {
    processMap = make(map[uint64]*processEntry)
    tckr := time.NewTicker(time.Second * 5)
    go func (t *time.Ticker)  {
        for _ = range t.C {
            updateProcessMap()
        }
    } (tckr)
}

func updateProcessMap() {
    processMapLock.Lock()
    defer processMapLock.Unlock()
    processMap = make(map[uint64]*processEntry)
    handle, err := windows.CreateToolhelp32Snapshot(windows.TH32CS_SNAPPROCESS, 0)
    if err != nil {
        log.Println(err)
        return
    }
    var pe windows.ProcessEntry32
    pe.Size = uint32(unsafe.Sizeof(pe))
    err = windows.Process32First(handle, &pe)
    for err == nil {
        processMap[uint64(pe.ProcessID)] = &processEntry{ 
            pe: pe,
            name: windows.UTF16ToString(pe.ExeFile[:]),
        }

        pe.Size= uint32(unsafe.Sizeof(pe))
        err = windows.Process32Next(handle, &pe)
    }
}

//ProcessNameByID returs the name of the process image or an empty string if the process is not found
func ProcessNameByID(processID uint64) string {
    processMapLock.RLock()
    entry, ok := processMap[processID]
    processMapLock.RUnlock()
    if !ok {
        updateProcessMap()
        processMapLock.RLock()
        entry = processMap[processID]
        processMapLock.RUnlock()
    }
    if entry != nil {
        return entry.name
    }
    return ""
}
