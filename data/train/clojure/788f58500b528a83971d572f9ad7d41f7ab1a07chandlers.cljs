(ns controller.handlers
  (:require
    [re-frame.core :refer [register-handler after subscribe dispatch dispatch-sync]]
    [controller.comms :as comms]
    [controller.db :refer [app-db]]
    [controller.drive :as drive]
    [controller.throttle :as throttle]
    [controller.wheels :as wheels]
    [taoensso.timbre :refer-macros [spy info]]))

(register-handler
  :initialize-db
  (fn [_ _]
    (assoc
     app-db
     :wheels wheels/initial-state
     :throttle throttle/initial-state
     :drive drive/initial-state
     :net {:endpoint "ws://192.168.4.1:8080"
           :open false
           :error nil
           :message nil
           :close nil})))

(register-handler
 :update-state
 (fn [db [_ f]]
   (or (f db)
       db)))

(register-handler
 :update-readystate
 (fn [db _]
   (let [ws (-> db :net :ws)]
     (assoc-in db [:net :ready-state]
               (when ws
                 (case (.-readyState ws)
                   0 :connecting
                   1 :open
                   2 :closing
                   3 :closed))))))

(register-handler
 :init-websocket
 (fn [db _]
   (let [endpoint (-> db :net :endpoint)]
     (->> (when (some? endpoint)
            (do
              (info "Opening socket to" endpoint)
              (try
                (let [ws (js/WebSocket. endpoint)]
                  (set! (.-onopen ws)
                        (fn []
                          (do
                            (dispatch-sync [:wheels/update-raw 90])
                            (dispatch-sync [:wheels/zero])
                            (dispatch-sync [:throttle/zero])
                            (dispatch-sync [:set-state [:net :error] nil])
                            (dispatch-sync [:set-state [:net :close] nil])
                            (dispatch-sync [:set-state [:net :open] true]))))
                  (set! (.-onmessage ws)
                        (fn [message]
                          (dispatch-sync [:set-state [:net :messages] (.-data message)])))
                  (set! (.-onerror ws)
                        (fn [error]
                          (dispatch-sync [:set-state [:net :open] false])
                          (dispatch-sync [:set-state [:net :error] (.-message error)])))
                  (set! (.-onclose ws)
                        (fn [close]
                          (dispatch-sync [:set-state [:net :open] false])
                          (dispatch-sync [:set-state [:net :close] {:code (.-code close)
                                                                    :reason (.-reason close)}])))
                  ws)
                (catch :default e nil))))
          (assoc-in db [:net :ws])))))

(register-handler
 :set-state
 (fn [db [_ path args]]
   (assert (or (vector? path)
               (seq? path)))
   (if (map? args)
     (update-in db path merge args)
     (assoc-in db path args))))
