package process

import (
	"github.com/whosonfirst/go-whosonfirst-log"
	"github.com/whosonfirst/go-whosonfirst-updated"
	"strings"
)

type NullProcess struct {
	Process
	data_root string
	logger    *log.WOFLogger
}

func NewNullProcess(data_root string, logger *log.WOFLogger) (*NullProcess, error) {

	pr := NullProcess{
		data_root: data_root,
		logger:    logger,
	}

	return &pr, nil
}

func (pr *NullProcess) Name() string {
	return "null"
}

func (pr *NullProcess) Flush() error {
	return nil
}

func (pr *NullProcess) ProcessTask(task updated.UpdateTask) error {

	pr.logger.Info("process task repo: %s hash: %s files: %s", task.Repo, task.Hash, strings.Join(task.Commits, ";"))
	return nil
}
