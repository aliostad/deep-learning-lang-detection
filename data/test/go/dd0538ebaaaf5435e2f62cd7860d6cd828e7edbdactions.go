package godux

type Action struct {
	Type  string
	Value interface{}
}

type Dispatcher func(*Action) *Action

type ActionCreator func(interface{}) *Action

var ActionTypes struct{ INIT string }

func INITAction() *Action {
	return &Action{Type: ActionTypes.INIT}
}

func init() {
	ActionTypes = struct{ INIT string }{
		INIT: "@@godux/INIT",
	}
}

func BindActionCreator(creator ActionCreator, dispatch Dispatcher) ActionCreator {
	return func(i interface{}) *Action {
		return dispatch(creator(i))
	}
}

func BindActionCreators(creators map[string]ActionCreator, dispatch Dispatcher) map[string]ActionCreator {
	result := map[string]ActionCreator{}
	for k, creator := range creators {
		result[k] = BindActionCreator(creator, dispatch)
	}
	return result
}
