package main

import (
    "fmt"
    "sort"
    )

type Instrument struct {
    index   int
    days    int
}

type Instruments []Instrument


func (insts Instruments) Len() int {
    return len(insts)
}

func (insts Instruments) Less(i, j int) bool {
    return insts[i].days < insts[j].days
}

func (insts Instruments) Swap(i, j int) {
    insts[i].index, insts[j].index = insts[j].index, insts[i].index
    insts[i].days, insts[j].days = insts[j].days, insts[i].days
}

func main() {
    var n, k int
    fmt.Scan(&n, &k)

    instruments := make([]Instrument, n, n)
    for i := 0; i < n; i++ {
        var day int
        fmt.Scan(&day)
        instruments[i].index = i+1
        instruments[i].days = day
    }

    sort.Sort(Instruments(instruments))
    var i int
    for i = 0; i < n; i++ {
        if instruments[i].days > k {
            break
        }
        k -= instruments[i].days
    }

    fmt.Println(i)
    if i > 0 {
        for j := 0; j < i; j++ {
            fmt.Print(instruments[j].index, " ")
        }
        fmt.Println("")
    }
}

