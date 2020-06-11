(ns net-protocols.examples.console-server.client
  (:refer-clojure :exclude [read flush read-line])
  (:use [net-protocols.streams.base :as stream]
        [net-protocols.streams.tcp  :as tcp]
        [net-protocols.control.core :as ctrl]
        [clojure.string :as str :only [trim]]))

(defn authenticate [stream username password]
  (doto stream
    (ctrl/challenge-response #"Username" (str username "\n"))
    (ctrl/challenge-response #"Password" (str password "\n"))))

(defn read-version [stream]
  (ctrl/challenge-response stream #"console>>" "version\n")
  (str/trim (ctrl/read-until stream \newline)))

(defn get-version []
  (with-open [stream (tcp/connect "localhost" 12345)]
    (-> stream
        (authenticate "bob" "bob")
        read-version)))

(defn main []
  (println "starting client")
  (try
    (println (get-version))
    (catch Exception _ (println "The server did not respond in time"))))
