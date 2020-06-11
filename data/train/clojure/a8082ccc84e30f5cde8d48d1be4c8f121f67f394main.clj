(ns s7p.slave.main
  (:gen-class)
  (:require
   [clojure.tools.logging :as log]
   [clojure.core.async :refer [thread close! chan >!! <!!]]
   [cheshire.core :as json]
   [zeromq.zmq :as zmq]
   [s7p.config :as config]
   [s7p.slave.manage :as manage]
   [s7p.slave.core :as core]))


(defn make-request-handler [reciever ch]
  (thread
    (loop []
      (let [json (zmq/receive-str reciever)
            req (json/parse-string json true)]
        (>!! ch req)
        (recur)))))

(defn make-command-listener [sub]
  (thread
    (loop []
      (let [cmd (-> (zmq/receive-str sub)
                    (json/parse-string true))]
        (case (:command cmd)
          "create-dsp" (do
                         (println (:data cmd))
                         (manage/add-dsp    (:data cmd)))
          "remove-dsp" (do
                         (println (:data cmd))
                         (manage/remove-dsp (:data cmd)))
          "sync-dsps"   (do
                         (println (:data cmd))
                         (manage/sync-dsps (:data cmd)))))
      (recur))))


(defn -main [& args]
  (let [ch (chan 100)
        context (zmq/zcontext 1)
        workers (manage/make-workers ch 1024)
        [command-addr req-addr] args
        ]
    (with-open [sub (doto (zmq/socket context :sub)
                      (zmq/connect command-addr)
                      (zmq/subscribe ""))
                receiver (doto (zmq/socket context :pull)
                           (zmq/connect req-addr))]
      (let [request-handler  (make-request-handler receiver ch)
            command-listener (make-command-listener sub)]
        (<!! command-listener)
        (<!! request-handler)))))
