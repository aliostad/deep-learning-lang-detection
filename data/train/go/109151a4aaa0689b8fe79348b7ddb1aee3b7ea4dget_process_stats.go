package builtin

import (
	"encoding/json"
	"fmt"
	"github.com/g8os/core.base/pm"
	"github.com/g8os/core.base/pm/core"
	"github.com/g8os/core.base/pm/process"
)

const (
	cmdGetProcessStats = "process.state"
)

func init() {
	pm.CmdMap[cmdGetProcessStats] = process.NewInternalProcessFactory(getProcessStats)
}

type getProcessStatsData struct {
	ID string `json:"id"`
}

func getProcessStats(cmd *core.Command) (interface{}, error) {
	//load data
	data := getProcessStatsData{}
	err := json.Unmarshal(*cmd.Arguments, &data)
	if err != nil {
		return nil, err
	}

	stats := make([]*process.ProcessStats, 0, len(pm.GetManager().Runners()))
	var runners []pm.Runner

	if data.ID != "" {
		runner, ok := pm.GetManager().Runners()[data.ID]

		if !ok {
			return nil, fmt.Errorf("Process with id '%s' doesn't exist", data.ID)
		}

		runners = []pm.Runner{runner}
	} else {
		for _, runner := range pm.GetManager().Runners() {
			runners = append(runners, runner)
		}
	}

	for _, runner := range runners {
		process := runner.Process()
		if process == nil {
			continue
		}

		stats = append(stats, process.GetStats())
	}

	return stats, nil
}
