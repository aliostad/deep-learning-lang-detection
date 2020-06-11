(ns tyrant.web
  (:require [cheshire.core :as json]
            [clojure.string :refer [split]]
            [clojure.tools.logging :refer [info warn error]]
            [compojure
             [core :refer [defroutes context GET PUT POST DELETE]]
             [handler :as handler]
             [route :as route]]
            [environ.core :refer [env]]
            [metrics.ring
             [expose :refer [expose-metrics-as-json]]
             [instrument :refer [instrument]]]
            [radix
             [error :refer [wrap-error-handling error-response]]
             [ignore-trailing-slash :refer [wrap-ignore-trailing-slash]]
             [setup :as setup]
             [reload :refer [wrap-reload]]]
            [ring.middleware
             [format-params :refer [wrap-json-kw-params]]
             [format-response :refer [wrap-json-response]]
             [params :refer [wrap-params]]]
            [slingshot.slingshot :refer [try+]]
            [tyrant
             [environments :as environments]
             [store :as store]]))

(def json-content-type "application/json;charset=utf-8")

(def plain-text "text/plain;charset=utf-8")

(def category-regex #"application-properties|deployment-params|launch-data")

(def commit-regex #"HEAD~(?:\d+)?|HEAD|head~(?:\d+)?|head|[0-9a-fA-F]{40}")

(def env-regex #"dev|poke|prod")

(def version
  (setup/version "tyrant"))

(defn response
  [data & [content-type status]]
  {:status (or status 200)
   :headers {"Content-Type" (or content-type json-content-type)}
   :body data})

(defn unknown-environment-response
  []
  (response "Unknown environment" plain-text 404))

(defn- healthcheck
  []
  (let [environments-ok? (environments/environments-healthy?)
        github-ok? (store/github-healthy?)
        repos-ok? (store/repos-healthy?)]
    {:name "tyrant"
     :version version
     :success (and environments-ok? github-ok? repos-ok?)
     :dependencies [{:name "environments" :success environments-ok?}
                    {:name "git" :success github-ok?}
                    {:name "repos" :success repos-ok?}]}))

(defn- get-data
  [environment application commit category]
  (if-let [result (store/get-data environment application commit category)]
    (response result)
    (error-response (str "No data of type '" category "' for application '" application "' at revision '" commit "' - does it exist?") 404)))

(defn- get-list
  [environment application]
  (if-let [result (store/get-commits environment application)]
    (response {:commits result})
    (error-response (str "Application '" application "' does not exist.") 404)))

(defn- create-application
  [name]
  (try+
   (response (store/create-application name) json-content-type 201)
   (catch [:status 422] e
     (error-response (str "Could not create application '" name "', message: " (:message e)) 409))))

(defn- create-application-env
  [name environment]
  (try+
   (response (store/create-application-env name environment true) json-content-type 201)
   (catch [:status 422] e
     (error-response (str "Could not create environment repo '" environment "' for application '" name "', message: " (:message e)) 409))))

(defn known-environment?
  [environment]
  (contains? (environments/environments) (keyword environment)))

(defroutes applications-routes
  (GET "/"
       []
       (response {:applications (store/get-repository-list)}))

  (POST "/"
        [name]
        (create-application name))

  (GET ["/:environment"]
       [environment]
       (if (known-environment? environment)
         (response {:applications (store/get-repository-list environment)})
         (unknown-environment-response)))

  (GET ["/:environment/:application"]
       [environment application]
       (if (known-environment? environment)
         (get-list environment application)
         (unknown-environment-response)))

  (POST "/:environment/:application"
        [environment application]
        (if (known-environment? environment)
          (create-application-env application environment)
          (unknown-environment-response)))

  (GET ["/:environment/:application/:commit/:category" :commit commit-regex :category category-regex]
       [environment application commit category]
       (if (known-environment? environment)
         (get-data environment application commit category)
         (unknown-environment-response))))

(defroutes routes
  (context
   "/1.x" []

   (context "/applications"
            []
            applications-routes))

  (context "/applications"
           []
           applications-routes)

  (GET "/ping"
       []
       (response "pong" "text/plain" 200))

  (GET "/healthcheck"
       []
       (let [healthcheck-result (healthcheck)
             status (if (:success healthcheck-result) 200 500)]
         (response healthcheck-result json-content-type status)))

  (route/not-found (error-response "Resource not found" 404)))

(def app
  (-> routes
      (wrap-reload)
      (instrument)
      (wrap-error-handling)
      (wrap-ignore-trailing-slash)
      (wrap-json-response)
      (wrap-json-kw-params)
      (wrap-params)
      (expose-metrics-as-json)))
