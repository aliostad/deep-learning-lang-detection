package kafka

import (
	"fmt"
	"reflect"
	"strings"
)

type TopicAndBroker map[string]string

func (cb *TopicAndBroker) String() string {
	return fmt.Sprint(*cb)
}

func (cb *TopicAndBroker) Type() string {
	return reflect.TypeOf(map[string]string{}).String()
}

func (cb *TopicAndBroker) Set(value string) error {
	TopicAndBroker := strings.SplitN(value, ":", 2)
	(*cb)[TopicAndBroker[0]] = TopicAndBroker[1]
	// TODO - error handling
	return nil
}

func (cb *TopicAndBroker) FirstBrokers() string {
	if cb.IsEmpty() {
		return ""
	}
	for _, v := range *cb {
		return v
	}
	return ""
}

func (cb *TopicAndBroker) FirstTopic() string {
	if cb.IsEmpty() {
		return ""
	}
	for k := range *cb {
		return k
	}
	return ""
}

func (cb *TopicAndBroker) Available() bool {
	return cb != nil && len(*cb) > 0
}

func (cb *TopicAndBroker) IsEmpty() bool {
	return cb == nil || len(*cb) == 0
}
