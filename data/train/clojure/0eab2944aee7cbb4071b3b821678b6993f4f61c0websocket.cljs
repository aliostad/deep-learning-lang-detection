(ns pulina.data.websocket
  (:require-macros
    [cljs.core.async.macros :as asyncm :refer [go go-loop]])
  (:require [mount.core :as m]
            [taoensso.sente :as sente]
            [taoensso.timbre :as tre]
            [cljs.core.async :as async]
            [re-frame.core :refer [dispatch]]))

(m/defstate ws-connection
            :start (sente/make-channel-socket! "/chsk" {:type :auto})
            :stop (sente/chsk-disconnect! (:chsk @ws-connection)))

(defn- ws-fn [k args]
  (apply (or (k @ws-connection) identity) args))

(def ^:private chsk-send-buffer (atom []))

(defn chsk [& args] (ws-fn :chsk args))
(defn ch-chsk [] (:ch-recv @ws-connection))
(defn chsk-send! [& args]
  (if (nil? @chsk-send-buffer)
    (ws-fn :send-fn args)
    (swap! chsk-send-buffer conj args)))
(defn chsk-state [& args] (ws-fn :state args))

; ---------------------------------------
; websocket communication and dispatching
(defmulti dispatch! :id)

(defmethod dispatch! :chsk/state
  [state]
  (if (:open? @(:state state))
    (let [unsent @chsk-send-buffer]
      (reset! chsk-send-buffer nil)
      (doseq [x unsent] (apply chsk-send! x)))))

(defmethod dispatch! :chsk/recv
  [{data :?data}]
  (dispatch [:server-chsk-dispatch data]))

(defmethod dispatch! :default
  [d]
  (tre/warn "No dispatch handler found for " (:id d)))

; --------------------------------------
; channel listeners
(defn start-receiver! []
  (tre/info "Starting websocket receiver")
  (go-loop [i 0]
     (let [d (<! (ch-chsk))]
       (dispatch! d))
     (recur (inc i))))


(m/defstate receiver :start (start-receiver!)
            :stop (async/close! @receiver))