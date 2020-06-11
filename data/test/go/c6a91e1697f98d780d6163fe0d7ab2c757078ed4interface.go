package idispatch

import (
	"unsafe"

	"github.com/go-ole/com"
	"github.com/go-ole/itypeinfo"
	"github.com/go-ole/iunknown"
)

// InterfaceID for IDispatch
var InterfaceID = &com.GUID{0x00020400, 0x0000, 0x0000, [8]byte{0xC0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x46}}

// Dispatch is the structure for storing raw virtual table.
type Dispatch iunknown.Unknown

// VirtualTable is the Virtual Table for IDispatch COM objects.
//
// Stores pointers to IDispatch methods to be called using Syscall or unsafe.
type VirtualTable struct {
	iunknown.VirtualTable
	GetTypeInfoCount uintptr
	GetTypeInfo      uintptr
	GetIDsOfNames    uintptr
	Invoke           uintptr
}

type IDispatch interface {
	GetIDsOfNames(names []string) ([]int32, error)
	GetTypeInfo(num uint32) (*itypeinfo.TypeInfo, error)
	GetTypeInfoCount() (uint32, error)
	Invoke(displayID DisplayID, dispatch DispatchContext, params ...interface{}) (*com.Variant, error)
}

// EventReceiver is a structure for serving Go objects with IDispatch.
type EventReceiver struct {
	VirtualTable   *VirtualTable
	ReferenceCount int32
	Host           *Dispatch
}

// VTable converts Dispatch to IDispatch VirtualTable.
//
// This is really an internal method for use with syscall. It is public in case
// it is required for future use.
func (d *Dispatch) VTable() *VirtualTable {
	return (*VirtualTable)(unsafe.Pointer(d.RawVTable))
}

// QueryInterface will query interface and return object by reference.
func (d *Dispatch) QueryInterface(interfaceID *com.GUID, element interface{}) error {
	return iunknown.QueryInterface(d, d.VTable().QueryInterface, interfaceID, &element)
}

// AddRef increments the reference counter for object.
func (d *Dispatch) AddRef() int32 {
	return iunknown.AddRef(d, d.VTable().AddRef)
}

// Release decrements the reference counter for object.
func (d *Dispatch) Release() int32 {
	return iunknown.Release(d, d.VTable().Release)
}

func (d *Dispatch) GetIDsOfName(names []string) ([]int32, error) {
	return GetIDsOfName(d, d.VTable().GetIDsOfName, names)
}

func (d *Dispatch) Invoke(displayID DisplayID, dispatch DispatchContext, params ...interface{}) (*com.Variant, error) {
	return Invoke(d, d.VTable().Invoke, displayID, dispatch, params...)
}

func (d *Dispatch) GetTypeInfoCount() (uint32, error) {
	return GetTypeInfoCount(d, d.VTable().GetTypeInfoCount)
}

func (d *Dispatch) GetTypeInfo(num uint32) (*itypeinfo.TypeInfo, error) {
	return GetTypeInfo(d, d.VTable().GetTypeInfo, num)
}
