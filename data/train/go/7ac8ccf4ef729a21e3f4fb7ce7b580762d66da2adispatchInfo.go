package ftpCalc

import "dbobj"

type dispatchInfo struct {
	InputStr  string
	OutputStr string
}

func (this *dispatchInfo) get(dispatch_id string, domain_id string) (string, string, error) {

	row := dbobj.Default.QueryRow(FTPCALC_DISPATCHINFO, domain_id, dispatch_id)
	var InputStr string
	var OouputStr string
	err := row.Scan(&InputStr, &OouputStr)
	return InputStr, OouputStr, err
}

func initDispatch(dispatch_id string, domain_id string) (string, string, error) {
	r := new(dispatchInfo)
	return r.get(dispatch_id, domain_id)
}
