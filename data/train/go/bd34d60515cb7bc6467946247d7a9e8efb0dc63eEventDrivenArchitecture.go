package main

import "log"

type Event struct{
	Topic string
	Payload interface{}
}

func NewEvent(topic string,payload interface{})*Event{
	event := new(Event)
	event.Topic = topic
	event.Payload = payload
	return event
}

type Processor interface{
	PushEvent(event *Event)
	PullEvent()*Event
}

type EventManager struct{
	Procs []Processor
	Topics map[string]([]int)
}

func NewEventManager()*EventManager{
	manager := new(EventManager)
	manager.Procs = make([]Processor,0)
	manager.Topics = make(map[string]([]int))
	log.Print("EventManager is up and running")
	return manager
}

func (manager *EventManager) AddProcessor(proc Processor) int {
	manager.Procs = append(manager.Procs,proc)
	go func(){
		for{
			event := proc.PullEvent()
			//log.Print("Event: "+event.Topic)
			for _,idx := range manager.Topics[event.Topic] {
				go func(){
					manager.Procs[idx].PushEvent(event)
				}()
			}
		}
	}()
	return len(manager.Procs)-1
}

func (manager *EventManager) Subscribe(idx int, topic string){
	manager.Topics[topic] = append(manager.Topics[topic],idx)
}


