package cmd

import (
	"fmt"
	"os"

	"github.com/akerl/pallet/dispatch"

	"github.com/spf13/cobra"
)

var rootCmd = &cobra.Command{
	Use:               "pallet",
	Short:             "Manage multiple versions of tools",
	SilenceUsage:      true,
	SilenceErrors:     true,
	PersistentPreRunE: loadConfig,
}

// Execute function is the entrypoint for the CLI
func Execute() {
	if err := rootCmd.Execute(); err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}
}

func loadConfig(cmd *cobra.Command, args []string) error {
	return dispatch.LoadConfig()
}
