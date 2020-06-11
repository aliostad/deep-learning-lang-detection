// Copyright 2011, Bryan Matsuo. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.
/*
 *  Filename:    dispatch.go
 *  Author:      Bryan Matsuo <bmatsuo@soe.ucsc.edu>
 *  Created:     Tue Jul  5 22:13:49 PDT 2011
 *  Description: Defines the Dispatch type and methods.
 */

//  Package dispatch provides goroutine dispatch and concurrency limiting.
//  It provides an object Dispatch which is a queueing system for concurrent
//  functions. It implements a dynamic limit on the number of routines that
//  it runs simultaneously. It also uses a Queue interface, allowing for
//  alternate queue implementations.
//
//  See github.com/bmatsuo/dispatch/queues for more about the Queue
//  interface and, a list of commonly used queues.
//
//  See github.com/bmatsuo/dispatch/examples for usage examples.
package dispatch

import (
    "sync"
    //"log"
    "github.com/bmatsuo/dispatch/queues"
)

//  A Dispatch is an automated function dispatch queue with a limited
//  number of concurrent gorountines. The queue can be altered with the
//  Dispatch methods Enqueue and SetKey (TODO add method Remove).
type Dispatch struct {
    // The maximum number of goroutines can be changed while the queue is
    // processing.
    MaxGo int

    // Handle waiting when the limit of concurrent goroutines has been reached.
    waitingToRun bool
    nextWait     *sync.WaitGroup

    // Handle waiting when function queue is empty.
    waitingOnQ bool
    restart    *sync.WaitGroup

    // Manage the Start()'ing of a Dispatch, avoiding race conditions.
    startLock *sync.Mutex
    started   bool

    // Handle goroutine-safe queue operations.
    qLock *sync.Mutex
    queue queues.Queue

    // Handle goroutine-safe limiting and identifier operations.
    pLock      *sync.Mutex
    processing int   // Number of QueueTasks running
    idcount    int64 // pid counter

    // The longest the dispatch queue grew.
    maxlength int

    // Handle stopping of the Start() method.
    kill chan bool
}

//  Create a new Dispatch object with a specified limit on concurrency.
func New(maxroutines int) *Dispatch {
    return NewCustom(maxroutines, queues.NewFIFO())
}

//  Create a new Dispatch object with a custom backend queue satisfying
//  interface queues.Queue. It is not safe to allow non-Dispatch methods
//  any access to the object queue. This can lead to race conditions with
//  possible corruption of internal structures. So, it's considered a best
//  practice to only pass NewCustom(...) newly created queues.
//      fifoDispatch     := NewCustom(10, queues.NewFIFO())
//      priorityDispatch := NewCustom(20, queues.NewPriorityQueue())
func NewCustom(maxroutines int, queue queues.Queue) *Dispatch {
    var d = new(Dispatch)
    d.startLock = new(sync.Mutex)
    d.qLock = new(sync.Mutex)
    d.pLock = new(sync.Mutex)
    d.restart = new(sync.WaitGroup)
    d.kill = make(chan bool)
    d.nextWait = new(sync.WaitGroup)
    d.queue = queue
    d.MaxGo = maxroutines
    d.idcount = 0
    d.maxlength = 0
    return d
}

//  A simple task for use in a priority-less queue. See package
//  github.com/bmatsuo/dispatch/queues
type StdTask struct {
    F func(id int64)
}

//  Return the pointer to a newly allocated StdTask.
func NewTask(f func(int64)) *StdTask {
    t := new(StdTask)
    t.F = f
    return t
}

//  Returns "StdTask" for the queues.Task interface.
func (dt *StdTask) Type() string {
    return "StdTask"
}

//  Function modifier method for the queues.Task interface.
func (dt *StdTask) SetFunc(f func(id int64)) {
    dt.F = f
}
//  Function modifier method for the queues.Task interface.
func (dt *StdTask) Func() func(id int64) {
    return dt.F
}

//  A simple struct combining a Task with a unique dispatch id.
type dispatchTaskWrapper struct {
    id  int64
    t   queues.Task
}

//  Accessor for the contained Task's function.
func (dtw dispatchTaskWrapper) Func() func(id int64) {
    return dtw.t.Func()
}

//  Accessor for the Task's unique dispatch id.
func (dtw dispatchTaskWrapper) Id() int64 {
    return dtw.id
}

//  Accessor for the contained Task object itself.
func (dtw dispatchTaskWrapper) Task() queues.Task {
    return dtw.t
}

//  Returns the current length of the Dispatch object's queue.
func (gq *Dispatch) Len() int {
    return gq.queue.Len()
}
//  Returns the maximum length attained by the Dispatch object's queue.
func (gq *Dispatch) MaxLen() int {
    return gq.maxlength
}

