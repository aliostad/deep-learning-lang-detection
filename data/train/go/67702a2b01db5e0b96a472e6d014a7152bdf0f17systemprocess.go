package process

import (
	"encoding/json"
	"fmt"
	"github.com/Zero-OS/0-Core/base/pm/core"
	"github.com/Zero-OS/0-Core/base/pm/stream"
	psutils "github.com/shirou/gopsutil/process"
	"io"
	"os"
	"os/exec"
	"syscall"
)

type SystemCommandArguments struct {
	Name  string            `json:"name"`
	Dir   string            `json:"dir"`
	Args  []string          `json:"args"`
	Env   map[string]string `json:"env"`
	StdIn string            `json:"stdin"`

	//Only internal commands can sent the NoOutput flag.
	NoOutput bool `json:"-"`
}

type systemProcessImpl struct {
	cmd     *core.Command
	args    SystemCommandArguments
	pid     int
	process *psutils.Process

	table PIDTable
}

func NewSystemProcess(table PIDTable, cmd *core.Command) Process {
	process := &systemProcessImpl{
		cmd:   cmd,
		table: table,
	}

	json.Unmarshal(*cmd.Arguments, &process.args)
	return process
}

func (process *systemProcessImpl) Command() *core.Command {
	return process.cmd
}

//GetStats gets stats of an external process
func (process *systemProcessImpl) Stats() *ProcessStats {
	stats := ProcessStats{}

	defer func() {
		if r := recover(); r != nil {
			log.Warningf("processUtils panic: %s", r)
		}
	}()

	ps := process.process
	if ps == nil {
		return &stats
	}

	cpu, err := ps.Percent(0)
	if err == nil {
		stats.CPU = cpu
	}

	mem, err := ps.MemoryInfo()
	if err == nil {
		stats.RSS = mem.RSS
		stats.VMS = mem.VMS
		stats.Swap = mem.Swap
	}

	stats.Debug = fmt.Sprintf("%d", process.process.Pid)

	return &stats
}

func (process *systemProcessImpl) Signal(sig syscall.Signal) error {
	if process.process != nil {
		//send the signal to the entire process group
		log.Debugf("Signaling process '%v' with %v", process.process.Pid, sig)
		return syscall.Kill(-int(process.process.Pid), sig)
	}

	return fmt.Errorf("process not found")
}

func (process *systemProcessImpl) Run() (<-chan *stream.Message, error) {
	cmd := exec.Command(process.args.Name,
		process.args.Args...)
	cmd.Dir = process.args.Dir

	if len(process.args.Env) > 0 {
		cmd.Env = append(cmd.Env, os.Environ()...)
		for k, v := range process.args.Env {
			cmd.Env = append(cmd.Env, fmt.Sprintf("%v=%v", k, v))
		}
	}

	cmd.SysProcAttr = &syscall.SysProcAttr{
		Setsid: true,
	}

	//preparing pipes for process communication
	var stdout, stderr io.ReadCloser
	var stdin io.WriteCloser
	var err error
	if !process.args.NoOutput {
		stdout, err = cmd.StdoutPipe()
		if err != nil {
			return nil, err
		}

		stderr, err = cmd.StderrPipe()
		if err != nil {
			return nil, err
		}
	}

	if len(process.args.StdIn) != 0 {
		stdin, err = cmd.StdinPipe()
		if err != nil {
			return nil, err
		}
	}

	log.Debugf("system: %s %s %s", cmd.Env, cmd.Path, cmd.Args)

	err = process.table.Register(func() (int, error) {
		err := cmd.Start()
		if err != nil {
			return 0, err
		}

		return cmd.Process.Pid, nil
	})

	if err != nil {
		log.Errorf("Failed to start process(%s): %s", process.cmd.ID, err)
		return nil, err
	}

	channel := make(chan *stream.Message)

	process.pid = cmd.Process.Pid
	psProcess, _ := psutils.NewProcess(int32(process.pid))
	process.process = psProcess

	//preparing streams consumers
	var outConsumer, errConsumer stream.Consumer

	if !process.args.NoOutput {
		msgInterceptor := func(msg *stream.Message) {
			if msg.Level == stream.LevelExitState {
				//the level exit state is for internal use only, shouldn't
				//be sent by the app itself, if found, we change the level to err.
				msg.Level = stream.LevelStderr
			}

			channel <- msg
		}

		// start consuming outputs.
		outConsumer = stream.NewConsumer(stdout, 1)
		outConsumer.Consume(msgInterceptor)

		errConsumer = stream.NewConsumer(stderr, 2)
		errConsumer.Consume(msgInterceptor)
	}

	if len(process.args.StdIn) != 0 {
		//write data to command stdin.
		_, err = stdin.Write([]byte(process.args.StdIn))
		if err != nil {
			log.Errorf("Failed to write to process stdin: %s", err)
		}

		stdin.Close()
	}

	go func(channel chan *stream.Message) {
		//make sure all outputs are closed before waiting for the process
		//to exit.
		defer close(channel)

		if !process.args.NoOutput {
			<-outConsumer.Signal()
			<-errConsumer.Signal()
			stdout.Close()
			stderr.Close()
		}

		state := process.table.WaitPID(process.pid)

		log.Debugf("Process %s exited with state: %d", process.cmd, state.ExitStatus())

		if state.ExitStatus() == 0 {
			channel <- stream.MessageExitSuccess
		} else {
			channel <- stream.MessageExitError
		}
	}(channel)

	return channel, nil
}
