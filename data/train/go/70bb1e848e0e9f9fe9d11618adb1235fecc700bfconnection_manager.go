package gorabbit

func (this *ConnectionManager) onDeliveryChannelRequested(message DeliveryChannelRequested) {
}
func (this *ConnectionManager) onDispatchChannelRequested(message DispatchChannelRequested) {
}

func NewConnectionManager(router Router) *ConnectionManager {
	this := new(ConnectionManager)
	this.router = router

	router.Register(DeliveryChannelRequested{}, func(m) { this.onDeliveryChannelRequested(m.(DeliveryChannelRequested)) })
	router.Register(DispatchChannelRequested{}, func(m) { this.onDispatchChannelRequested(m.(DispatchChannelRequested)) })
	return this
}

type ConnectionManager struct {
	router      Router
	connections map[Credential][]Connection
}
