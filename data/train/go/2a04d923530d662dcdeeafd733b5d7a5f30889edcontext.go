package broker

import "context"

const key = "broker"

// Setter defines a context that enables setting values.
type Setter interface {
	Set(string, interface{})
}

// FromContext returns the Config associated with this context.
func FromContext(c context.Context) Broker {
	return c.Value(key).(Broker)
}

// ToContext adds the Config to this context if it supports
// the Setter interface.
func ToContext(c Setter, b Broker) {
	c.Set(key, b)
}

func NewContext(ctx context.Context, b Broker) context.Context {
	return context.WithValue(ctx, key, b)
}
