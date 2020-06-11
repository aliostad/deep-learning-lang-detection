package main

import "fmt"

func CheckLoad(load *float64) []Check {

	var loadCheck Check

	reason := make(map[string]string)
	if load == nil {
		reason["error"] = "Load check not supported on this plan"
		loadCheck = Check{"Load", "skipped", reason}
	} else if *load > 2 {
		reason["load"] = fmt.Sprintf("%v", *load)
		loadCheck = Check{"Load", "red", reason}
	} else if *load > 1 {
		reason["load"] = fmt.Sprintf("%v", *load)
		loadCheck = Check{"Load", "yellow", reason}
	} else {
		loadCheck = Check{"Load", "green", nil}
	}

	v := make([]Check, 1)
	v[0] = loadCheck

	return v
}
