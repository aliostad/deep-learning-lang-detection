package main

import (
	"fmt"
	"encoding/json"
)

func Task_Load(M *Main, S *State, TD *Task_Data) (bool) {
	Debug("Task_Load:Entered\n")

	var load float64
	switch TD.Policy.Idx {
		case "last1min": load = S.LoadAvg.Last1Min
		case "last5min" : load = S.LoadAvg.Last5Min
		case "last15min" : load = S.LoadAvg.Last15Min
		default: load = S.LoadAvg.Last1Min
	}

	return Task_Load_Generic(M, S, TD, load)
}

func Task_Load_Generic(M *Main, S *State, TD *Task_Data, Load float64) (bool) {

	result, result_from_threshold := Task_Compare_Numbers(TD.Policy.Thresholds, Load, '>')

	if result == "" {

		S.STATE_Hash_All_Clear(TD, "load")

		return false
	}

	jsn, err := json.Marshal(S.LoadAvg)
	if err != nil {
		return false
	}

	mon := S.MON_Gen_Task(result, "load", TD.Policy, fmt.Sprintf("%f > %s", Load, result_from_threshold), string(jsn))

	M.M<-mon

	return true
}
