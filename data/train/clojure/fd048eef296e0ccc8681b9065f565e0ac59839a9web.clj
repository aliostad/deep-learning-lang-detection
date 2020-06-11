(ns ordinator.web
  (:require [ordinator
             [catalogue :as cat]
             [auth :refer [wrap-json-authenticate login-form]]
             [page-frame :refer [page-frame]]
             [order :as order]
             [collation :as col]]
            [compojure
             [core :refer [defroutes context GET PUT POST DELETE]]
             [route :as route]]
            [environ.core :refer [env]]
            [metrics.ring
             [expose :refer [expose-metrics-as-json]]
             [instrument :refer [instrument]]]
            [prone.middleware :refer [wrap-exceptions]]
            [radix
             [error :refer [error-response wrap-error-handling]]
             [ignore-trailing-slash :refer [wrap-ignore-trailing-slash]]
             [reload :refer [wrap-reload]]
             [setup :as setup]]
            [ring.middleware
             [format-params :refer [wrap-json-kw-params]]
             [json :refer [wrap-json-response]]
             [params :refer [wrap-params]]
             [session :refer [wrap-session]]
             [keyword-params :refer [wrap-keyword-params]]
             [nested-params :refer [wrap-nested-params]]]
            [cemerick.friend :as friend]
            [marianoguerra.friend-json-workflow :as json-auth]
            [ring.util.response :refer [response]]
            [clojure.tools.logging :as log]))

(def version
  (setup/version "ordinator"))

(def dev-mode?
  (boolean (env :dev-mode false)))

(defn healthcheck
  []
  (let [body {:name "ordinator"
              :version version
              :success true
              :dependencies []}]
    {:headers {"content-type" "application/json"}
     :status (if (:success body) 200 500)
     :body body}))

(defn get-catalogue
  []
  {:status 200
   :body (cat/get-catalogue)})

(defn update-catalogue
  []
  {:status 200
   :body (cat/update-catalogue)})

(defn get-user-order
  [user orderdate]
  (let [order (order/get-user-order user orderdate)]
    (prn "get-user-order order" order)
    {:status 200
     :body order}))

(defn save-user-order
  [{:keys [route-params body-params]}]
  (order/save-user-order (merge route-params body-params))
  {:status 200})

(defn get-all-orders
  [orderdate]
  (let [collation (col/collate-orders orderdate)]
    {:status 200
     :body collation}))

(defn update-all-orders-code
  [{:keys [route-params body-params]}]
  (col/update-order-line (merge route-params body-params))
  {:status 200})

(defn delete-all-orders-code
  [orderdate code]
  (prn "delete-all-orders-code orderdate" orderdate "code" code)
  (col/delete-order-line orderdate code)
  {:status 200})

(defroutes user-routes
  (GET "/:user/orders/:orderdate"
       [user orderdate]
       (get-user-order user orderdate))

  (PUT "/:user/orders/:orderdate" req
       (save-user-order req)))

(defroutes collation-routes
    (GET "/:orderdate"
       [orderdate]
       (get-all-orders orderdate))

  (PUT "/:orderdate/:code" req
       (update-all-orders-code req))

  (DELETE "/:orderdate/:code"
          [orderdate code]
          (delete-all-orders-code orderdate code)))

(defroutes admin-routes
    (PUT "/catalogue"
       [] (update-catalogue)))

(defroutes routes

  (GET "/healthcheck"
       [] (healthcheck))

  (GET "/ping"
       [] "pong")

  (GET "/"
       [] (page-frame dev-mode?))

  (GET "/login"
       request (json-auth/handle-session request))

  (POST "/login"
       request (json-auth/handle-session request))

  (DELETE "/login"
          request (json-auth/handle-session request))

  (context
   "/users" req
   (friend/wrap-authorize user-routes #{:ordinator.auth/user}))

  (context
   "/orders" req
   (friend/wrap-authorize collation-routes #{:ordinator.auth/coordinator}))

  (context
   "/" req
   (friend/wrap-authorize admin-routes #{:ordinator.auth/admin}))

  (GET "/catalogue"
       [] (get-catalogue))

  (route/resources "/")

  (route/not-found (error-response "Resource not found!" 404)))

(defn mywrapper [{:keys [session] :as handler}]
  (fn [request]
    (let [response (handler request)]
      (log/info "req : " (:request-method request) (:uri request) ":session" (:session request))
      (log/info "resp: :status" (:status response))
      response)))

(def app
  (-> routes
      (mywrapper)
      (wrap-reload)
      (instrument)
      (wrap-ignore-trailing-slash)
      (wrap-json-response)
      (wrap-json-kw-params)
      (wrap-nested-params)
      (wrap-params)
      (expose-metrics-as-json)))

(def secure-app
  (-> app
      (wrap-json-authenticate)
      (wrap-session)
      (wrap-error-handling)
      (wrap-json-response)))
