package obeah

import (
	"bitbucket.org/bestchai/dinv/programslicer"
	"fmt"
	"testing"
)

const ifSourcePre = `
package main
func main() {
	a := 1
	if a < 2 {
		a = 5
	} else {
		a = 6
	}
}`

const ifSourcePost = `
package main
include "github.com/wantonsolutions/obeah/obeah"

func main() {
	a := 1
	if a < 2 {
		obeah.Log("A")
		a = 5
	} else {
		obeah.Log("B")
		a = 6
	}
}`

const forSourcePre = `
package main
func main() {
	a := 1
	for i:= 0;i<20;i++{
		a += i
	}
}`

const forSourcePost = `
package main
func main() {
	a := 1
	for i:= 0;i<20;i++{
		obeah.log("A")
		a += i
	}
}`

const switchSourcePre = `
package main
func main() {
	a := 1
	switch a {
	case 1:
		break
	case 2:
		break
	case 3:
		break
	default:
		break
	}
}`

const switchSourcePost = `
package main
func main() {
	a := 1
	switch a {
	case 1:
		break
	case 2:
		break
	case 3:
		break
	default:
		break
	}
}`

func TestIfInstrument(t *testing.T) {
	program, err := programslicer.GetWrapperFromString(ifSourcePre)
	if err != nil {
		t.Error(err)
	}
	postSource := InstrumentSource(program.Fset, program.Packages[0].Sources[0].Comments)
	fmt.Println(postSource)
}

func TestForInstrument(t *testing.T) {
	program, err := programslicer.GetWrapperFromString(forSourcePre)
	if err != nil {
		t.Error(err)
	}
	postSource := InstrumentSource(program.Fset, program.Packages[0].Sources[0].Comments)
	fmt.Println(postSource)
}

func TestSwitchInstrument(t *testing.T) {
	program, err := programslicer.GetWrapperFromString(switchSourcePre)
	if err != nil {
		t.Error(err)
	}
	postSource := InstrumentSource(program.Fset, program.Packages[0].Sources[0].Comments)
	fmt.Println(postSource)
}
