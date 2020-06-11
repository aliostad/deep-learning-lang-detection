package rest

import "net/http"

// Service holds application scope broker, logger and metrics adapters
type Service struct {
	Broker  Broker
	Logger  Logger
	Metrics Metrics
}

// UseBroker - set the desired broker
func (s *Service) UseBroker(b Broker) {
	s.Broker = b
}

// UseLogger - set the desired logger
func (s *Service) UseLogger(l Logger) {
	s.Logger = l
}

// UseMetrics - set the desired metrics
func (s *Service) UseMetrics(m Metrics) {
	s.Metrics = m
}

// Broker is an event stream adapter to notify other microservices of state changes
type Broker interface {
	Publish(event string, v interface{}) error
}

// Logger is an leveled logging interface
type Logger interface {
	Error(e error)
}

// Metrics is an adapter to track application performance metrics
type Metrics interface {
	Incr(stat string, count int64) error
	Timing(stat string, delta int64) error
	NewTimer(stat string) func()
}

// Event -
type Event struct {
	Request  *http.Request
	Response *Response
}

// NewService -
func NewService() *Service {
	return &Service{}
}
