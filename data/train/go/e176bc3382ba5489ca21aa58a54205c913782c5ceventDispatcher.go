package result

import(
)
//EventDispatcher interface for sending an event to multiple EventConsumers
type EventDispatcher interface{
    //StartDispatch starts dispatching events, reading from an input channel
    StartDispatch( c <-chan Event)
    //StopDispatch shuts down the dispatch process
    StopDispatch()
}
//SimpleDispatcher implementation of EventDispatcher which sends each event to multiple Consumers
type SimpleDispatcher struct{
    //Consumers to which events should be sent
    Consumers [] EventConsumer
    //done is an internal channel to control (shut down) dispatch process
    done chan struct{}
}

func (this *SimpleDispatcher) StartDispatch(c <-chan Event){
    for _,con:= range this.Consumers{
        con.Init()
    }
    this.done = make(chan struct{})
    go func(){
        for{
        select{
            case e:= <- c:
                for _,con:= range this.Consumers{
                    con.Consume(e)
                }
            case <- this.done:
                return
        }
    }
    }()
}
func (this *SimpleDispatcher)StopDispatch(){
    close(this.done)
}