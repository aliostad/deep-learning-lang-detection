(ns webvim.ui.lib.socket
  (:require [webvim.ui.lib.util :refer [current-time]]
            [webvim.ui.lib.event :refer [dispatch-event]]
            [clojure.walk :refer [keywordize-keys]]))

;https://github.com/mmcgrana/cljs-demo/blob/master/src/cljs-demo/util.cljs
(defn- json-parse
  "Returns ClojureScript data for the given JSON string."
  [line]
  (keywordize-keys (js->clj (.parse js/JSON line))))

(defn- flush-stream [{conn :conn stream :stream :as state}]
  (let [s (.-readyState conn)]
    (cond
      (= s 1)
      (do (.send conn @stream)
          (reset! stream ""))
      (not= s 0)
      (dispatch-event :net-onfail state))))

(defn open-conn [url]
  (let [conn (js/WebSocket. url)
        state {:stream (atom "")
               :conn conn}]
    (set! (.-onopen conn)
          (fn [resp]
            ;(println (.-data resp))
            (dispatch-event :net-onopen state)
            (flush-stream state)))
    (set! (.-onmessage conn)
          (fn [message]
            (dispatch-event :net-onmessage (json-parse (.-data message)))))
    state))

(defn send [state s]
  (swap! (state :stream) str s)
  (flush-stream state))

