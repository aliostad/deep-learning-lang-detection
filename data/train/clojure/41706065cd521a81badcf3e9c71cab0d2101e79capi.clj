(ns bfg.betfair.api
  (:require
   [taoensso.timbre :as timbre]
   [org.httpkit.client :as http]
   [clojure.core.async :as a]))

(def basic-request-body
    {:method :post
     :timeout 4000
     :keepalive 30000
     :headers {"Accept" "application/json"}})

(defmulti message-handler
  "Message handler for betfair api calls"
  (fn [_ {:keys [dispatch]}] (first dispatch)))

(defmethod message-handler :list-event-types list-event-types [betfair message]
  (let [url (str (get-in betfair [:config :betting-api]) "/listEventTypes")
        body (:msg message)
        token (:token betfair)
        app-key (get-in betfair [:config :app-key])
        request (merge basic-request-body {:url url
                                           :body body
                                           :headers {"X-Authentication" token
                                                     "X-Application" app-key}})
        database (:database betfair)]
    (http/request request (fn [response] 1))))

(defmethod message-handler :list-competitions list-competitions [dispatch]
  (println (rest dispatch)))

(defmethod message-handler :list-time-ranges list-time-ranges [dispatch]
  (println (rest dispatch)))

(defmethod message-handler :list-events list-events [dispatch]
  (println (rest dispatch)))

(defmethod message-handler :list-market-types list-market-types [dispatch]
  (println (rest dispatch)))

(defmethod message-handler :list-countries list-countries [dispatch]
  (println (rest dispatch)))

(defmethod message-handler :list-venues list-venues [dispatch]
  (println (rest dispatch)))

(defmethod message-handler :default default [dispatch]
  (timbre/error "Message not found this is deafult case"))

