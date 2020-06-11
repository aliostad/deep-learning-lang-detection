package main

type Broker struct {
    outs map[chan string]bool
    semp chan struct{}
}

func (b *Broker) Add(out chan string) {
    b.semp <- struct{}{}
    b.outs[out] = true
    <-b.semp
}

func (b *Broker) Remove(out chan string) {
    b.semp <- struct{}{}
    delete(b.outs, out)
    <-b.semp
}

func (b *Broker) Broadcast(message string) {
    b.semp <- struct{}{}
    for c, _ := range b.outs {
        c <- message
    }
    <-b.semp
}

func NewBroker() *Broker {
    return &Broker{
        outs: make(map[chan string]bool),
        semp: make(chan struct{}, 1),
    }
}
