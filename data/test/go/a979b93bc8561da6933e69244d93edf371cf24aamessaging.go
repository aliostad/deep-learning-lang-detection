package messaging

import (
	"fmt"
	"github.com/streadway/amqp"
	"munch/config"
	"strconv"
)

type Broker struct {
	conn        *amqp.Connection // The connection
	channel     *amqp.Channel    // Channel to send commands
	cfg         *config.Config   // Keep a link to the config file (for queue names)
	queue_crawl *amqp.Queue
	queue_email *amqp.Queue
}

func New(config *config.Config) *Broker {
	broker := new(Broker)
	broker.cfg = config

	// Connect to the message queue server
	address := fmt.Sprintf("amqp://%s:%s@%s:%d/", config.GetQueueUsername(),
		config.GetQueuePassword(),
		config.GetQueueHost(),
		config.GetQueuePort())

	conn, err := amqp.Dial(address)
	if err != nil {
		fmt.Printf("There was an error connecting to the broker")
		panic(err)
	}
	broker.conn = conn

	// Create a new channel
	channel, err := conn.Channel()
	if err != nil {
		panic(err)
	}
	broker.channel = channel

	broker.initializeQueues()
	return broker
}

func (broker *Broker) initializeQueues() error {
	broker.channel.Qos(1, 0, true)

	// Setup queues based on the config file
	if err := broker.channel.ExchangeDeclare(broker.cfg.GetQueueExchange(),
		"topic",
		true,
		false,
		false,
		false,
		nil); err != nil {
		fmt.Printf("%s\n", err)
		fmt.Printf("There was an error declaring the exchange")
		return fmt.Errorf("There was an error declaring the exchange")
	}

	queue_crawl, _ := broker.queueDeclare(broker.cfg.GetQueueCrawl())
	broker.queue_crawl = queue_crawl

	queue_email, _ := broker.queueDeclare(broker.cfg.GetQueueEmail())
	broker.queue_email = queue_email
	return nil
}

func (broker *Broker) queueDeclare(name string) (*amqp.Queue, error) {
	fmt.Printf("Declaring queue with name: %s\n", name)
	queue, err := broker.channel.QueueDeclare(name,
		true,
		false,
		false,
		false,
		nil)
	if err != nil {
		fmt.Printf("There was an error declaring the queue: %s\n", name)
		return nil, fmt.Errorf("There was an error when declaring the queue: %s\n", name)
	}

	err = broker.channel.QueueBind(queue.Name, name, broker.cfg.GetQueueExchange(), false, nil)
	if err != nil {
		fmt.Printf("%s\n", err)
		return nil, fmt.Errorf("There was an error binding the queue")
	}

	return &queue, err
}

func (broker *Broker) EnqueueCrawl(sourceid int) error {
	err := broker.channel.Publish(broker.cfg.GetQueueExchange(),
		broker.cfg.GetQueueCrawl(),
		true,
		false,
		amqp.Publishing{
			Headers:         amqp.Table{},
			ContentType:     "text/plain",
			ContentEncoding: "",
			Body:            []byte(fmt.Sprintf("%d", sourceid)),
			DeliveryMode:    amqp.Persistent,
			Priority:        5,
		})

	if err != nil {
		return fmt.Errorf("There was an error publishing a message to the message queue\n")
	}

	fmt.Printf("The crawl request was enqueued\n")

	return nil
}

func (broker *Broker) DequeueCrawl() int {
	deliveries, err := broker.channel.Consume(broker.queue_crawl.Name, "crawler", false, false, false, false, nil)

	if err != nil {
		return -1
	}

	// Block until we hear something
	payload := <-deliveries
	broker.channel.Cancel("crawler", false)

	payload.Ack(false)
	sid, err := strconv.Atoi(string(payload.Body))
	if err != nil {
		fmt.Printf("There was an error in the message for queueing")
		return -1
	}
	return sid
}
