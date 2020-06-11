(ns esource.core)


(defprotocol IStore
  (latest! [store stream]
    "For a given stream id, return the latest value in the store")

  (latest-version! [store stream]
    "For a given stream id, return the version number of the latest
    value in the store")

  (version! [store stream]
    "For a given stream id, return the version of the last value stored")

  (add! [store stream data]
    "For a given stream and some map, put the data in the store and return
    a truthy value if the operation was successful.")

  (slice! [store stream] [store stream start] [store stream start end]
    "For a given stream, get all values from version start to end. If
    no end is given the latest version is used. If no start is given
    it returns all values belonging to the stream")

  (fold! [store stream init reducer]
    "For a given stream and a dispatch-fn/multi-method, regenerate state from init"))


(defprotocol IBus
  (publish! [bus data]
    "For a given value, broadcast to all listening channels")

  (subscribe! [bus mine?] [bus mine? buff]
    "For a given predicate, create a channel of size buff to receive
    notifications that pass the predicate. If the buff is not given
   a default size is used(most probably 10)")

  (unsubscribe! [bus chan]
    "For a given channel, destroy connection with bus")

  (stop! [bus]
    "Destroy connection to all subscribers"))


(defprotocol IStream
  (dispatch! [stream event]
    "For a given event map, validate it, store it and publish it")

  (state! [stream id]
    "For an aggregate with the given id, retrieve its state")

  (refresh! [stream id event]
    "For an aggregate with given id and a new event, internally
    update the state of the aggregate")

  (on-stream! [stream]
    "Create a channel to listen to events on this stream")

  (on-event! [stream event]
    "For a given notification with name event, create a channel to
    receive new events on the stream"))
