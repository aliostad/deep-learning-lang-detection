package utils

// Broker -
type Broker struct {
	Notifier       chan interface{}
	NewClients     chan chan interface{}
	ClosingClients chan chan interface{}
	clients        map[chan interface{}]bool
}

// NewBroker -
func NewBroker() (broker *Broker) {
	broker = &Broker{
		Notifier:       make(chan interface{}, 1),
		NewClients:     make(chan chan interface{}),
		ClosingClients: make(chan chan interface{}),
		clients:        make(map[chan interface{}]bool),
	}
	go func() {
		for {
			select {
			case c := <-broker.NewClients:
				broker.clients[c] = true
			case c := <-broker.ClosingClients:
				delete(broker.clients, c)
			case ev := <-broker.Notifier:
				for ch := range broker.clients {
					ch <- ev
				}
			}
		}
	}()
	return
}
