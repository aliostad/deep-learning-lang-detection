
package runnerd

import (
"io"
	"os/exec"
   "log"
  "os"
)

type ProcessLauncher struct {
  Feedback chan Message
}

func NewProcessLauncher() *ProcessLauncher {
  return &ProcessLauncher{
    Feedback: make(chan Message),
  }
}

func (m *ProcessLauncher) Launch(conf *ProcessConfig) (*Process, error) {
  p := NewProcess(conf, m)
  go p.Run()
  return p, nil
}

type Process struct {
  Config *ProcessConfig
  Master *ProcessLauncher
  ProcessState *os.ProcessState
}

func NewProcess(conf *ProcessConfig, master *ProcessLauncher) *Process {
  return &Process{
    Config: conf,
    Master: master,
    ProcessState: nil,
  }
}

func (p *Process) Run() {
  cmd := exec.Command(p.Config.Command, p.Config.Args...)
  out, _ := cmd.StdoutPipe()
  err, _ := cmd.StderrPipe()
  cmd.Start()
  go p.readPipe(PIPE_STDOUT, out, p.Master.Feedback)
  go p.readPipe(PIPE_STDERR, err, p.Master.Feedback)
  cmd.Wait()
  p.ProcessState = cmd.ProcessState
  p.Master.Feedback <- &ExitMessage{ProcessState: p.ProcessState}
}

func (p *Process) readPipe(name int, r io.ReadCloser, c chan Message) {
  for {
      bs := make([]byte, 2048)
      i, _ := r.Read(bs)
      log.Println("Read", i)
        c <- &PipeMessage{
          Stream: MSG_OUT,
          Body: bs,
        }
  }
}
