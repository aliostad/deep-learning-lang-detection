(ns eu.stratuslab.cimi.app.server
  "Implementation of the ring application used to create the
   servlet instance for a web application container."
  (:require [cemerick.friend :as friend]
            [clojure.tools.logging :as log]
            [compojure.handler :as handler]
            [eu.stratuslab.authn.workflows.authn-workflows :as aw]
            [eu.stratuslab.cimi.db.cb.utils :as db-cb-utils]
            [eu.stratuslab.cimi.db.couchbase :as db-cb]
            [eu.stratuslab.cimi.db.dbops :as db]
            [eu.stratuslab.cimi.middleware.base-uri :refer [wrap-base-uri]]
            [eu.stratuslab.cimi.middleware.exception-handler :refer [wrap-exceptions]]
            [eu.stratuslab.cimi.app.routes :as routes]
            [metrics.core :refer [default-registry]]
            [metrics.jvm.core :refer [instrument-jvm]]
            [metrics.ring.expose :refer [expose-metrics-as-json]]
            [metrics.ring.instrument :refer [instrument]]
            [org.httpkit.server :refer [run-server]]
            [ring.middleware.json :refer [wrap-json-body
                                          wrap-json-response]]
            [eu.stratuslab.cimi.resources.cloud-entry-point :as cep]
            [cemerick.friend.credentials :as creds]
            [eu.stratuslab.cimi.resources.user :as user]))

(def admin-id-map {:current         "admin"
                   :authentications {"admin" {:identity "admin"
                                              :roles    ["::ADMIN"]}}})

(defn set-dbops-value
  [cb-cfg-file]
  (-> cb-cfg-file
      (db-cb-utils/create-cb-client)
      (db-cb/create)
      (db/set-impl!)))

(defn create-cep
  "Checks to see if the CloudEntryPoint exists in the database;
   if not, it will create one.  The CloudEntryPoint is the core
   resource of the service and must exist."
  []
  (if (cep/add)
    (log/info "created CloudEntryPoint")
    (do
      (log/warn "did NOT create CloudEntryPoint")
      (try
        (binding [friend/*identity* admin-id-map]
          (db/retrieve cep/resource-name))
        (log/warn "CloudEntryPoint exists")
        (catch Exception e
          (log/error "problem retrieving CloudEntryPoint: " (str e)))))))

(defn random-password
  "A random password of 12 characters consisting of the ASCII
   characters between 40 '(' and 95 '_'."
  []
  (let [valid-chars (map char (concat (range 48 58)
                                      (range 65 91)
                                      (range 97 123)))]
    (reduce str (for [_ (range 12)] (rand-nth valid-chars)))))

(defn create-admin
  "Checks to see if the User/admin entry exists in the database;
   if not, it will create one with a randomized password.  The
   clear text password will be written to the service log."
  []
  (binding [friend/*identity* admin-id-map]
    (try
      (let [id (str user/resource-name "/admin")]
        (db/retrieve id)
        (log/info id "exists"))
      (catch Exception e
        (let [password (random-password)
              admin {:first-name "cloud"
                     :last-name  "administrator"
                     :username   "admin"
                     :password   (creds/hash-bcrypt password)
                     :enabled    true
                     :roles      ["::ADMIN"]
                     :email      "change_me@example.com"}]
          (try
            (db/add admin)
            (log/warn "User/admin entry created; initial password is" password)
            (catch Exception e
              (log/error "Error occurred while trying to create User/admin entry:" (str e)))))))))

(defn create-cep-admin
  []
  (create-admin)
  (create-cep))

(defn- create-ring-handler
  "Creates a ring handler that wraps all of the service routes
   in the necessary ring middleware to handle authentication,
   header treatment, and message formatting."
  []
  (log/info "creating ring handler")

  (let [workflows (aw/get-workflows)]
    (if (empty? workflows)
      (log/warn "NO authn workflows configured"))

    (instrument-jvm default-registry)

    (-> (friend/authenticate (routes/get-main-routes)
                             {:allow-anon?         true
                              :login-uri           "/cimi/login"
                              :default-landing-uri "/cimi/webui"
                              :credential-fn       (constantly nil)
                              :workflows           workflows})
        ;(handler/site {:session {:store (couchbase-store cb-client)}})  FIXME: Update to general DB.
        (handler/site)
        (wrap-exceptions)
        (wrap-base-uri)
        (expose-metrics-as-json "/cimi/metrics" default-registry {:pretty-print? true})
        (wrap-json-body)
        (wrap-json-response {:pretty true :escape-non-ascii true})
        (instrument default-registry))))

(defn- start-container
  "Starts the http-kit container with the given ring application and
   on the given port.  Returns the function to be called to shutdown
   the http-kit container."
  [ring-app port]
  (log/info "starting the http-kit container on port" port)
  (run-server ring-app {:port port :ip "127.0.0.1"}))

(declare stop)

(defn- create-shutdown-hook
  [state]
  (proxy [Thread] [] (run [] (stop state))))

(defn register-shutdown-hook
  "This function registers a shutdown hook to close the database
   client cleanly and to shutdown the http-kit container when the
   JVM exits.  This only needs to be called in a context in which
   the stop function will not be explicitly called."
  [state]
  (let [hook (create-shutdown-hook state)]
    (.. (Runtime/getRuntime)
        (addShutdownHook hook))
    (log/info "registered shutdown hook")))

(defn start
  "Starts the CIMI server and returns a map with the application
   state containing the Couchbase client and the function to stop
   the http-kit container."
  [port cb-cfg-file]
  (set-dbops-value cb-cfg-file)
  (db/bootstrap)
  (create-cep-admin)
  (let [stop-fn (-> (create-ring-handler)
                    (start-container port))]
    {:stop-fn stop-fn}))

(defn stop
  "Stops the http-kit container and shuts down the Couchbase
   client.  Takes the global state map generated by the start
   function as the argument."
  [{:keys [stop-fn]}]
  (log/info "shutting down database client")
  (db/close)
  (log/info "shutting down http-kit container")
  (if stop-fn
    (stop-fn)))
