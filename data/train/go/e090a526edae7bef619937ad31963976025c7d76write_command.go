package main

import (
	"github.com/c-fs/cfs/client"
	"github.com/qiniu/log"
	"github.com/spf13/cobra"
	"golang.org/x/net/context"
)

var (
	writeName   string
	writeData   string
	writeOffset int64
	writeAppend bool
)

var writeCmd = &cobra.Command{
	Use:   "write",
	Short: "write data to a cfs node",
	Long:  "",
	Run: func(cmd *cobra.Command, args []string) {
		c := setUpClient()
		defer c.Close()

		handleWrite(context.TODO(), c)
	},
}

func init() {
	writeCmd.PersistentFlags().StringVarP(&writeName, "name", "n", "", "write name")
	writeCmd.PersistentFlags().Int64VarP(&writeOffset, "offset", "o", 0, "write offset")
	writeCmd.PersistentFlags().StringVarP(&writeData, "data", "d", "", "write data")
	writeCmd.PersistentFlags().BoolVarP(&writeAppend, "append", "a", false, "is append")
}

func handleWrite(ctx context.Context, c *client.Client) error {
	n, err := c.Write(ctx, writeName, writeOffset, []byte(writeData), writeAppend)
	if err != nil {
		log.Fatalf("Write err (%v)", err)
	}
	log.Infof("%d bytes written to %s at offset %d", n, writeName, writeOffset)

	return nil
}
