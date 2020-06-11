(ns natbox.core.util
  (:require [manifold.stream :as s]
            [taoensso.nippy :as nippy]))

(defn prompt [handle prompt-str]
  "Returns a prompt that will invoke handle with the user input
   if handle returns truthy, the prompt will prompt again"
  (fn []
    "Prompt for and handle user input"
    (print prompt-str)
    (flush)
    (if (handle (read-line))
      ((prompt handle prompt-str))
      "Have a nice day!")))

(defn write [stream msg]
  "Accepts a valid stream and returns a function that accepts edn and writes that to the stream"
  (try
    @(s/try-put! stream (nippy/freeze msg) 0)
    (catch Exception e false)))

(defn consume-edn-stream [stream msg-handler]
  "deserialize tcp stream messages and pass edn to msg-handler"
  (s/consume
    (fn [data]
      (msg-handler
        (if (not (nil? data))
          (nippy/thaw data))))
    stream))

