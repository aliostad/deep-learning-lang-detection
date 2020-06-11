(ns usersvc.handler
  (:require [compojure.core :refer [defroutes POST GET]]
            [ring.middleware.defaults :refer [wrap-defaults api-defaults]]
            [metrics.ring.instrument :refer [instrument]]
            [metrics.ring.expose :refer [render-metrics]]
            [ring.util.http-response :as resp]
            [compojure.route :as route]
            [clojure.data.json :as json]
            [usersvc.db :as db]
            [usersvc.schema :as schema])
  (:use [org.httpkit.server :only [with-channel send! run-server]]))

(defn- body->map [req]
  (-> req :body slurp (json/read-str :key-fn clojure.core/keyword)))

(def error->response
  {:duplicated-email (resp/conflict (json/write-str {:message "email already exists"}))})

(defn get-response [error-code]
  (error-code error->response))

(defn async-response [req resp]
  (with-channel req channel (send! channel resp)))

(defn new-user-handler [req]
  (let [body (body->map req)
        resp (if-not (schema/is-valid-new-user? body)
               (resp/bad-request)
               (if-let [error-code (:error (db/new-user body))]
                 (get-response error-code)
                 (resp/accepted)))]
    (async-response req resp)))

(defn not-found-handler [req]
  (async-response req (resp/not-found)))

(defn metrics-handler [req]
  (async-response req (resp/ok (json/write-str (render-metrics)))))

(defroutes app-routes
           (POST "/users" [] new-user-handler)
           (GET "/metrics" [] metrics-handler)
           (route/not-found not-found-handler))

(def controller
  (-> app-routes
      (instrument)
      (wrap-defaults api-defaults)))

(defn run []
  (run-server controller {:port 3000 :thread 16}))
