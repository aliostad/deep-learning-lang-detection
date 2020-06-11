(ns document-pattern.core
  (:require [bidi.ring :refer [make-handler]]
            [metrics.ring.expose :refer [expose-metrics-as-json]]
            [metrics.ring.instrument :refer [instrument]]
            [document-pattern.mongodb :refer [connect-to-db disconnect]]
            [ring.adapter.jetty :as jetty]
            [document-pattern.config :refer [load-config config]]
            [document-pattern.resources :as res])
  (:gen-class))

(defn exit-with-error-msg [msg]
  (doall (println msg)
         (System/exit -1)))

(def handlers (make-handler res/routes res/handlers))

(def admin-handler (expose-metrics-as-json {:status 200}))

(def measured-handlers (instrument handlers))

(defn destroy [] (disconnect))

(defn boot [config]
  (let [{:keys [admin-port port]} (:http config)]
    (connect-to-db (:mongodb config))
    (jetty/run-jetty measured-handlers
                     {:port    port
                      :join?   false
                      :destory destroy})
    (jetty/run-jetty admin-handler
                     {:port    admin-port
                      :join?   false
                      :destroy destroy})))

(defn -main [& args]
  (if
    (nil? args) (exit-with-error-msg "Must provide path to yaml config as first arg")
                (->
                  (load-config args)
                  (boot))))
