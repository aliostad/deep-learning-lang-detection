package cmd

import (
	"fmt"

	"github.com/akerl/pallet/dispatch"

	"github.com/spf13/cobra"
)

func pluginListRunner(cmd *cobra.Command, args []string) error {
	ps, err := dispatch.LoadPluginSet()
	if err != nil {
		return err
	}
	for name, plugin := range ps {
		fmt.Printf("%s %s\n", name, plugin.URL)
	}
	return nil
}

var pluginListCmd = &cobra.Command{
	Use:   "list",
	Short: "List installed language plugins",
	RunE:  pluginListRunner,
	Args:  cobra.NoArgs,
}

func init() {
	pluginCmd.AddCommand(pluginListCmd)
}
