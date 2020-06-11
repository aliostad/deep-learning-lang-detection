package core

import (
	"testing"
	"kevlar/ircd/parser"
)

var registerDispatchMessages = []struct {
	Hook    string
	Mask    ExecutionMask
	Message *parser.Message
}{
	{
		Hook:    "test",
		Mask:    Registration,
		Message: &parser.Message{},
	},
	{
		Hook:    "test",
		Mask:    User,
		Message: &parser.Message{},
	},
	{
		Hook:    "test",
		Mask:    Server,
		Message: &parser.Message{},
	},
	{
		Hook:    "test",
		Mask:    User | Registration,
		Message: &parser.Message{},
	},
}

var registerDispatchHooks = []struct {
	Hook        string
	Mask        ExecutionMask
	Constrain   CallConstraints
	Func        func(string, ExecutionMask, *parser.Message)
	ExpectCalls int
}{
	{
		Hook:        "other",
		Mask:        Registration | User | Server,
		Constrain:   AnyArgs,
		Func:        func(string, ExecutionMask, *parser.Message) {},
		ExpectCalls: 0,
	},
	{
		Hook:        "test",
		Mask:        Registration | User | Server,
		Constrain:   AnyArgs,
		Func:        func(string, ExecutionMask, *parser.Message) {},
		ExpectCalls: 4,
	},
	{
		Hook:        "test",
		Mask:        User | Server,
		Constrain:   AnyArgs,
		Func:        func(string, ExecutionMask, *parser.Message) {},
		ExpectCalls: 2,
	},
}

func TestRegisterDispatch(t *testing.T) {
	/* TODO(kevlar): Reimplement this test
	hooks := make([]*Hook, len(registerDispatchHooks))

	for i, test := range registerDispatchHooks {
		hooks[i] = Register(test.Hook, test.Mask, test.Constrain, test.Func)
	}

	for _, disp := range registerDispatchMessages {
		Dispatch(disp.Hook, disp.Mask, disp.Message)
	}

	for i, test := range registerDispatchHooks {
		if got, want := hooks[i].Calls, test.ExpectCalls; got != want {
			t.Errorf("#%d: %d calls, want %d", i, got, want)
		}
	}
	*/
}