//  Enqueue a task for execution as a goroutine. The given queues.Task is
//  given a unique id (int64) and stored in the Dispatch gq's backend
//  queues.Queue object.
func (gq *Dispatch) Enqueue(t queues.Task) int64 {
    // Wrap the function so it works with the goroutine limiting code.
    var f = t.Func()
    var dtFunc = func(id int64) {
        // Run the given function.
        f(id)

        // Decrement the process counter.
        gq.pLock.Lock()
        //log.Printf("processing: %d, waiting: %v", gq.processing, gq.waitingToRun)
        gq.processing--
        if gq.waitingToRun {
            gq.waitingToRun = false
            gq.nextWait.Done()
        }
        gq.pLock.Unlock()
    }
    t.SetFunc(dtFunc)

    // Lock the queue and enqueue a new task.
    gq.qLock.Lock()
    gq.idcount++
    var id = gq.idcount
    gq.queue.Enqueue(dispatchTaskWrapper{id, t})
    if gq.waitingOnQ {
        gq.waitingOnQ = false
        gq.restart.Done()
    }
    if gq.queue.Len() > gq.maxlength {
        gq.maxlength = gq.queue.Len()
    }
    gq.qLock.Unlock()

    return id
}

//  Stop the queue after gq.Start() has been called. Any goroutines which
//  have not already been dequeued will not be executed until gq.Start()
//  is called again.
func (gq *Dispatch) Stop() {
    // Lock out Start() and queue ops for the entire call.
    gq.startLock.Lock()
    defer gq.startLock.Unlock()
    gq.qLock.Lock()
    defer gq.qLock.Unlock()

    if !gq.started {
        return
    }

    // Clear channel flags and close channels, stoping further processing.
    close(gq.kill)
    gq.started = false
    if gq.waitingOnQ {
        gq.waitingOnQ = false
        gq.restart.Done()
    }
    if gq.waitingToRun {
        gq.waitingToRun = false
        gq.nextWait.Done()
    }
}

//  Start the next task in the queue. It's assumed that the queue is non-
//  empty. Furthermore, there should only be one goroutine in this method
//  (for this object) at a time. Both conditions are enforced in
//  gq.Start(), which calls gq.next() exclusively.
func (gq *Dispatch) next() {
    for true {
        // Attempt to start processing the file.
        gq.pLock.Lock()
        if gq.processing >= gq.MaxGo {
            gq.waitingToRun = true
            gq.nextWait.Add(1)
            gq.pLock.Unlock()
            gq.nextWait.Wait()
            continue
        }
        // Keep the books and reset wait time before unlocking.
        gq.processing++
        gq.pLock.Unlock()

        // Get an element from the queue.
        gq.qLock.Lock()
        var wrapper = gq.queue.Dequeue().(queues.RegisteredTask)
        gq.qLock.Unlock()

        // Begin processing and asyncronously return.
        //var task = taskelm.Value.(dispatchTaskWrapper)
        var task = wrapper.Func()
        go task(wrapper.Id())
        return
    }
}

//  Start executing goroutines. Don't stop until gq.Stop() is called. This
//  method will take control of the calling thread. But, it's safe to call
//  in a goroutine.
//      gq := dispatch.New()
//      go gq.Start()
//      wg := new(sync.WaitGroup)
//      for i := 0 ; i < 1000 ; i++ {
//          wg.Add(1)
//          gq.Enqueue(dispatch.NewTask(
//              func(id int64) {
//                  log.Printf("I'm alive %d", i)
//                  wg.Done()
//              } ) )
//      }
//      wg.Wait()
//      gq.Stop()
func (gq *Dispatch) Start() {
    // Avoid multiple gq.Start() methods and avoid race conditions.
    gq.startLock.Lock()
    if gq.started {
        panic("already started")
    }
    gq.started = true
    gq.startLock.Unlock()

    // Recreate any channels that were closed by a previous Stop().
    var inited = false
    for !inited {
        select {
        case _, okKill := <-gq.kill:
            if !okKill {
                gq.kill = make(chan bool)
            }
        default:
            inited = true
        }
    }

    // Process the queue
    for true {
        select {
        case die, ok := <-gq.kill:
            // If something came out of this channel, we must stop.
            if !ok {
                // Recreate the channel.
                gq.kill = make(chan bool)
                return
            }
            if die {
                return
            }
        default:
            // Check the queue size and determine if we need to wait.
            gq.qLock.Lock()
            var wait = gq.queue.Len() == 0
            if gq.waitingOnQ = wait; wait {
                gq.restart.Add(1)
            }
            gq.qLock.Unlock()

            if wait {
                // Wait for a restart signal from gq.Enqueue
                gq.restart.Wait()
            } else {
                // Process the head of the queue and start the loop again.
                gq.next()
                continue
            }
        }
    }
}
