package core

import (
	"github.com/sywesk/later/backend/common"
	"strings"
	"errors"
	"fmt"
)

type SocketDispatcher struct {
	dispatchData map[string](map[string](chan<-*common.SocketQuery))
}

func newSocketDispatcher(registry *ModuleRegistry) *SocketDispatcher {
	dispatchData := make(map[string](map[string](chan<-*common.SocketQuery)))

	for _, moduleDescription := range registry.modules {
		moduleDispatch := make(map[string](chan<-*common.SocketQuery))

		for action, handler := range moduleDescription.QueryHandlers {
			moduleDispatch[action] = newSocketHandlerWrapper(handler)
		}

		dispatchData[moduleDescription.Id] = moduleDispatch
	}

	return &SocketDispatcher{
		dispatchData: dispatchData,
	}
}

func (s *SocketDispatcher) dispatch(query *common.SocketQuery) error {
	actionPath := strings.SplitN(query.Type, ".", 2)

	if actionPath == nil || len(actionPath) != 2 {
		return errors.New("invalid action path given")
	}

	moduleName := actionPath[0]
	handlerName := actionPath[1]

	moduleDispatch, ok := s.dispatchData[moduleName]
	if !ok {
		return errors.New(fmt.Sprintf("module '%s' is not registered", moduleName))
	}

	handler, ok := moduleDispatch[handlerName]
	if !ok {
		return errors.New(fmt.Sprintf("module '%s' has no handler '%s'", moduleName, handlerName))
	}

	select {
	case handler<- query:
	//case <-time.After(5*time.Second):
	//	return errors.New("abnormal handler wrapper channel send time (>5s), abordting")
	}

	return nil
}
