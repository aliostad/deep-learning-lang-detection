package safearray

import (
	"github.com/go-ole/com"
	"github.com/go-ole/idispatch"
	"github.com/go-ole/iunknown"
)

// This tests more than one function. It tests all of the functions needed in
// order to retrieve a SafeArray populated with Strings.
func ExampleGetElementString_quickbooks() {
	com.CoInitialize()
	defer com.CoUninitialize()

	clsid, err := com.ClassIDFromProgramID("QBXMLRP2.RequestProcessor.1")
	if err != nil {
		if err.(*com.OleError).Code() == com.COMObjectClassStringErrorCode {
			return
		}
		t.Log(err)
		t.FailNow()
	}

	var unknown *iunknown.Unknown
	var dispatch *idispatch.Dispatch

	err := com.CoCreateInstance(clsid, iunknown.InterfaceID, &unknown)
	if err != nil {
		return
	}
	defer unknown.Release()

	err := unknown.QueryInterface(idispatch.InterfaceID, &dispatch)
	if err != nil {
		return
	}

	var result *com.Variant
	_, err = idispatch.CallMethod(dispatch, "OpenConnection2", "", "Test Application 1", 1)
	if err != nil {
		return
	}

	result, err = idispatch.CallMethod(dispatch, "BeginSession", "", 2)
	if err != nil {
		return
	}

	ticket := result.ToString()

	result, err = idispatch.GetProperty(dispatch, "QBXMLVersionsForSession", ticket)
	if err != nil {
		return
	}

	//
	// Example begins.
	//

	var qbXMLVersions *COMArray
	var qbXMLVersionStrings []string
	qbXMLVersions = result.ToArray().Array

	// Release Safe Array memory
	defer Destroy(qbXMLVersions)

	// Get array bounds
	var LowerBounds int64
	var UpperBounds int64
	LowerBounds, err = GetLowerBound(qbXMLVersions, 1)
	if err != nil {
		return
	}

	UpperBounds, err = GetUpperBound(qbXMLVersions, 1)
	if err != nil {
		return
	}

	totalElements := UpperBounds - LowerBounds + 1
	qbXMLVersionStrings = make([]string, totalElements)

	for i := int64(0); i < totalElements; i++ {
		qbXMLVersionStrings[int32(i)], _ = GetElementString(qbXMLVersions, i)
	}

	//
	// Example ends.
	//

	result, err = idispatch.CallMethod(dispatch, "EndSession", ticket)
	if err != nil {
		return
	}

	result, err = idispatch.CallMethod(dispatch, "CloseConnection")
	if err != nil {
		return
	}
}
