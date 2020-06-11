package taskmq

type TaskMQ struct {
	config *Config
	broker IBroker
}

func New(broker IBroker, config *Config) *TaskMQ {
	if config == nil {
		config = &Config{}
	}

	if config.Logger == nil {
		config.Logger = &LoggerNull{}
	}

	broker.SetLogger(config.Logger)

	return &TaskMQ{
		config: config,
		broker: broker,
	}
}

func (r *TaskMQ) Connect() error {
	return r.broker.Connect()
}

func (r *TaskMQ) Publish(queueName string, body []byte) error {
	return r.broker.Push(queueName, body)
}

func (r *TaskMQ) Consume(queueName string, fn callbackFunction) {
	broker := r.broker.Clone()
	c := newConsumer(broker, r.config.Logger, queueName)
	c.Listen(fn)
}
