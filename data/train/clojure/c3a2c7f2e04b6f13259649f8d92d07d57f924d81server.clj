;; Copyright (C) 2011, Jozef Wagner. All rights reserved. 

(ns dredd.server
  "Server management for dredd web app"
  (:import (org.mortbay.jetty Server))  
  (:require [ring.adapter.jetty :as adapter]
            [dredd.local-settings :as settings]))

;; Web server management. Purpose of this ns is to start and manage
;; web server which runs the dredd. Jetty is used as a web server.
;; Servlets and Application containers are not supported.
;; Server settings are stored in dredd.local-settings/server

;;;; Implementation details

;; Because we want to be able to shutdown the server with a dedicated
;; function callable from anywhere, we have to keep server instance in
;; a separate Var.

(defonce ^{:private true
           :doc "Holds the current server instance"
           :tag Server}
  server nil)

(comment
  ;; On not using atom for storing server:
  ;; It is useless to store server instance inside atom. We want only
  ;; one server at time, so we have to test whether server is nil before
  ;; we create a server. That would require us to put server creation
  ;; inside swap! which can result in multiple calls to server creation,
  ;; which is of course bad.

  (or @server
      ;; race condition here
      (reset! server (adapter/run-jetty app nil)))

  ;; Above approach is also not good because it introduces a race
  ;; condition. The only feasible way is to use old fashioned locks.
)

(defonce ^{:private true
           :doc "Monitor for locking"}
  monitor (Object.))

(def ^{:private true
       :doc "Graceful Shutdown timeout"}
  graceful-timeout 5000)                ; IMO not important enough to
                                        ; put in local settings

;;;; Public API

(defn start-and-wait! [app]
  "Starts web server with supplied app. Blocks until server is stopped.
  Throws RuntimeException if server already started.
  Server settings are in dredd.local-settings/server"
  (io!)
  (locking monitor                      ; eliminate race conditions
    (when server
      (throw (RuntimeException. "Server is already running")))
    (let [params (merge {:join? false} settings/server)
          s (doto (adapter/run-jetty app params)
              (.setGracefulShutdown graceful-timeout))]
      (alter-var-root #'server (fn [_] s))))
  (try 
    (.join server)                      ; blocks here
    (finally
     (alter-var-root #'server (fn [_] nil)))))

(defn start! [app]
  "Starts web server with supplied app. Does not block.
  Throws RuntimeException if server already started.
  Dereferencing returned value will block until server stops."
  (io!)
  (locking monitor
    (when server
      (throw (RuntimeException. "Server is already running")))
    (future
      (start-and-wait! app))))

(defn shutdown! []
  "Shuts down a running server. Do nothing if server
  is not running. Do not wait for actual server to shut down.
  Dereferencing returned value will block until server stops."
  (io!)
  (when-let [s server]                  ; Get local copy because of
    (future (.stop s))))                ; concurrency.    
