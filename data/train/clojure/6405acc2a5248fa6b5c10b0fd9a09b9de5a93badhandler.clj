(ns restful-clojure.handler
  (:use compojure.core
        ring.middleware.json
        restful-clojure.auth)
  (:import (com.fasterxml.jackson.core JsonGenerator))
  (:require [compojure.handler :as handler]
            [compojure.route :as route]
            [cheshire.generate :refer [add-encoder]]
            [ring.util.response :refer [response]]
            [restful-clojure.models.users :as users]
            [restful-clojure.models.lists :as lists]
            [restful-clojure.models.products :as products]
            [buddy.auth.middleware :refer [wrap-authentication wrap-authorization]]
            [buddy.auth.accessrules :refer [restrict]]))

(add-encoder clojure.lang.Keyword
  (fn [^clojure.lang.Keyword kw ^JsonGenerator gen]
    (.writeString gen (name kw))))

(defn get-users [_]
  {:status 200
   :body {:count (users/count-users)
          :results (users/find-all)}})

(defn create-user [{user :body}]
  (println user)
  (let [new-user (users/create user)]
    {:status 201
     :headers {"Location" (str "/users/" (:id new-user))}}))

(defn find-user [{{:keys [id]} :params}]
  (response (users/find-by-id (read-string id))))

(defn lists-for-user [{{:keys [id]} :params}]
  (response (lists/find-all-by :user_id (read-string id))))

(defn delete-user [{id :id}])

(defroutes app-routes
  (context "/users" []
    (GET "/" [] (-> get-users
                    (restrict {:handler {:and [authenticated-user
                                               (user-can "manage-users")]}
                                         :on-error unauthorized-handler})))
    (POST "/" [] create-user)
    (context "/:id" [id]
      (restrict
        (routes
          (GET "/" [] find-user)
          (GET "/lists" [] lists-for-user))
        {:handler {:and [authenticated-user
                         {:or [(user-can "manage-users")
                               (user-has-id (read-string id))]}]}
         :on-error unauthorized-handler}))
    (DELETE "/:id" [id]
      (-> delete-user
          (restrict {:handler {:and [authenticated-user
                                     (user-can "manage-users")]}
                     :on-error unauthorized-handler}))))
  (route/not-found
    (response {:message "Page not found"})))

(defn wrap-log-request [handler]
  (fn [request]
    (println request)
    (handler request)))


(def app
  (-> app-routes
    (wrap-authentication auth-backend)
    (wrap-authorization auth-backend)
    wrap-json-response
    (wrap-json-body {:keywords? true})))



