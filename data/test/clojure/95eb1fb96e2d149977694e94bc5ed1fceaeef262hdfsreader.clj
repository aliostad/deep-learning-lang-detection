(ns images.test.hdfsreader
  (:use midje.sweet
        images.hdfsreader)
  (:require [clojure.java.io :as io])
  (:import org.apache.commons.io.IOUtils))

(def image-path "/imagestest/test.tgz")
(def filename "IMG_1548.jpg")
(def verify-path (str "testing/" filename))

(fact
  (let [image-stream (get-image image-path filename)
        expected-stream (-> (io/resource verify-path)
                              .openStream)]
    image-stream =not=> nil
    expected-stream =not=> nil
    (IOUtils/contentEquals image-stream expected-stream) => true))
