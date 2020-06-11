package main

type Broker struct {
    webSocketConnections map[*WebSocketConnection]bool
    register chan *WebSocketConnection
    unregister chan *WebSocketConnection
    receivedMessages chan string
}

func (broker *Broker) run() {
    for {
        select {
        case webSocketConnection := <- broker.register:
            broker.webSocketConnections[webSocketConnection] = true
        case webSocketConnection := <- broker.unregister:
            _, webSocketExists := broker.webSocketConnections[webSocketConnection]

            if webSocketExists {
                delete(broker.webSocketConnections, webSocketConnection)
            }
        case message := <- broker.receivedMessages:
            broker.deliverMessage(message)
        }
    }
}

func (broker *Broker) deliverMessage(message string) {
    for webSocketConnection, _ := range broker.webSocketConnections {
        webSocketConnection.send(message)
    }
}
