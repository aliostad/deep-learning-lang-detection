package process

//Implementation based on: https://github.com/mitchellh/go-ps/blob/master/process_windows.go

import (
	"errors"
	"strconv"
	"strings"
	"syscall"
	"unsafe"
)

//Windows API Constants
const (
	MAX_PATH  = 260
	WIN_TRUE  = 1
	WIN_FALSE = 0

	TH32CS_SNAPPROCESS uintptr = 0x00000002 //Include all processes
	TH32CS_SNAPTHREAD  uintptr = 0x00000004 //Include all Threads

	//Return values
	INVALID_HANDLE_VALUE uintptr = 0xFFFFFFFF //-1
)

//Windows specific process entry
type windowsProcess struct {
	Size            uint32
	CntUsage        uint32
	ProcessID       uint32
	DefaultHeapID   uintptr
	ModuleID        uint32
	CntThreads      uint32
	ParentProcessID uint32
	PriClassBase    int32
	Flags           uint32
	ExeFile         [MAX_PATH]uint16 //16 bit Unicode
}

type processManager struct {
	kernel32 syscall.LazyDLL

	createToolhelp32Snapshot *syscall.LazyProc
	process32First           *syscall.LazyProc
	process32Next            *syscall.LazyProc
	closeHandle              *syscall.LazyProc
}

func NewProcessManager() ProcessManager {
	manager := new(processManager)

	manager.kernel32 = *syscall.NewLazyDLL("kernel32.dll")
	manager.createToolhelp32Snapshot = manager.kernel32.NewProc("CreateToolhelp32Snapshot")
	manager.process32First = manager.kernel32.NewProc("Process32FirstW") //Unicode version
	manager.process32Next = manager.kernel32.NewProc("Process32NextW")
	manager.closeHandle = manager.kernel32.NewProc("CloseHandle")

	return manager
}

func processFromWindowsProcess(entry *windowsProcess) (Process, error) {
	process := new(process)

	process.id = entry.ProcessID
	process.parentId = entry.ParentProcessID

	index := 0
	for {
		if entry.ExeFile[index] == 0 {
			break
		}
		index++
		if index == MAX_PATH {
			return nil, errors.New("Name is corrupt or too long for process: " + strconv.FormatUint(uint64(process.id), 10))
		}
	}
	exePath := syscall.UTF16ToString(entry.ExeFile[:index])

	process.name = exePath
	process.executablePath = exePath

	return process, nil
}

func (manager *processManager) ListProcesses() ([]Process, error) {
	//Get handle to Snapshot
	handle, _, lastErr := manager.createToolhelp32Snapshot.Call(TH32CS_SNAPPROCESS, 0)
	if handle == INVALID_HANDLE_VALUE {
		return nil, lastErr
	}
	defer manager.closeHandle.Call(handle) //Always close the handle

	//Get first entry
	var entry windowsProcess
	entry.Size = uint32(unsafe.Sizeof(entry))
	result, _, lastErr := manager.process32First.Call(handle, uintptr(unsafe.Pointer(&entry)))
	if result == WIN_FALSE {
		return nil, lastErr
	}

	entryList := make([]Process, 0)
	for {
		newProcess, err := processFromWindowsProcess(&entry)
		if err != nil {
			return nil, err
		}

		entryList = append(entryList, newProcess)

		result, _, lastErr = manager.process32Next.Call(handle, uintptr(unsafe.Pointer(&entry)))
		if result == WIN_FALSE {
			break //Either an error, or reached the end
		}
	}

	return entryList, nil
}

func (manager *processManager) ListJavaProcesses() ([]Process, error) {
	processList, err := manager.ListProcesses()
	if err != nil {
		return nil, err
	}

	javaList := make([]Process, 0)
	for _, process := range processList {
		processName := strings.ToLower(process.GetName())
		if processName == "java.exe" || processName == "javaw.exe" {
			javaList = append(javaList, process)
		}
	}

	return javaList, nil
}
