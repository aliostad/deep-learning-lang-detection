package integration

import (
	"os"
	"path/filepath"
)

func NewWorker() (*Worker, error) {
	p, err := newWorkerProcess()
	if err != nil {
		return nil, err
	}
	return &Worker{process: p}, nil
}

func newWorkerProcess() (*os.Process, error) {
	bin := "wandler-worker"
	path := filepath.Join(__dirname, "../../bin/", bin)
	return os.StartProcess(path, []string{bin}, &os.ProcAttr{
		Files: []*os.File{os.Stdin, os.Stdout, os.Stderr},
	})
}

type Worker struct {
	process *os.Process
}

func (s *Worker) Kill() error {
	s.process.Signal(os.Interrupt)
	_, err := s.process.Wait()
	return err
}
