package mqtt

////////////////////Interface//////////////////////////////

type Listener interface {
	ProcessConnect(eventConnect EventConnect)
	ProcessPublish(eventPublish EventPublish)
	ProcessSubscribe(eventSubscribe EventSubscribe)
	ProcessUnsubscribe(eventUnsubscribe EventUnsubscribe)

	ProcessTimeout(eventTimeout EventTimeout)
	ProcessIOException(eventIOException EventIOException)
	ProcessSessionTerminated(eventSessionTerminated EventSessionTerminated)
}

////////////////////Implementation////////////////////////
