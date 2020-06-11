(ns multi-client-ws.routes.websockets
  (:require [compojure.core :refer [GET defroutes wrap-routes]]
            [taoensso.timbre :as timbre]
            [immutant.web.async       :as async]))

;; Next, we'll create the websocket-callbacks map that will specify the functions that should be triggered during different websocket events:
(def websocket-callbacks
  "Websocket callback functions"
  {:on-open connect!
   :on-close disconnect!
   :on-message notify-clients!})

;; We'll create a websocket handler function and Compojure route for our websocket route:
(defn ws-handler [request]
  (async/as-channel request websocket-callbacks))

(defroutes websocket-routes
  (GET "/ws" [] ws-handler))


;; We'll now create an atom to store the channels and define the connect! function that will be called any time a new client connects. The function will add the channel to the set of open channels.
(defonce channels (atom #{}))

(defn connect! [channel]
  (timbre/info "channel open")
  (swap! channels conj channel))

;;; The function will log that a new channel was opened and add the channel to the set of open channels defined above.

;; When the client disconnects the disconnect! function will be called. This function accepts the channel along with a map containing the _code_ and the _reason_ keys. It will log that the client disconnected and remove the channel  from the set of open channels.

(defn disconnect! [channel {:keys [code reason]}]
  (timbre/info "close code:" code "reason:" reason)
  (swap! channels #(remove #{channel} %)))

;; Finally, we have the notify-clients! function that's called any time a client  message is received. This function will broadcast the message to all the connected clients.

(defn notify-clients! [channel msg]
  (doseq [channel @channels]
    (async/send! channel msg)))


;; That's all we need to do to manage the lifecycle of the websocket connections  and to handle client communication.

