//
//  2016 October 13
//  John Gilliland [john.gilliland@rndgroup.com]
//  contracts package
//

// Package contracts is for shared interfaces that are used across
// the automation implementation.
package contracts

// InstrumentProvider interface definition exposes the api for an instrument.
// Currently we only have one provider and that is for the Hamilton STAR/let.
type InstrumentProvider interface {
	LoadMethod(pathToFiles string) (bool, error)
	Abort() (bool, error)
	Pause() (bool, error)
	Start() (bool, error)
	Resume() (bool, error)
	GetLastError() error
}

// ErrorInfo is the container for error information parsed from instrument firmware.
type ErrorInfo struct {
	Description string
	GUID        string
	Source      string
}

// CarrierActionResult is the complex return type for a load or unload carrier call.
type CarrierActionResult struct {
	CarrierBarcodes []string
	ItemBarcodes    []string
	Result          bool
}

// CarrierActionResultCode is defined to enumerate the possible results from a carrier action.
type CarrierActionResultCode int16

// Possible result code values for carrier actions.
const (
	FailedGeneralError CarrierActionResultCode = 1 + iota
	FailedHardwareError
	FailedNoCarrier
	FailedNotConnected
	FailedWrongCarrier
	Success
)

// MethodState is defined to enumerate the possible states of method execution for the instrument.
type MethodState int16

// Possible states for the instrument execution.
const (
	Aborted = 1 + iota
	Completed
	Error
	Initialized
	NotInitialized
	Running
	Terminated
	Unknown
)

var methodStates = []string {
	"Aborted",
	"Completed",
	"Error",
	"Initialized",
	"NotInitialized",
	"Running",
	"Terminated",
	"Unknown",
}

func (ms MethodState) String() string { 
	return methodStates[ms-1] 
}
