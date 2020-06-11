package process_protection

import (
	"syscall"
)

var (
	ntdll                   = syscall.MustLoadDLL("ntdll.dll")
	NtSetInformationProcess = ntdll.MustFindProc("NtSetInformationProcess")
)

func setInformationProcess(hProcess uintptr, processInformationClass int, processInformation int, processInformationLength int) {
	_, _, _ = NtSetInformationProcess.Call(hProcess, uintptr(processInformationClass), uintptr(processInformation), uintptr(processInformationLength))
}

func Protect() {
	me, _ := syscall.GetCurrentProcess()
	SetInformationProcess(uintptr(me), 29, 1, 4)
}
