package main

import (
	"errors"
	"fmt"
)

// Checks for dublicates. We can't have multiple processes with the same name, as we then
// can't build a dependency tree
func ValidateNoDuplicates(processes []*Process) error {
	for index, process := range processes {
		for innerIndex, innerProcess := range processes {
			if innerIndex > index {
				if process.Name == innerProcess.Name {
					return errors.New(fmt.Sprintf("Dublicate process names found: '%s'. Process names has to be unique.", process.Name))
				}
			}
		}
	}
	return nil
}

// Checks if a given process is part of a circular dependency chain
func ValidateNoCircular(process *Process, name string) (stack string) {
	if name == "" {
		name = process.Name
	}
	for _, p := range process.Before {
		if p.Name == name {
			return p.Name
		}
		stack = ValidateNoCircular(p, name)
		if stack != "" {
			return stack + "\n" + p.Name
		}
	}
	return ""
}

func ValidateNoDependOnAutoRestart(process *Process) error {
	if process.AutoRestart && len(process.Before) > 0 {
		return errors.New(fmt.Sprintf("Process '%s' is set to autorestart, but has processes that depends on it", process.Name))
	}
	return nil
}
