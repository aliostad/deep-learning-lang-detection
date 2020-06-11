package mocks

import "github.com/cloudfoundry-incubator/notifications/v1/services"

type Strategy struct {
	DispatchCalls      []StrategyDispatchCall
	DispatchCallsCount int
}

type StrategyDispatchCall struct {
	Receives struct {
		Dispatch services.Dispatch
	}
	Returns struct {
		Responses []services.Response
		Error     error
	}
}

func NewStrategyDispatchCall(responses []services.Response, err error) StrategyDispatchCall {
	call := StrategyDispatchCall{}
	call.Returns.Responses = responses
	call.Returns.Error = err

	return call
}

func NewStrategy() *Strategy {
	return &Strategy{}
}

func (s *Strategy) Dispatch(dispatch services.Dispatch) ([]services.Response, error) {
	if len(s.DispatchCalls) <= s.DispatchCallsCount {
		s.DispatchCalls = append(s.DispatchCalls, StrategyDispatchCall{})
	}

	call := s.DispatchCalls[s.DispatchCallsCount]
	s.DispatchCalls[s.DispatchCallsCount].Receives.Dispatch = dispatch
	s.DispatchCallsCount++

	return call.Returns.Responses, call.Returns.Error
}
