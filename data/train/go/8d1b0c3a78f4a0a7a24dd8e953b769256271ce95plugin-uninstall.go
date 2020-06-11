package cmd

import (
	"fmt"

	"github.com/akerl/pallet/dispatch"

	"github.com/spf13/cobra"
)

func pluginUninstallRunner(cmd *cobra.Command, args []string) error {
	pluginName := args[0]
	ps, err := dispatch.LoadPluginSet()
	if err != nil {
		return err
	}
	plugin, installed := ps[pluginName]
	if !installed {
		return fmt.Errorf("Plugin not installed")
	}
	return plugin.Uninstall()
}

var pluginUninstallCmd = &cobra.Command{
	Use:   "uninstall PLUGIN",
	Short: "Uninstall a new plugin",
	RunE:  pluginUninstallRunner,
	Args:  cobra.ExactArgs(1),
}

func init() {
	pluginCmd.AddCommand(pluginUninstallCmd)
}
