(ns ^{:doc "Manage the web facing part of the application"}
    chaperone.web.core
    (:use [clojure.core.async :only [go <!]]
          [while-let.core])
    (:require [chaperone.web.rpc :as rpc]
              [chaperone.web.session :as session]
              [org.httpkit.server :as server]
              [environ.core :as env]
              [compojure.core :as comp]
              [compojure.handler :as handler]
              [compojure.route :as route]
              [ring.middleware.cookies :as cookies]
              [selmer.parser :as selmer]
              [dieter.core :as dieter]
              [chaperone.web.websocket :as ws]
              [cljs-uuid.core :as uuid]))

;;; system tools
(defn create-sub-system
    "Create the persistence system. Takes the existing system details"
    [system]
    (let [sub-system {:port   (env/env :web-server-port 8080)
                      :dieter {:engine     :v8
                               :compress   false ; minify using Google Closure Compiler & Less compression
                               :cache-mode :production ; or :production. :development disables cacheing
                               }}]
        (assoc system :web sub-system)))

(defn sub-system
    "get the web system from the global"
    [system]
    (:web system))

;;; logic
(defn- websocket-rpc-handler
    "Handle websocket requests"
    [system request]
    (let [ws (ws/sub-system system)]
        (server/with-channel request client
                             (ws/websocket-on-connect! system request client)
                             (server/on-close client (ws/websocket-on-close! system client))
                             (server/on-receive client (ws/websocket-on-recieve! system client)))))

(defn- index-page
    "Render the index page"
    [web cookies]
    (let [cookies (session/manage-session-cookies cookies)]
        {:cookies cookies
         :body    (selmer/render-file "views/index.html"
                                      {:less (dieter/link-to-asset "main.less" (:dieter web))}
                                      {:tag-open \[ :tag-close \]})}))

(defn- create-routes
    [system]
    (let [web (sub-system system)]
        (comp/routes
            (comp/GET "/" {cookies :cookies} (index-page web cookies))
            (comp/GET "/rpc" [] (partial websocket-rpc-handler system))
            (route/resources "/public")
            (route/not-found "<h1>404 OMG</h1>"))))

(defn site
    "Creates a handler specific to what we need in this application. Cookies, but no session"
    [routes]
    (-> routes
        handler/api
        cookies/wrap-cookies))

(defn run-server
    "runs the server, and returns the stop function"
    [system]
    (let [web (sub-system system)
          port (:port web)]
        (server/run-server (-> (site (create-routes system)) (dieter/asset-pipeline (:dieter web))) {:port port})))

(defn start!
    "Start the web server, and get this ball rolling"
    [system]
    (let [web (sub-system system)
          port (:port web)]
        (println "Starting server on port " port)
        (if-not (:server web)
            (assoc system :web
                          (assoc web :server (run-server system)))
            system)))

(defn stop!
    "Oh noes. Stop the server!"
    [system]
    (let [web (sub-system system)]
        (when web
            (when (:server web)
                ((:server web)))))
    system)