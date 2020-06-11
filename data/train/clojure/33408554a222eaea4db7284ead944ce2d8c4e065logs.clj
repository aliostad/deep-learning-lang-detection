(ns vivd.api.containers.logs
  (:require [immutant.web.sse :as sse]
            [vivd.index :as index]
            [clojure.java.io :as io]
            [clojure.tools.logging :as log]))

(defn- docker-logs-proc ^Process [docker-container-id]
  (-> (ProcessBuilder.
       (into-array ["docker" "logs" "--timestamps" "--tail=100" "-f" docker-container-id]))
      (.start)))

(defn- prepare-line [^String str]
  (if (and str (.startsWith str "["))
    (-> str
        (.substring 1)
        (.replaceFirst "\\]" ""))
    str))

(defn- stream-to-channel [stream ch]
  (let [reader ^java.io.BufferedReader (io/reader stream)]
    (loop []
      (let [line (.readLine reader)
            line (prepare-line line)]
        (if line
          (do
            (sse/send! ch line)
            (recur)))))))

(defn- stream-to-channel-thread [stream ch]
  (doto (Thread. ^Runnable (partial stream-to-channel stream ch))
    (.setName "docker-log-stream")
    (.start)))

(defn- make-log-stream-context [_ docker-container-id ch]
  (let [proc   (docker-logs-proc docker-container-id)
        stream (.getInputStream proc)
        thread (stream-to-channel-thread stream ch)]
    {:proc   proc
     :thread thread}))

(defn- destroy-log-stream-context [{:keys [^Process proc ^Thread thread]}]
  (.interrupt thread)
  (.destroy proc))

(defn- stream-container-logs [request docker-container-id]
  (let [context (atom {})]
    (sse/as-channel request
                    :on-open (fn [ch]
                               (swap! context make-log-stream-context docker-container-id ch))
                    :on-close (fn [_ _]
                                (swap! context destroy-log-stream-context)))))

(defn container-logs [{:keys [index] :as services} request id]
  (if-let [{:keys [docker-container-id]} (index/get index id)]
    (stream-container-logs request docker-container-id)
    {:status 404}))


