;; # Beth REPL
;; This namespace is used only to handle the code reloading from the
;; REPL. As this namespace doesn't define anything it shouldn't
;; require reloading that often. This is essential for the refresh
;; stuff to work properly. See the documentation of the
;; clojure.tools/namespace.repl package.

(ns beth.clj.repl
  (:require [beth.clj.server]
            [cemerick.piggieback :as pback]
            [cljs.repl.browser :as cljsBrowser]
            [clojure.repl :as cRepl]
            [clojure.tools.namespace.repl :as nRepl]))

;; Don't reload this namespace! This makes sure the refresh function
;; works properly.
(nRepl/disable-reload!)

(def server (atom nil))

(defn cljs-repl
  []
  (pback/cljs-repl
    (cljsBrowser/repl-env)))

(defn- save-server-handle
  "Internal function to manage the server handle. It is stored in an
   atom to not make the user fiddle with it."
  [handler]
  (if (instance? java.io.Closeable handler)
    (swap! server (constantly handler))
    (cRepl/pst)))

(defn restart
  "Use this function to refresh the server, for example after changing
   the clojure part of the application. Needs to be given the already
   running server to work properly."
  []
  (when @server
    (.close @server))
  (-> (nRepl/refresh :after 'beth.clj.server/start-server)
      (save-server-handle)))

(defn stop
  "Stop the running server"
  []
  (when @server
    (.close @server)))

(defn start
  "Run the server and print usage information."
  []
  (when @server
    (throw
      (Exception. "Server already running. Use '(restart)' to restart!")))
  (println "Starting the server. To restart call '(restart)'.")
  (-> (beth.clj.server/start-server)
      (save-server-handle)))
