package main

import (
	"fmt"
	"sort"
)

type Instrument struct {
	id int
	v  int
}

type Instruments []Instrument

func (ins Instruments) Len() int {
	return len(ins)
}

func (ins Instruments) Less(i, j int) bool {
	return ins[i].v < ins[j].v
}

func (ins Instruments) Swap(i, j int) {
	ins[i].v, ins[j].v = ins[j].v, ins[i].v
	ins[i].id, ins[j].id = ins[j].id, ins[i].id
}

func main() {
	var n, k int
	fmt.Scan(&n, &k)

	var ins Instruments
	ins = make([]Instrument, n)
	for i := 0; i < n; i++ {
		fmt.Scan(&ins[i].v)
		ins[i].id = i + 1
	}

	sort.Sort(ins)

	i := 0
	for ; i < n && k >= ins[i].v; i++ {
		k -= ins[i].v
	}

	fmt.Println(i)
	for j := 0; j < i; j++ {
		fmt.Printf("%d ", ins[j].id)
	}
}
