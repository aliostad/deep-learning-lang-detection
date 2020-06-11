(ns zole.ws
  (:require [re-frame.core :refer [dispatch]]
            [chord.client :refer [ws-ch]]
            [zole.config :as config]
            [goog.string :as gstring]
            [goog.string.format]
            [cljs.core.async :refer [<! >! put! timeout]]
            [clojure.string :refer [replace]])
  (:require-macros [cljs.core.async.macros :refer [go go-loop]]))

(defn event-type [str]
  (keyword (replace str "_" "-")))

(defn app-loop [ws-chan]
  (go-loop []
    (let [{:keys [message error] :as msg} (<! ws-chan)]
      (if-not error
        (when message
          (let [[msg-type & payload] message
                event                (event-type msg-type)]
            (dispatch [event payload])
            (when config/debug?
              (println event payload))
            (when (= event :plays)
              (<! (timeout 1100)))))
        (dispatch [:ws-error error]))
      (if msg
        (recur)
        (dispatch [:ws-disconnected])))))

(defn ws-url []
  (gstring/format "ws://%s:%s/websocket" js/window.location.hostname (config/ws-port-number)))

(defn connect! []
  (go
    (let [{:keys [ws-channel error]} (<! (ws-ch (ws-url) {:format :json}))]
      (if-not error
        (do (app-loop ws-channel)
            (dispatch [:ws-connected ws-channel]))
        (dispatch [:ws-error error])))))

(defn send! [ws-chan message]
  (go (>! ws-chan message)))
