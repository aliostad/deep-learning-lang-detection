package cmd

import (
	"fmt"

	"github.com/akerl/pallet/dispatch"

	"github.com/spf13/cobra"
)

func pluginUpgradeRunner(cmd *cobra.Command, args []string) error {
	pluginName := args[0]
	ps, err := dispatch.LoadPluginSet()
	if err != nil {
		return err
	}
	plugin, installed := ps[pluginName]
	if !installed {
		return fmt.Errorf("Plugin not installed")
	}
	return plugin.Upgrade()
}

var pluginUpgradeCmd = &cobra.Command{
	Use:   "upgrade PLUGIN",
	Short: "Upgrade a plugin",
	RunE:  pluginUpgradeRunner,
	Args:  cobra.ExactArgs(1),
}

func init() {
	pluginCmd.AddCommand(pluginUpgradeCmd)
}
