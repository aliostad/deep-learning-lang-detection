/*program to demonstrate interfaces and dynamic method dispatch */

package main

import (
	"fmt"
)

type addn interface {
	add() int
}

type Vertex struct {
	X, Y float64
}


type integer int


func main() {
	var a addn
	f := integer(-2)
    g := Vertex{2,2}
	
	a = f  /* integer receiver for the method*/
    a = &g  /* pointer receiver for method*/
	fmt.Println(a.add())  /*calls function 2 due to dynamic method dispatch*/
}

func (f integer) add() int {  /*function 1 */
	if f < 0 {
		return int(-f+f)
	}
	return int(f)
}

func (v *Vertex) add() int {    /*function 2 */
	return int(v.X + v.Y)
}
