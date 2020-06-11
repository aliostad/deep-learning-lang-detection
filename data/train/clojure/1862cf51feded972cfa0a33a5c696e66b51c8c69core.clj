;; Copyright (c) 2013, Damien JEGOU
;; All rights reserved.

;; Redistribution and use in source and binary forms, with or without
;; modification, are permitted provided that the following conditions
;; are met:

;;     Redistributions of source code must retain the above copyright
;; notice, this list of conditions and the following disclaimer.
;;     Redistributions in binary form must reproduce the above copyright
;; notice, this list of conditions and the following disclaimer in the
;; documentation and/or other materials provided with the distribution.

;; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
;; "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
;; LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
;; A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
;; HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
;; INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
;; BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
;; OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED
;; AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
;; LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY
;; WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
;; POSSIBILITY OF SUCH DAMAGE.


(ns egide.core
  (:require [taoensso.carmine :as car])
  (:import (java.util Date
                      Collections)
           (java.text SimpleDateFormat)
           (com.lmax.api Callback
                         FixedPointNumber
                         LmaxApi)
           (com.lmax.api.account LoginCallback
                                 LoginRequest)
	   (com.lmax.api.heartbeat HeartbeatCallback
				   HeartbeatRequest)
           (com.lmax.api.order ExecutionEventListener
                               ExecutionSubscriptionRequest
                               LimitOrderSpecification
                               OrderCallback
                               OrderEventListener)
           (com.lmax.api.orderbook OrderBookEventListener
                                   OrderBookSubscriptionRequest))
  (:gen-class))

(def conf)

;; lmax
;(def instrumentId 100437) ; 24/7 test instrument
(def instrumentId 4001) ; EURUSD
(def session nil)
(def heartbeat-frequency 720000)

;; redis
(def pool         (car/make-conn-pool))
(def spec-server1 (car/make-conn-spec))

(defmacro wcar [& body] `(car/with-conn pool spec-server1 ~@body))


;; utility functions

(defn log [& args]
  (spit "traderbot.log"
        (str (.format (new SimpleDateFormat "yyyy/MM/dd HH:mm:ss") (new Date)) ; prepend date
             " "
             (apply format args)
             "\n")
        :append true))

(defn lispify [x]
  (cond (= (type x) FixedPointNumber)
        (.longValue x)
        (= (type x) java.util.Collections$UnmodifiableRandomAccessList)
        (map #(list (.longValue (.getPrice %)) (.longValue (.getQuantity %))) (apply list x))
        :else x))

(defn objtosexpr [object]
  (str (apply list (map lispify (apply list (-> (dissoc (bean object) :class) seq flatten))))))

(defn heartbeatCallback []
  (proxy [HeartbeatCallback] []
    (onSuccess [token]
	       (log "sent heartbeat token : %s" token))
    (onFailure [failureResponse]
	       (log "send heartbeat failed : %s" failureResponse))))

(defn heartbeat-loop []
  (while (not (.isInterrupted (Thread/currentThread)))
    (Thread/sleep heartbeat-frequency)
    (.requestHeartbeat session (HeartbeatRequest. (str (System/currentTimeMillis))) (heartbeatCallback))))


(defn placedorderCallback []
  (proxy [OrderCallback] []
    (onSuccess [instructionId]
      (log "ordre passé : %s" (str instructionId)))
    (onFailure [failureResponse]
      (log "echec passage d'ordre : %s" failureResponse))))

(defn placeorder [rawmsg]
  (try
    (log "PlaceOrder %s" (last rawmsg))
    (if (= (first rawmsg) "message")
      (let [msg (apply hash-map (read-string (last rawmsg)))
            limit (:limit msg)
            quantity (:quantity msg)
            stoploss (:stoploss msg)
            stopprofit (:stopprofit msg)
            orderspec (fn [l q stop profit]
                        (LimitOrderSpecification. instrumentId
                                                  (FixedPointNumber/valueOf (long l))
                                                  (FixedPointNumber/valueOf (long (* q 1000000))) ; 1000000L = FixedPointNumber/ONE
                                                  com.lmax.api.TimeInForce/IMMEDIATE_OR_CANCEL
                                                  (FixedPointNumber/valueOf (long stop))
                                                  (if profit (FixedPointNumber/valueOf (long profit)) nil)))]
        (.placeLimitOrder session (orderspec limit quantity stoploss stopprofit) (placedorderCallback))))
    (catch Exception e
      (log "exception %s" e))))


;; callbacks

(defn defaultSubscriptionCallback []
  (proxy [Callback] []
    (onSuccess []
      (log "Default success callback"))
    (onFailure [failureResponse]
      (log "Default failure callback %s" failureResponse))))


(defn orderbookeventCallback []
  (proxy [OrderBookEventListener] []
    (notify [orderbookevent]
      (let [s (objtosexpr orderbookevent)]
        (log "OrderBookEvent : timestamp %s bid %s sexpr %s" (.getTimeStamp orderbookevent) (.longValue (.getValuationBidPrice orderbookevent)) s)
        (wcar (car/publish "OrderBookEvent" (objtosexpr orderbookevent)))))))

(defn ordereventCallback []
  (proxy [OrderEventListener] []
    (notify [order]
      (log "OrderEvent : %s" (str order))
      (wcar (car/publish "OrderEvent" (objtosexpr order))))))

(defn executioneventCallback []
  (proxy [ExecutionEventListener] []
    (notify [execution]
      (log "ExecutionEvent : %s" (str execution))
      (wcar (car/publish "ExecutionEvent" (objtosexpr execution))))))

(defn loginCallbacks []
  (proxy [LoginCallback] []
    (onLoginSuccess [session]
      (def session session)
      (log "Logged in, account details : %s" (.getAccountDetails session))
      ;; LMAX subscriptions
      (.registerOrderBookEventListener session (orderbookeventCallback))
      (.subscribe session (OrderBookSubscriptionRequest. instrumentId) (defaultSubscriptionCallback))
      (.registerOrderEventListener session (ordereventCallback))
      (.registerExecutionEventListener session (executioneventCallback))
      (.subscribe session (ExecutionSubscriptionRequest.) (defaultSubscriptionCallback))
      (.start (Thread. heartbeat-loop)) ; start heartbeat thread
      (.start session))
    (onLoginFailure [failureResponse]
      (log "Failed to login. Reason : %s" failureResponse))))

(defn login [name password demo]
  (let [url (if demo
              "https://testapi.lmaxtrader.com"
              "https://trade.lmaxtrader.com")
        prodtype (if demo
                   com.lmax.api.account.LoginRequest$ProductType/CFD_DEMO
                   com.lmax.api.account.LoginRequest$ProductType/CFD_LIVE)
        listen-orders (car/with-new-pubsub-listener
                        spec-server1 {"PlaceOrder" placeorder}
                        (car/subscribe "PlaceOrder"))]
    (log "logging in %s..." url)
    (.login (LmaxApi. url)
            (LoginRequest. name password prodtype)
            (loginCallbacks))))

;(defn forever []
(defn -main [& args]
  (let [conf (read-string (slurp "config.clj"))]
    (while true (do (login (:login conf) (:password conf) (:demo conf))
                    (log "Disconnected, try to login again...")))))


;(defn -main [& args]
;  (doto
;      (Thread. forever)
;    (.setDaemon true)
;    (.start)))