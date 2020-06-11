package brokers

import (
	"fmt"
	"os"

	"github.com/eddyzags/kafkactl/api/client"

	"github.com/olekukonko/tablewriter"
)

func Start(api client.APIClient, expr, timeout string) error {
	brokers, err := api.BrokerStart(expr, timeout)
	if err != nil {
		return err
	}

	fmt.Printf("The \"%s\" broker(s) were started successfully\n", expr)

	table := tablewriter.NewWriter(os.Stdout)
	table.SetAutoFormatHeaders(false)
	table.SetAutoWrapText(false)
	table.SetHeader([]string{"ID", "HOSTNAME", "ACTIVE", "STATE", "CPUS", "MEM", "HEAP", "ENDPOINT"})

	for _, broker := range brokers {
		table.Append([]string{
			broker.ID,
			broker.Task.Hostname,
			fmt.Sprintf("%t", broker.Active),
			broker.Task.State,
			fmt.Sprintf("%g", broker.Cpus),
			fmt.Sprintf("%g", broker.Mem),
			fmt.Sprintf("%g", broker.Heap),
			broker.Task.Endpoint,
		})
	}

	table.Render()

	return nil
}
