package cli

import (
	"fmt"
)

type Command struct {
	Name        string
	Description string
	Dispatcher  CommandDispatcher
}

type CommandDispatcher interface {
	Dispatch(name string, arguments []string) error
}

type CommandDispatchError string

func (e CommandDispatchError) Error() string {
	return string(e)
}

type CommandDispatchFunction func(name string, arguments []string) error

func (f CommandDispatchFunction) Dispatch(name string, arguments []string) error {
	return f(name, arguments)
}

func DispatchCommand(commands []Command, arguments []string, name string) error {
	if len(arguments) == 0 {
		return CommandDispatchError("no command specified")
	}

	for _, command := range commands {
		if command.Name == arguments[0] {
			if command.Dispatcher != nil {
				return command.Dispatcher.Dispatch(name+" "+command.Name, arguments[1:])
			} else {
				panic(fmt.Sprintf("missing dispatcher for command '%s'", command.Name))
			}
		}
	}

	return CommandDispatchError(fmt.Sprintf("no such command: '%s'", arguments[0]))
}
