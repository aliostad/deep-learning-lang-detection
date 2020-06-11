package main

import "errors"
import "runtime"

//main dicom message dispatcher
type DDisp struct {
	dCln DClient
}

func (dsp *DDisp) Dispatch(dreq interface{}) (interface{}, error) {
	runtime.LockOSThread()
	defer runtime.UnlockOSThread()
	switch tr := dreq.(type) {
	case CGetReq:
		return dsp.dCln.CGet(tr)
	case CStorReq:
		return dsp.dCln.CStore(tr)
	case EchoReq:
		return dsp.dCln.CEcho(tr)
	case FindReq:
		return dsp.dCln.CFind(tr)
	}
	return nil, errors.New("error: can't dispatch non dicom request type")

}
