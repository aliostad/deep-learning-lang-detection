(ns status.compilers
  (:require [markdown.core :as md]
            [garden [core :refer [css]]
                    color
                    units]
            [clojure.java.io :as io]))

(defn copy
  [^java.io.BufferedReader in-stream ^java.io.BufferedWriter out-stream _]
  (let [buffer (char-array 8196)]
    (loop []
      (let [len (.read in-stream buffer)]
        (when (>= len 0)
          (.write out-stream buffer 0 len)
          (recur))))))

(defn markdown
  [^java.io.BufferedReader in-stream ^java.io.BufferedWriter out-stream _]
  (md/md-to-html in-stream out-stream))

(defn garden
  [^java.io.BufferedReader in-stream ^java.io.BufferedWriter out-stream _]
  (.write out-stream
          (css {:pretty-print? false}
               (binding [*ns* (the-ns 'status.compilers)]
                 (eval (read (java.io.PushbackReader. in-stream)))))))
