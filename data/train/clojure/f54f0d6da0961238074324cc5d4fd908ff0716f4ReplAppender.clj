(ns todo-ddom.ReplAppender
  (:import [ch.qos.logback.core OutputStreamAppender])
  (:gen-class
   :extends ch.qos.logback.core.OutputStreamAppender
   :exposes-methods {start superStart}))

(defn -start [this]
  (let [out-stream (java.io.PrintStream.
                    (proxy [java.io.ByteArrayOutputStream] []
                      (flush []
                        ;; deal with reflection in proxy-super
                        (let [^java.io.ByteArrayOutputStream this this]
                          (proxy-super flush)
                          (let [message (.trim (.toString this))]
                            (proxy-super reset)
                            (if (> (.length message) 0)
                              (println message))))))
                    true)]
    (.setOutputStream this out-stream)
    (.superStart this)))
