package broker

type Broker interface {
	Init(...Option) error
	Connect() error
	Disconnect() error
	Publish(string, Message, ...PublishOption) error
	Subscribe(string, func(Message) error, ...SubscribeOption) (Subscriber, error)
	String() string
}

type Subscriber interface {
	Topic() string
	UnSubscribe() error
}

var (
	DefaultBroker Broker
)

func Register(b Broker) {
	DefaultBroker = b
}

func Init(opts ...Option) error {
	return DefaultBroker.Init(opts...)
}

func Connect() error {
	return DefaultBroker.Connect()
}

func Disconnect() error {
	return DefaultBroker.Disconnect()
}

func Publish(topic string, msg Message, opts ...PublishOption) error {
	return DefaultBroker.Publish(topic, msg, opts...)
}

func Subscribe(topic string, handler func(Message) error, opts ...SubscribeOption) (Subscriber, error) {
	return DefaultBroker.Subscribe(topic, handler, opts...)
}

func String() string {
	return DefaultBroker.String()
}
