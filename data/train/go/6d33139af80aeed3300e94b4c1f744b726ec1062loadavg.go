// Copyright 2013, Rick Gibson.  All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// example for proc.LoadAvg
package main

import (
	"fmt"
	"proc"
)

func main() {
	// Declare variable load of proc.LoadAvg type
	var load proc.LoadAvg
	// Get system load average info
	err := load.Get()
	if err != nil {
		fmt.Println(err)
	}
	// Print results
	fmt.Println("1m: ", load.OneMin)
	fmt.Println("5m: ", load.FiveMin)
	fmt.Println("15m: ", load.FifteenMin)
	fmt.Println("Runnable: ", load.Runnable)
	fmt.Println("TotalProcs: ", load.TotalProcs)
	fmt.Println("Last pid: ", load.LastPid)
}
