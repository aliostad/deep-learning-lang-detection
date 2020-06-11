package main


import (
	"syscall"
	"unsafe"
)

var (
	modKernel32                 = syscall.NewLazyDLL("kernel32.dll")
	readProcessMemory 			= syscall.NewProc("ReadProcessMemory")
	writeProcessMemory 			= syscall.NewProc("WriteProcessMemory")
)




/**
 * Reads the memory from 'process', starting at 'address' up to 'address + size'.
 * Outputs into 'buffer'.
 */
func ReadProcessMemory(process PROCESSENTRY32, address uintptr, buffer *[]byte, size int) {
	readProcessMemory.Call(
			process,
			address,
			buffer,
			size
		)

}
