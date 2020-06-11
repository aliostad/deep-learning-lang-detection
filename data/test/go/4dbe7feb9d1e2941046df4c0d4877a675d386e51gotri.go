// Copyright 2011, Bryan Matsuo. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package main
/*
 *  Filename:    gotri.go
 *  Author:      Bryan Matsuo <bmatsuo@soe.ucsc.edu>
 *  Created:     Tue Jul  7 20:13:49 PDT 2011
 *  Description: Simulate a limited resource management problem.
 *  Usage:       gotri [options]
 */
import (
    "os"
    "fmt"
    "flag"
    "sync"
    "time"
    "log"
    "rand"
    "github.com/bmatsuo/dispatch"
    "github.com/bmatsuo/dispatch/queues"
)

var (
    maxswimmers = 10
    fifoDispatch = dispatch.New(maxswimmers)
    swimDispatch = dispatch.NewCustom(maxswimmers, queues.NewPriorityQueue())
    vecDispatch = dispatch.NewCustom(maxswimmers, queues.NewVectorPriorityQueue())
    arrayDispatch = dispatch.NewCustom(maxswimmers, queues.NewArrayPriorityQueue())
    finishLine = new(sync.WaitGroup)
)

type Athlete struct {
    Btime, Stime, Rtime int64
}

func RandomAthlete() Athlete {
    var (
        Btime = rand.Int63n(int64(opt.maxbtime)*1e9)
        Stime = rand.Int63n(int64(opt.maxstime)*1e9)
        Rtime = rand.Int63n(int64(opt.maxrtime)*1e9)
    )
    return Athlete{Btime,Stime,Rtime}
}

func (a Athlete) RunRoutine(i int) func() {
    return func() {
        if opt.verbose{
            log.Printf("On the run %d", i)
        }
        time.Sleep(a.Rtime)
        finishLine.Done()
        if opt.verbose {
            log.Printf("Finished %d", i)
        }
    }
}

func (a Athlete) SwimRoutine(i int) func(int64) {
    return func(id int64) {
        if opt.verbose{
            log.Printf("In the water %d", i)
        }
        time.Sleep(a.Stime)
        var runner = a.RunRoutine(i)
        go runner()
    }
}

func (a Athlete) Priority() float64 {
    return 1/float64(a.Stime + a.Rtime)
}

func (a Athlete) BikeRoutine(i int) func() {
    return func() {
        if opt.verbose {
            log.Printf("On a roll %d", i)
        }
        time.Sleep(a.Btime)
        if opt.usefifo {
            fifoDispatch.Enqueue(&queues.PTask{a.SwimRoutine(i), a.Priority()})
        } else if opt.usevec {
            vecDispatch.Enqueue(&queues.PTask{a.SwimRoutine(i), a.Priority()})
        } else if opt.usearray {
            arrayDispatch.Enqueue(&queues.PTask{a.SwimRoutine(i), a.Priority()})
        } else {
            swimDispatch.Enqueue(&queues.PTask{a.SwimRoutine(i), a.Priority()})
        }
    }
}

func (a Athlete) RunTriathalon(i int) {
    a.BikeRoutine(i)()
}


const (
    stdDelay = 50e3
)

type Options struct {
    numAthletes int
    numSwimmers int
    maxbtime    int
    maxstime    int
    maxrtime    int
    usefifo     bool
    usevec      bool
    usearray    bool
    verbose     bool
}
var opt = Options{}
func SetupFlags() *flag.FlagSet {
    var fs = flag.NewFlagSet("gotri", flag.ExitOnError)
    fs.IntVar(&(opt.numAthletes), "n", 15, "Number of athletes participating.")
    fs.IntVar(&(opt.numSwimmers), "k", 3, "Maximum simultaneous swimmers.")
    fs.IntVar(&(opt.maxbtime), "b", 5, "Max time for a athlete while biking.")
    fs.IntVar(&(opt.maxstime), "s", 5, "Max time for a athlete while swimming.")
    fs.IntVar(&(opt.maxrtime), "r", 5, "Max time for a athlete while running.")
    fs.BoolVar(&(opt.usefifo), "f", false, "Use a FIFO queue instead.")
    fs.BoolVar(&(opt.usevec), "vec", false, "Use a VectorPriorityQueue queue instead.")
    fs.BoolVar(&(opt.usearray), "array", false, "Use a ArrayPriorityQueue queue instead.")
    fs.BoolVar(&(opt.verbose), "v", false, "Verbose program output.")
    return fs
}
func VerifyFlags(fs *flag.FlagSet) {
}
func ParseFlags() {
    var fs = SetupFlags()
    fs.Parse(os.Args[1:])
    VerifyFlags(fs)
}

func main() {
    ParseFlags()

    if opt.usefifo {
        fifoDispatch.MaxGo = opt.numSwimmers
    } else if opt.usevec {
        vecDispatch.MaxGo = opt.numSwimmers
    } else if opt.usearray {
        arrayDispatch.MaxGo = opt.numSwimmers
    } else {
        swimDispatch.MaxGo = opt.numSwimmers
    }
    var n = opt.numAthletes

    var t1 = time.Nanoseconds()
    var athletes = make([]Athlete, n)
    for i := 0 ; i < n ; i++ {
        athletes[i] = RandomAthlete()
    }
    if opt.usefifo {
        go fifoDispatch.Start()
    } else if opt.usevec {
        go vecDispatch.Start()
    } else if opt.usearray {
        go arrayDispatch.Start()
    } else {
        go swimDispatch.Start()
    }
    finishLine.Add(n)
    for i := 0 ; i < n ; i++ {
        go athletes[i].RunTriathalon(i)
    }
    finishLine.Wait()
    var t2 = time.Nanoseconds()

    swimDispatch.Stop()
    fifoDispatch.Stop()
    arrayDispatch.Stop()
    vecDispatch.Stop()

    fmt.Printf("Triathalon finished! [%.03fs]", float64(t2-t1)/1e9)
}
