package compactor

import (
	"context"
	"time"

	"github.com/go-kit/kit/endpoint"
)

// Endpoints collects all of the endpoints that compose a compactor service.
type Endpoints struct {
	ProcessEndpoint endpoint.Endpoint
}

// Process implements Service. Primarily useful in a client.
func (e Endpoints) Process(ctx context.Context, req ProcessRequest) error {
	response, err := e.ProcessEndpoint(ctx, req)
	if err != nil {
		return err
	}
	resp := response.(ProcessResponse)
	return resp.Err
}

// ProcessRequest holds the values for processing the compaction.
type ProcessRequest struct {
	StartAt time.Time `json:"startAt"`
}

// ProcessResponse holds the response data for the Process handler
type ProcessResponse struct {
	Err error `json:"err,omitempty"`
}

func (r ProcessResponse) error() error { return r.Err }

// MakeProcessEndpoint returns an endpoint via the passed service.
// Primarily useful in a server.
func MakeProcessEndpoint(s Service) endpoint.Endpoint {
	return func(ctx context.Context, request interface{}) (response interface{}, err error) {
		req := request.(ProcessRequest)
		e := s.Process(ctx, req)
		return ProcessResponse{Err: e}, nil
	}
}
