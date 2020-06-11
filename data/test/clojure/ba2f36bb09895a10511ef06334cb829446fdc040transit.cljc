(ns four.transit
  #?(:clj (:import [java.io ByteArrayInputStream ByteArrayOutputStream]))
  (:require [cognitect.transit :as t]))

(defn serialize [val]
  #?(:clj (with-open [output-stream (ByteArrayOutputStream. 4096)]
            (t/write (t/writer output-stream :json) val)
            (.toString output-stream)))
  #?(:cljs (let [w (t/writer :json)]
             (t/write w val))))

(defn deserialize [a-string]
  #?(:clj (with-open [input-stream (ByteArrayInputStream. (.getBytes a-string))]
            (t/read (t/reader input-stream :json))))

  #?(:cljs (let [r (t/reader :json)]
             (t/read r a-string))))

