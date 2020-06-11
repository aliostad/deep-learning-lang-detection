(ns hello-world.impl.trade-manager
  (:require
   [hello-world.protocol :refer (trade-manager-dispatch-values TradeManagerMsg
                                 betfair-client-dispatch-values BetfairClientMsg)]
   [com.stuartsierra.component :as component]
   [taoensso.timbre :as timbre]
   [schema.core :as s]
   [clojure.core.async :as a :refer (<! go-loop)]
   ))

;; (defmulti #^{:private true} trade-manager-dispatch :dispatch)
(defmulti trade-manager-dispatch (fn [msg _ _ _] (:dispatch msg)))

(defn- start-trade-manager
  [betfair-request tm-in trader market-book]
  (let []
    (go-loop []
      (when-let [msg (a/<! tm-in)]
        (if-let [error (s/check TradeManagerMsg msg)]
          (timbre/warn "Illegal value recived: " error)
          (trade-manager-dispatch msg betfair-request trader market-book)
          )
        (recur)))))

(defrecord Trade-manager
    [running? betfair-request tm-in trader betfair-client market-book]
  component/Lifecycle
  (start [component]
    (timbre/info "Starting trade-manager component")
    (if-not running?
      (do
        (start-trade-manager betfair-request tm-in trader market-book)
        (assoc component
               :running? true
               ))
      component))
  (stop [component]
    (timbre/info "Stopping trade-manager component")
    (if running?
      (do
        (a/close! betfair-request)
        (assoc component
               :running? false))
      component)))

(defn new-trade-manager
  [betfair-request tm-in]
  (map->Trade-manager {:betfair-request betfair-request
                       :tm-in tm-in}))

;; write a macro that first checks if a msg is of the correct type, if it is its ok
;; if its not try to convert to that type, make that macro possible to
;; activate and deactiva same as schema
(defmethod trade-manager-dispatch (:out trade-manager-dispatch-values)
  betfair-request [{:keys (msg)} betfair-ch _ _]
  (a/put! betfair-ch msg))

(defmethod trade-manager-dispatch (:in trade-manager-dispatch-values)
  betfair-response [{:keys (msg)} _ _ _]
  (timbre/info "Response: " msg))

;; (defmethod trade-manager-dispatch :market-book/update
  ;; update-market-book [ [_ msg] trade-manager])
