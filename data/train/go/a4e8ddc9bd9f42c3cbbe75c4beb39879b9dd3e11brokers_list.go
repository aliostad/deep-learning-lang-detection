package brokers

import (
	"fmt"
	"os"

	"github.com/eddyzags/kafkactl/api/client"

	"github.com/olekukonko/tablewriter"
)

func List(api client.APIClient, all bool) error {
	brokers, err := api.BrokerList()
	if err != nil {
		return err
	}

	table := tablewriter.NewWriter(os.Stdout)
	table.SetAutoFormatHeaders(false)
	table.SetAutoWrapText(false)
	if all {
		table.SetHeader([]string{"ID", "HOSTNAME", "ACTIVE", "STATE", "CPUS", "MEM", "HEAP", "ENDPOINT"})
		for _, broker := range brokers {
			if broker.Active == true {
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
			} else {
				table.Append([]string{
					broker.ID,
					"n/a",
					fmt.Sprintf("%t", broker.Active),
					"stopped",
					fmt.Sprintf("%g", broker.Cpus),
					fmt.Sprintf("%g", broker.Mem),
					fmt.Sprintf("%g", broker.Heap),
					"n/a",
				})
			}
		}
	} else {
		table.SetHeader([]string{"ID", "HOSTNAME", "STATE", "CPUS", "MEM", "HEAP", "ENDPOINT"})
		for _, broker := range brokers {
			if broker.Active != true {
				continue
			}

			table.Append([]string{
				broker.ID,
				broker.Task.Hostname,
				broker.Task.State,
				fmt.Sprintf("%g", broker.Cpus),
				fmt.Sprintf("%g", broker.Mem),
				fmt.Sprintf("%g", broker.Heap),
				broker.Task.Endpoint,
			})
		}
	}

	table.Render()

	return nil
}
