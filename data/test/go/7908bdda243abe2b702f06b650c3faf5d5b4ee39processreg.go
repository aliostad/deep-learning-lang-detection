// Process registry.
//

package xpipe

import (
    "fmt"
)

// A process registry entry
type ProcessRegEntry struct {
    Factory     ProcessFactory
}

// Empty config args array
var EmptyConfigArgs = []ConfigArg {}

// --------------------------------------------------------------------------
//

// A process registry
type ProcessRegistry struct {
    Entries     map[string]*ProcessRegEntry
}

// Creates a new process registry
func NewProcessRegistry() *ProcessRegistry {
    pr := &ProcessRegistry{make(map[string]*ProcessRegEntry)}
    pr.registerStandardProcessors()
    return pr
}

// Registers the standard processes
func (pr *ProcessRegistry) registerStandardProcessors() {
    pr.Entries["xpath"] = &ProcessRegEntry{func() Process { return &XPathProcess{} }}
    pr.Entries["thisdoc"] = &ProcessRegEntry{func() Process { return &SelectDocumentProcess{} }}
    pr.Entries["first"] = &ProcessRegEntry{func() Process { return &FirstProcess{} }}
    pr.Entries["settext"] = &ProcessRegEntry{func() Process { return &SetTextProcess{} }}
    pr.Entries["print"] = &ProcessRegEntry{func() Process { return &PrintProcess{} }}
    pr.Entries["printfile"] = &ProcessRegEntry{func() Process { return &PrintFileProcess{} }}
    pr.Entries["printemptyfile"] = &ProcessRegEntry{func() Process { return &PrintEmptyFileProcess{} }}
}

// Creates and configures a new process.  If args is nil, it is treated as an empty config args array.
//
func (pr *ProcessRegistry) NewProcess(name string, args []ConfigArg) (Process, error) {
    if args == nil {
        args = EmptyConfigArgs
    }

    ent, hasEnt := pr.Entries[name]
    if !hasEnt {
        return nil, fmt.Errorf("No such process: %s", name)
    }

    p := ent.Factory()
    return p, p.Config(args)
}

// Creates and configures a new process.  Panics on error
func (pr *ProcessRegistry) MustNewProcess(name string, args []ConfigArg) Process {
    p, err := pr.NewProcess(name, args)
    if err != nil {
        panic(err)
    }

    return p
}
