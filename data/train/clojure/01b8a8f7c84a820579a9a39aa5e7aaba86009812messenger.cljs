(ns projectname.common.messenger
  "Simple pubsub messaging system with helpers."
  (:require
   [cljs.core.async :refer [chan pub put! sub unsub]]))

(defprotocol IMessenger
  "Interface for messenger system."
  (dispatch [_ type] [_ type payload]
    "Dispatch a message of a type and optional payload.")
  (subscribe [_ type]
    "Helper that creates a channel set up to subscribe and an unsubscriber."))

(defrecord Messenger [broker publisher]
  IMessenger
  (dispatch [_ type]
    (put! broker {:type type}))
  (dispatch [_ type payload]
    (put! broker {:type type :payload payload}))
  (subscribe [_ type]
    (let [handler (chan)
          unsubscribe #(unsub publisher type handler)]
      (sub publisher type handler)
      [handler unsubscribe])))

(defn create-messenger
  "Construct a pubsub system with helper functions and conveniences."
  ([] (create-messenger (chan)))
  ([broker] (Messenger. broker (pub broker :type))))
