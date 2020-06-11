package main

import (
	"fmt"
	"io"
)

type Process interface {
	Start()
	Kill()
	Signal()
	Pid() int
}

type Proc struct {
	foo string
	pid int
}

func (p *Proc) Start()  {}
func (p *Proc) Kill()   {}
func (p *Proc) Signal() {}
func (p *Proc) Pid() int {
	return p.pid
}

func NewProcess() *Proc {
	return &Proc{"foo", 3}
}

type Daemon struct {
	process *Proc
	w       *io.PipeWriter
}

func (d *Daemon) Run(p Process) {
	d.process = NewProcess()
	_, d.w = io.Pipe()
}

func main() {

	d := &Daemon{}

	fmt.Printf("d.process = %+v\n", d.process)

	fmt.Printf("d.w = %+v\n", d.w)

	d.Run(d.process)

	fmt.Printf("d.w = %+v\n", d.w)
	d.w.Close()

	fmt.Printf("d.process = %+v\n", d.process)
	fmt.Printf("d.process.foo = %+v\n", d.process.foo)

	fmt.Printf("d.process.Pid() = %+v\n", d.process.Pid())
}
