package process_tree

import "github.com/go-zero-boilerplate/osvisitors"

//LoadProcessTree will load the tree from the pid
func LoadProcessTree(mainProcID int) (*ProcessTree, error) {
	osType, err := osvisitors.GetRuntimeOsType()
	if err != nil {
		return nil, err
	}
	visitor := &visitorGetTree{mainProcID: mainProcID}
	osType.Accept(visitor)
	if visitor.err != nil {
		return nil, visitor.err
	}
	return visitor.tree, nil
}

//ProcessTree is the top-level for a process tree, containing a single `MainProcess` with its nested children
type ProcessTree struct {
	MainProcess *Process
}

func (p *ProcessTree) FlattenedPids() []int {
	return p.MainProcess.flattenedPids()
}
