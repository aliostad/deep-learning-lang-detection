(ns elastic-ring.handler
  (:use compojure.core
        ring.middleware.json)
  (:import (com.fasterxml.jackson.core JsonGenerator))
  (:require [compojure.handler :as handler]
            [compojure.route :as route]
            [ring.util.response :refer [response]]
            [ring.middleware.keyword-params :refer [wrap-keyword-params]]
            [ring.middleware.params :refer [wrap-params]]
            [cheshire.generate :refer [add-encoder]]
            [elastic-ring.models.events :as events]
            [elastic-ring.auth :refer [auth-backend user-can user-isa user-has-id authenticated-user unauthorized-handler]]
            [buddy.auth.middleware :refer [wrap-authentication wrap-authorization]]
            [buddy.auth.accessrules :refer [restrict]]))

; Strip namespace from namespaced-qualified keywwords, which is how we represent user levels
(add-encoder clojure.lang.Keyword
             (fn [^clojure.lang.Keyword kw ^JsonGenerator gen]
               (.writeString gen (name kw))))

;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(defn- bounding-box-from-params [top_right_lat top_right_lon bottom_left_lat bottom_left_lon]
  {:top_right   {:lat (Double/parseDouble top_right_lat)
                 :lon (Double/parseDouble top_right_lon)}
   :bottom_left {:lat (Double/parseDouble bottom_left_lat)
                 :lon (Double/parseDouble bottom_left_lon)}})

;; =====================================================================

(defn create-event [{event :body}]
  (let [new-event (events/create event)]
    {:status  201
     :headers {"Location" (str "/events/" (:id new-event))}}))

(defn get-events [_]
  {:status 200
   :body   {:count   (events/count-events)
            :results (events/find-all)}})

(defn find-event [{{:keys [id]} :params}]
  (response (events/find-by-id (read-string id))))

(defn print-params [params]
  (println "Empfangen" params)
  {:status 200 :body "OK"})

(defn find-events-by-bounding-box [{params :params}]
  (response (events/find-by-bbox (bounding-box-from-params
                                   (params :top_right_lat) (params :top_right_lon)
                                   (params :bottom_left_lat) (params :bottom_left_lon)))))

(defn delete-event [{{:keys [id]} :params}]
  (events/delete-event {:id (read-string id)})
  {:status  204
   :headers {"Location" "/events"}})


;; =====================================================================

(defroutes app-routes
           ;; EVENTS
           (context "/events" []
             (GET "/" [] get-events)

             (POST "/" [] (-> create-event
                              (restrict {:handler  authenticated-user
                                         :on-error unauthorized-handler})))

             (GET "/by-test" [] print-params)
             (GET "/by-location" [] find-events-by-bounding-box)

             (context "/:id" [id]
               (restrict
                 (routes
                   (GET "/" [] find-event))
                 {:handler  {:and [authenticated-user (user-can "manage-events")]}
                  :on-error unauthorized-handler}))

             (DELETE "/:id" [id] (-> delete-event
                                     (restrict {:handler  {:and [authenticated-user (user-can "manage-users")]}
                                                :on-error unauthorized-handler}))))

           (route/not-found (response {:message "Page not found"})))

(defn wrap-log-request [handler]
  (fn [req]
    (println req)
    (handler req)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Main Entry Point
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(def app
  (-> app-routes
      (wrap-authentication auth-backend)
      (wrap-authorization auth-backend)
      (wrap-keyword-params)
      (wrap-params)  ;; turns 'query-string' into 'params' key-value map
      ;; (wrap-json-params)
      (wrap-json-response)
      (wrap-json-body {:keywords? true})))
