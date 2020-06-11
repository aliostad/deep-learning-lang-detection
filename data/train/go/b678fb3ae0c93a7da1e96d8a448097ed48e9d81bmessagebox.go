package main

type mbox_id uint
type mmsg_id uint
type MessageToken uint

type Message struct {
	token MessageToken
	id mmsg_id
}

const (
	QuitMsg MessageToken = iota
)

func new_message(token MessageToken) Message {
	var msg Message
	msg.token = token
	return msg
}

type Messagebox struct {
	id mbox_id
	broker *MessageBroker
}

type MessageRegistration struct {
	listeners map[mbox_id]bool
}

type MessageBroker struct {
	regs map[MessageToken]*MessageRegistration
	boxes map[mbox_id]*[]Message
}

var global_broker *MessageBroker
func get_broker() *MessageBroker {
	if (global_broker == nil) {
		var broker *MessageBroker
		broker = new(MessageBroker)
		broker.regs = make(map[MessageToken]*MessageRegistration)
		broker.boxes = make(map[mbox_id]*[]Message)
		global_broker = broker
	}
	return global_broker
}

func (this *MessageBroker) get_queue(id mbox_id) *[]Message {
	if _, ok := this.boxes[id]; !ok {
		m := make([]Message, 0)
		this.boxes[id] = &m;
	}
	return this.boxes[id]
}

var next_mbox_id mbox_id
func new_messagebox() *Messagebox {
	var this Messagebox

	next_mbox_id++;
	this.id = next_mbox_id;
	this.broker = get_broker()

	return &this
}

func (this *Messagebox) listen(token MessageToken) {
	if _, ok := this.broker.regs[token]; !ok {
		r := new(MessageRegistration)
		r.listeners = make(map[mbox_id]bool)
		this.broker.regs[token] = r
	}

	this.broker.regs[token].listeners[this.id] = true
}

func (this *Messagebox) unlisten(token MessageToken) {
	r := this.broker.regs[token].listeners
	if _, ok := r[this.id]; ok {
		delete(r, this.id)
	}
}

var next_msg_id mmsg_id = 42
func (this *Messagebox) send(mesg Message) {
	next_msg_id++
	mesg.id = next_msg_id
	for box_id := range this.broker.regs[mesg.token].listeners {
		q := this.broker.get_queue(box_id)
		*q = append(*q, mesg)
	}
}

func (this *Messagebox) get() *[]Message {
	queue := this.broker.get_queue(this.id)
	empty_queue := (*queue)[:0]
	this.broker.boxes[this.id] = &empty_queue
	return queue
}

