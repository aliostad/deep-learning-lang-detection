(ns twitter.core
  (:gen-class)
  (:require [clojure.core.async :refer [>! <! <!! >!! chan go-loop go]]
            [twitter.db :as db]
            [twitter.twitter-client :as tw]
            [clojure.tools.logging :as log]
            [environ.core :refer [env]])
  (:import java.util.concurrent.LinkedBlockingQueue))

(defn create-queue [num] (LinkedBlockingQueue. num))

(defn consumer [queue ch exch]
  (go-loop []
    (try
      (when-let [status (.poll queue)]
        (>! ch status))
      (catch Exception e (>! exch e)))
    (recur)))

(defn writer [conn ch exch]
  (doseq [n (range 10)] ;; 10-thread writer! Adjustable?
    (go-loop []
      (try
        (do
          (log/info "Writing tweet to DB")
          (db/write-to-db conn (<! ch)))
        (catch Exception e (>! exch e)))
      (recur))))

(defn run [db-conn queue ch exch terms]
  (try
    (do (consumer queue ch exch)
        (writer db-conn ch exch)
        (tw/connect-queue queue terms))
    (catch Exception e (>!! exch e))))

(defn -main [& args]

  ;; Monger creates its own pool so we let it manage its own
  ;; reconnects and threadpool.
  (log/debug (str "Connecting to Mongo URL: " (env :mongo-host)))
  (let [db-conn (db/connect-to-db (env :mongo-host))
        terms (db/get-terms db-conn)]
    (loop []

      ;; For everything else, we restart everything on an error.
      (log/debug (str "Starting Main Process with terms: " terms))
      (let [queue (create-queue 1000)
            exch (chan)
            ch (chan)
            client (run db-conn queue ch exch terms)
            error (<!! exch)]
        (do
          (log/error error "Error in channel!")
          (.stop client)))
      (recur))))
