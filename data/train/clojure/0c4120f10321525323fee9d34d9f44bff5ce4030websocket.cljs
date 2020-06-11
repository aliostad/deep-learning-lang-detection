(ns chatapp.websocket
  (:require [re-frame.core :as re-frame]))

(defn- onmessage [event]
  (re-frame/dispatch [:add-event {:type "message" :message (str "<<< " (.-data event))}]))

(defn- onerror [error]
  (re-frame/dispatch [:add-event {:type "debug" :message error}]))

(defn- onopen [event]
  (let [current-target (.-currentTarget event)]
    (re-frame/dispatch [:add-event {:type "debug" :message (str "Connected to " (.-url current-target))}])))

(defn- onclose [event]
  (re-frame/dispatch [:add-event {:type "debug" :message (str "Disconnected: " (.-code event) " " (.-reason event))}]))

(defn connect []
  (let [uri       (str "ws://" (.-host js/location) "/events")
        websocket (js/WebSocket. uri)]
    (set! (.-onerror websocket) onerror)
    (set! (.-onopen websocket) onopen)
    (set! (.-onmessage websocket) onmessage)
    (set! (.-onclose websocket) onclose)))
