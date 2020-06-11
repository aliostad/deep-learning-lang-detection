(ns reader.io
  (:import (java.io File FileInputStream FileOutputStream InputStream InputStreamReader OutputStream OutputStreamWriter BufferedReader BufferedWriter)
           (java.net Socket URL)))

(defprotocol IOFactory
  "汎用の読込み／書込みを定義したプロトコル"
  (makeReader  [this] "Creates a BufferedReader.")
  (makeWriter  [this] "Creates a BufferedWriter."))

(extend-protocol IOFactory
  InputStream
    (makeReader [src]
      (-> src InputStreamReader. BufferedReader.))
    (makeWriter [dst]
      (throw
        (IllegalArgumentException. "Can’t open as an InputStream.")))
  OutputStream
    (makeReader [src]
      (throw
        (IllegalArgumentException. "Can’t open as an OutputStream.")))
    (makeWriter [dst]
      (-> dst OutputStreamWriter. BufferedWriter.)))

(defn min-spit [dst content]
    (with-open [writer (makeWriter dst)]
        (.write writer (str content))))

(defn min-slurp [src]
    (let [sb (new StringBuilder)]
        (with-open [reader (makeReader src)]
            (loop [readChar (.read reader)]
                (if (neg? readChar) (str sb) 
                    (do (.append sb (char readChar))
                        (recur (.read reader))))))))

