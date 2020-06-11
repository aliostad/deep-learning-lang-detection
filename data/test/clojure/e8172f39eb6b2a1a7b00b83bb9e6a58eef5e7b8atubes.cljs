(ns group-chat-app.tubes
  (:require
    [re-frame.core :refer [dispatch]]
    [pneumatic-tubes.core :as tubes]))

;; -- Pneumatic tubes setup -------------------------------------------------
(defn- on-receive [event-v]
  (.log js/console "received from server:" (str event-v))
  (dispatch event-v))

(defn- on-disconnect []
  (.log js/console "Connection with server lost.")
  (dispatch [:backend-connected false]))

(defn- on-connect []
  (dispatch [:backend-connected true]))

(def host "localhost:3000")
(def tube (tubes/tube (str "ws://" host "/chat")
                      on-receive on-connect on-disconnect
                      {:web-socket-impl (js/require "WebSocket")}))