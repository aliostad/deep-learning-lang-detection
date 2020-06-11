package dispatcher

//事件分发器接口
type IEventDispatcher interface {
	// RegisterEvent 注册事件
	RegisterEvent(event IEvent) bool
	// RemoveEvent 移除事件
	RemoveEvent(eventName string) bool
	// DispatchEvent 分发事件
	DispatchEvent(eventName string,params ...interface{}) bool
	// RegisterEventListener 注册事件监听器
	RegisterEventListener(eventName string,listener interface{}) ListenerId
	// RemoveEventListener 移除事件监听器
	RemoveEventListener(eventName string,listener interface{}) bool
	// RemoveEventListenerById 使用监听器id移除监听器
	RemoveEventListenerById(eventName string,listener ListenerId) bool
}