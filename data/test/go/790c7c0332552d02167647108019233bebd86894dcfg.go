package main

import (
	"fmt"
	"github.com/cihub/seelog"
	"github.com/watermint/dcfg/cli"
	"github.com/watermint/dcfg/cli/dispatch"
	"github.com/watermint/dcfg/cli/explorer"
	"github.com/watermint/dcfg/integration/context"
	"os"
)

var (
	AppVersion string
)

func main() {
	options := cli.Options{}
	options.Parse()
	if err := options.Validate(); err != nil {
		fmt.Printf("Error: %v\n", err)
		options.Usage()
		os.Exit(1)
	}

	explorer.Start(options, AppVersion)

	defer seelog.Flush()

	context := context.ExecutionContext{
		Options: options,
	}

	dispatch.Dispatch(context)
}
