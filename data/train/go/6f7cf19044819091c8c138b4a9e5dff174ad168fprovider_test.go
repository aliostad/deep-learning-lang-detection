
package provider


import (
        "testing"
        "reflect"
        "cisco/micro/config"
)

const SUCCESSFUL_EXIT_CODE int = 0
const FAILURE_EXIT_CODE int = 1



func TestDispatchCommand(t *testing.T) {
        args := []string{"cmd-1","args"}


        cmd1Mock := NewMockedCommand("cmd-1", SUCCESSFUL_EXIT_CODE)
        cmd2Mock := NewMockedCommand("cmd-2", SUCCESSFUL_EXIT_CODE)

        dispatch := map[string]CommandFunction {
                "cmd-1": cmd1Mock.mockedFunction,
                "cmd-2": cmd2Mock.mockedFunction,
        }


        result := NewProvider(dispatch).dispatch([]config.Config{config.Config{Path: "SomePath"}}, args)

        if !cmd1Mock.called {
                t.Error("must dispatch to cmd function")
        }
        if cmd1Mock.cfgs[0].Path != "SomePath" {
                t.Error("must pass config with path to config file")
        }
        if !reflect.DeepEqual(cmd1Mock.args,args[1:]) {
                t.Error("must pass cluster args")
        }
        if result != SUCCESSFUL_EXIT_CODE {
                t.Error("must return exit code")
        }
}


func TestDispatchUnknownCommand(t *testing.T) {
        args := []string{"unknown"}


        cmd1Mock := NewMockedCommand("cmd-1", SUCCESSFUL_EXIT_CODE)

        dispatch := map[string]CommandFunction {
                "cmd-1": cmd1Mock.mockedFunction,
        }

        result := NewProvider(dispatch).dispatch([]config.Config{config.Config{Path: "SomePath"}}, args)

        if cmd1Mock.called {
                t.Error("must not dispatch to cmd function")
        }
        if result != FAILURE_EXIT_CODE {
                t.Error("must return exit code")
        }
}

type MockCommand struct {
        called bool
        args []string
        cfgs []config.Config
        mockedReturnValue int
}


func (self *MockCommand) mockedFunction(cfgs []config.Config, args []string) int {
        self.called = true
        self.args = args
        self.cfgs = cfgs
        return self.mockedReturnValue
}


func NewMockedCommand(id string, exitCode int) *MockCommand{
        mockCommandFunction := &MockCommand{mockedReturnValue: exitCode}
        return mockCommandFunction
}
