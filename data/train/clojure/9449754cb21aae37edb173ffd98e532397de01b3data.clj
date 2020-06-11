(ns api.data
  (:require [clojure.java.io :as io]
            [cheshire.core :as json]))

(def dishes
  (merge
    (json/decode-stream
      (io/reader "resources/data/dishes/be.json") true)
    (json/decode-stream
      (io/reader "resources/data/dishes/cl.json") true)
    (json/decode-stream
      (io/reader "resources/data/dishes/cn.json") true)
    (json/decode-stream
      (io/reader "resources/data/dishes/do.json") true)
    (json/decode-stream
      (io/reader "resources/data/dishes/es.json") true)
    (json/decode-stream
      (io/reader "resources/data/dishes/fr.json") true)
    (json/decode-stream
      (io/reader "resources/data/dishes/hu.json") true)
    (json/decode-stream
      (io/reader "resources/data/dishes/in.json") true)
    (json/decode-stream
      (io/reader "resources/data/dishes/it.json") true)
    (json/decode-stream
      (io/reader "resources/data/dishes/jp.json") true)
    (json/decode-stream
      (io/reader "resources/data/dishes/kr.json") true)
    (json/decode-stream
      (io/reader "resources/data/dishes/mx.json") true)
    (json/decode-stream
      (io/reader "resources/data/dishes/sg.json") true)
    (json/decode-stream
      (io/reader "resources/data/dishes/th.json") true)
    (json/decode-stream
      (io/reader "resources/data/dishes/tw.json") true)
    (json/decode-stream
      (io/reader "resources/data/dishes/us.json") true)))

(def countries
  (json/decode-stream
    (io/reader "resources/data/countries.json") true))

(def filters
  (json/decode-stream
    (io/reader "resources/data/filters.json") true))
