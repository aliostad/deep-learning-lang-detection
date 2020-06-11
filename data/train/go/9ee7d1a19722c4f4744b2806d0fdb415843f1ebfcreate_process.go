package create

import (
	"fmt"
	"os"
	"strings"

	"github.com/k82cn/activiti-client/api"
	"github.com/k82cn/activiti-client/cmd"
)

func init() {
	registerCreateCmd("process", &CreateProcessCmd{
		processURL: "runtime/process-instances",
	})
}

type CreateProcessCmd struct {
	processURL string
}

type createProcessRequest struct {
	ProcessDefinitionKey string         `json:"processDefinitionKey"`
	BusinessKey          string         `json:"businessKey"`
	Variables            []api.Variable `json:"variables"`
}

func (c *CreateProcessCmd) Create(args []string) {
	var p api.Process
	req := &createProcessRequest{}

	if len(args) == 0 {
		fmt.Println("The process definition key is required to create process.")
		os.Exit(1)
	}

	req.ProcessDefinitionKey = args[0]

	if len(args) > 1 {
		req.BusinessKey = args[1]
	}

	if len(args) > 2 {
		req.Variables = make([]api.Variable, 0)
		for _, s := range args[2:] {
			str := strings.Split(s, ":")
			if len(str) == 2 {
				req.Variables = append(req.Variables, api.Variable{
					Name:  str[0],
					Scope: "local",
					Type:  "string",
					Value: str[1],
				})
			}
		}
	}

	err := cmd.Client.Post(c.processURL, &req, &p)
	cmd.CheckErr(err, &p)

	fmt.Printf("'%s' was created.\n", p.ID)
}
