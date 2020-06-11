(ns com.kaicode.teleport
  #?(:clj (:import [java.io ByteArrayInputStream ByteArrayOutputStream]
                   [com.cognitect.transit WriteHandler ReadHandler]))
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

  #?(:cljs (let [r (t/reader :json {:handlers {"f" (fn [value] (js/Number. value))}})]
                (t/read r a-string))))

