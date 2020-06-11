package sqs

import (
	"context"
	"time"

	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/rai-project/broker"
)

const (
	sessionKey                = "github.com/rai-project/broker/sqs/session"
	queueNameKey              = "github.com/rai-project/broker/sqs/queueName"
	concurrentHandlerCountKey = "github.com/rai-project/broker/sqs/concurrentHandlerCount"
	subscriptionTimeoutKey    = "github.com/rai-project/broker/sqs/subscriptionTimeout"
	maxInFlightKey            = "github.com/rai-project/broker/sqs/maxInFlight"
)

// DefaultConcurrentHandlerCount ...
var (
	DefaultConcurrentHandlerCount = 1
	DefaultSubscriptionTimeout    = int64(5) // second
)

// Session ...
func Session(sess *session.Session) broker.Option {
	return func(o *broker.Options) {
		o.Context = context.WithValue(o.Context, sessionKey, sess)
	}
}

// QueueName ...
func QueueName(q string) broker.Option {
	return func(o *broker.Options) {
		o.Context = context.WithValue(o.Context, queueNameKey, q)
	}
}

// ConcurrentHandlerCount ...
func ConcurrentHandlerCount(n int) broker.SubscribeOption {
	return func(o *broker.SubscribeOptions) {
		o.Context = context.WithValue(o.Context, concurrentHandlerCountKey, n)
	}
}

// SubscriptionTimeout ...
func SubscriptionTimeout(d time.Duration) broker.SubscribeOption {
	return func(o *broker.SubscribeOptions) {
		o.Context = context.WithValue(o.Context, subscriptionTimeoutKey, int64(d.Seconds()))
	}
}

// MaxInFlight ...
func MaxInFlight(n int) broker.Option {
	return func(o *broker.Options) {
		o.Context = context.WithValue(o.Context, maxInFlightKey, n)
	}
}
