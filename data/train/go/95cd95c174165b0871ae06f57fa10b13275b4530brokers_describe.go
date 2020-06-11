package brokers

import (
	"errors"
	"fmt"
	"os"

	"github.com/eddyzags/kafkactl/api/client"
	"github.com/eddyzags/kafkactl/models"

	"github.com/olekukonko/tablewriter"
)

func Describe(api client.APIClient, brokerID string) error {
	brokers, err := api.BrokerList()
	if err != nil {
		return err
	}

	var broker *models.Broker
	for _, b := range brokers {
		if b.ID == brokerID {
			broker = b
			break
		}
	}

	if broker == nil {
		return errors.New("The broker requested do not exist")
	}

	table := tablewriter.NewWriter(os.Stdout)
	table.SetHeader([]string{"", "Broker Settings"})
	table.SetAlignment(tablewriter.ALIGN_LEFT)
	table.SetBorder(true)
	table.SetAutoFormatHeaders(false)
	table.SetAutoWrapText(false)

	table.Append([]string{"ID:", broker.ID})
	table.Append([]string{"Active:", fmt.Sprintf("%t", broker.Active)})

	table.Append([]string{"", ""})

	table.Append([]string{"Resources ", ""})
	table.Append([]string{"- CPUs:", fmt.Sprintf("%g", broker.Cpus)})
	table.Append([]string{"- Mem:", fmt.Sprintf("%g", broker.Mem)})
	table.Append([]string{"- Heap:", fmt.Sprintf("%g", broker.Heap)})

	table.Append([]string{"", ""})

	table.Append([]string{"Task ", ""})
	table.Append([]string{"- ID:", broker.Task.ID})
	table.Append([]string{"- State:", broker.Task.State})
	table.Append([]string{"- Endpoint:", broker.Task.Endpoint})
	table.Append([]string{"- Hostname:", broker.Task.Hostname})
	table.Append([]string{"- SlaveID:", broker.Task.SlaveID})
	table.Append([]string{"- ExecutorID:", broker.Task.ExecutorID})

	table.Append([]string{"", ""})

	table.Append([]string{"Stickiness ", ""})
	table.Append([]string{"- Hostname:", broker.Stickiness.Hostname})
	table.Append([]string{"- Period:", broker.Stickiness.Period})

	table.Append([]string{"", ""})

	table.Append([]string{"Failover ", ""})
	table.Append([]string{"- Delay:", broker.Failover.Delay})
	table.Append([]string{"- Max delay:", broker.Failover.MaxDelay})
	table.Append([]string{"- Failures:", fmt.Sprintf("%d", broker.Failover.Failures)})
	table.Append([]string{"- Failure time:", broker.Failover.FailureTime})

	table.Render()
	return nil
}
