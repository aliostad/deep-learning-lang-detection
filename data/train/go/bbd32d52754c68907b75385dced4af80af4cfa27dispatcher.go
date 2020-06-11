package main

import (
	"fmt"
	"os"

	"github.com/sparkymat/resty/args"
	"github.com/sparkymat/resty/model"
)

func dispatchCommand(command string, commandArgs []string) {
	switch command {
	case "help":
		args.PrintHelp()
		os.Exit(0)
	case "generate":
		if len(commandArgs) < 2 {
			fmt.Fprintf(os.Stderr, "Error: Not enough arguments to call 'generate'\n")
			os.Exit(1)
		}
		dispatchGenerate(commandArgs[0], commandArgs[1:])
		break
	default:
		fmt.Fprintf(os.Stderr, "Error: Invalid command\n")
		os.Exit(1)
	}
}

func dispatchGenerate(objectType string, commandArgs []string) {
	switch objectType {
	case "model":
		model.Generate(commandArgs)
		break
	default:
		fmt.Fprintf(os.Stderr, "Error: Generating %v is not supported\n", objectType)
		os.Exit(1)
	}
}
