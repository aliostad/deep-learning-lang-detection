(ns clj-common.logging)

(require '[clj-common.localfs :as fs])
(require '[clj-common.path :as path])
(require '[clj-common.jvm :as jvm])
(require '[clj-common.edn :as edn])

(def logger (agent nil))

(defn report [object]
  (send
    logger
    (fn [possible-output-stream]
      (let [output-stream (if (some? possible-output-stream)
                            possible-output-stream
                            (fs/output-stream
                              (path/child
                                (jvm/jvm-path)
                                "logging")))]
        (edn/write-object output-stream object)
        (.flush output-stream)
        output-stream)))
  nil)
