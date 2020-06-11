;; Copyright (c) 2017-present Konrad Grzanek
;; Created 2017-04-06

(ns kongra.prelude.io
  (:require [kongra.ch :refer :all])
  (:import  [java.io InputStream ByteArrayInputStream
                            File      FileInputStream]
            [java.nio.charset                 Charset]))

;; SYSTEM-WIDE CHARACTER ENCODING

(def ^Charset ENCODING (chC Charset (Charset/forName "UTF-8")))

;; CONVERSION TO InputStream

(defchC chInputStream InputStream) (regch chInputStream)

(defprotocol ToInputStream
  (^InputStream input-stream [this]))

(extend-type InputStream
  ToInputStream
  (input-stream [this]
    (chInputStream this)))

(extend-type String
  ToInputStream
  (input-stream [this]
    (chInputStream (-> this (.getBytes ENCODING) ByteArrayInputStream.))))

(extend-type File
  ToInputStream
  (input-stream [this]
    (chInputStream (FileInputStream. this))))
