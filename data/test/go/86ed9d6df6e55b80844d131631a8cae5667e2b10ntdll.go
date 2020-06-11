/* Contains selected Win32 APIs not found in other repos*/

package w32ex

import (
	"syscall"
)

// BOOL WINAPI NtSuspendProcess
//   _In_ HANDLE hProcess,
func NtSuspendProcess(hProcess syscall.Handle) bool {
	ntdll, _ := syscall.LoadLibrary("ntdll.dll")
	ntSuspendProcess, _ := syscall.GetProcAddress(ntdll, "NtSuspendProcess")
	ret, _, _ := syscall.Syscall(ntSuspendProcess, 1,
		uintptr(hProcess),
		0,
		0)
	return ret == 0
}

// BOOL WINAPI NtResumeProcess
//   _In_ HANDLE hProcess,
func NtResumeProcess(hProcess syscall.Handle) bool {
	ntdll, _ := syscall.LoadLibrary("ntdll.dll")
	ntResumeProcess, _ := syscall.GetProcAddress(ntdll, "NtResumeProcess")
	ret, _, _ := syscall.Syscall(ntResumeProcess, 1,
		uintptr(hProcess),
		0,
		0)
	return ret == 0
}
