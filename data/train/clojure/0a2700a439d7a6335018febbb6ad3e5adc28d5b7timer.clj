(ns murphydye.websockets.timer
  (:require [murphydye.websockets.router :as r]
            ;; [murphydye.components :as components]
            ))

(def websocket-timer (r/make-router "timer" (atom 0)))

(r/add websocket-timer
     :immediate
     (fn [state action-name m] (swap! state inc)))

(r/add websocket-timer
     :timed
     (fn [state _ millisecs]
       (Thread/sleep millisecs)
       (swap! state #(+ % millisecs))))
;; (dispatch websocket-timer [:immediate])
;; (dispatch websocket-timer [:timed 100])

;; (r/add r/root-router :timer websocket-timer)
;; (type components/root-router)
;; (dispatch r/root-router [:timer :immediate])
;; (dispatch r/root-router [:timer :timed 100])
