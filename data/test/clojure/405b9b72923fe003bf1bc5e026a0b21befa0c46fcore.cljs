(ns edfp.core
  (:require-macros [cljs.core.async.macros :refer [go go-loop]])
  (:require [cljs.nodejs :as node]
            [cljs.core.async :as async]))

(def ^:private temp (node/require "temp"))
(def ^:private fs (node/require "fs"))

(def ^:private tmpfile-prefix "edfp")


(defn stream->chan [stream]
  (let [c (async/chan)]
    (.on stream "data"
         (fn [data]
           (if data (go (async/>! c data)))))
    c))

(defn chan-onto-stream [c stream]
  (go-loop [data (async/<! c)]
           (if data
             (do
               (.write stream data)
               (recur (async/<! c)))
             (do
               (async/close! c)
               (.end stream)))))


(def chunk-count (atom 0))
(defn main [args]
  (.track temp)
  (let [tmp-stream (.createWriteStream temp)
        tmp-path   (.-path tmp-stream)]
    (.on (.pipe (.-stdin node/process) tmp-stream) "finish"
         (fn []
           (let [new-paths ]
             (.pipe (.createReadStream fs (.-path tmp-stream))
                    (.-stdout node/process)))))))

(defn- -main [& args]
  (node/enable-util-print!)
  (main args))

(set! *main-cli-fn* -main)
