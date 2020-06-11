(ns utilza.tcp
  (:require [clojure.core.async :as async])
  (:import (java.net Socket)
           (java.io PrintWriter InputStreamReader BufferedReader)))

;; adapted from http://nakkaya.com/2010/02/10/a-simple-clojure-irc-client/



(defn connect
  [address port bufsiz]
  (let [socket (Socket. address port)
        in-stream (BufferedReader. (InputStreamReader. (.getInputStream socket)))
        out-stream (PrintWriter. (.getOutputStream socket))
        out-chan (async/chan bufsiz)
        run? (atom true)
        kill-chan (async/chan)
        in-chan (async/chan bufsiz)]
    {:in-stream in-stream
     :out-stream out-stream
     :out-chan out-chan
     :run? run?
     :kill-chan kill-chan
     :in-chan in-chan
     :in-thread  (future  (while @run?
                            (let [msg (.readLine in-stream)]
                              (async/>!! in-chan msg))))
     :out-thread (future
                   (loop []
                     (let [[msg c] (async/alts!!  [out-chan kill-chan])]
                       (if (= c kill-chan)
                         nil
                         (do
                           (doto out-stream
                             (.println msg)
                             (.flush))
                           (recur))))))}))




(defn disconnect
  [{:keys [run? kill-chan in-thread out-thread in-stream out-stream in-chan out-chan socket]}]
  (future
    (reset! run? false)
    (async/>!! kill-chan :done)
    (.close in-stream)
    (.close out-stream)
    (.close socket)
    (async/close! out-chan)
    (async/close! in-chan)
    (async/close! kill-chan)
    (try 
      (when (and in-thread (not (realized? in-thread))) (future-cancel in-thread))
      (catch Exception e
        nil))
    (try
      (when (and out-thread (not realized? out-thread)) (future-cancel out-thread))
      (catch Exception e
        nil))))







;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
(comment

  (def foo (connect "localhost" 1632 10))

  (async/>!! (:out-chan foo) "fooobar")
  
  (async/<!! (:in-chan foo))


  (disconnect foo)
  
  )