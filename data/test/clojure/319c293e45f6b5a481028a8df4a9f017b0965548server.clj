(ns athens.server
  (:gen-class)
  (:require [athens.db.manage :as db])
  (:use clojure.stacktrace
        [ring.adapter.jetty :only (run-jetty)]
        ring.middleware.params
        ring.middleware.keyword-params
        ring.middleware.nested-params
        ring.middleware.session
        ring.middleware.format
        [athens.middleware.routes :only (routes)]
        [athens.middleware.auth :only (auth)]
        [athens.middleware.db-session-store :only (db-session-store)]))

(defn wrap-exception [f]
  (fn [request]
    (try (f request)
      (catch Exception e
        (do
          (.printStackTrace e)
          {:status 500
           :body "Exception caught"})))))

(defn debug [f]
  (fn [{:keys [uri request-method params session] :as request}]
    (println params)
    (f request)))

(defn wrap
  [to-wrap]
  (-> to-wrap
      (wrap-session {:cookie-name "athens-session" :store (db-session-store {})})
      (wrap-restful-format :formats [:json-kw])
      wrap-exception
      wrap-keyword-params
      wrap-nested-params
      wrap-params))

; The ring app
(def app
  (-> routes
      auth
      ;; debug
      wrap))

(defn -main
  "Start the jetty server"
  []
  (run-jetty #'app {:port (Integer. (get (System/getenv) "PORT" 8080)) :join? false}))
