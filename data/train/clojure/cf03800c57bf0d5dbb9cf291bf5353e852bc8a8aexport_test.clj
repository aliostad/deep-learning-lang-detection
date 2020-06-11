(ns photon.current.export-test
  (:require [photon.streams :as streams]
            [photon.db :as db]
            [muon-clojure.core :as mcs]
            [clojure.core.async :as async :refer [<!!]]
            [com.stuartsierra.component :as component]
            [clojure.java.io :as io]
            [photon.current.common :refer :all]
            [photon.api :as api]
            [photon.core :as core]
            [clojure.tools.logging :as log])
  (:import (java.util.zip GZIPInputStream)
           (java.io FileInputStream))
  (:use midje.sweet))

(def temp-file (java.io.File/createTempFile "midje" ".json"))
(def conf {:amqp.url :local
           :microservice.name (str "photon-integration-test-" (db/uuid))
           :parallel.projections 2
           :db.backend "file"
           :file.path (.getAbsolutePath temp-file)
           :projections.port 9998
           :events.port 9999})
#_(def s (streams/new-async-stream nil d conf))
(def c
  (component/start (component/system-map
                    :database (component/using
                               (core/db-component conf) [])
                    :stream-manager (component/using
                                     (streams/stream-manager conf)
                                     [:database]))))
(def d (:driver (:database c)))
(def s (:manager (:stream-manager c)))
(defn elem-count [ch]
  (loop [elem (<!! ch) n 0]
    (if (nil? elem)
      n
      (recur (<!! ch) (inc n)))))

(db/delete-all! d)
(dorun (take 10 (map #(db/store d {:stream-name "test" :order-id %}) (range))))

(defn count-result []
  (let [f (api/stream->file s "test")
        gzis (GZIPInputStream. (FileInputStream. f))]
    (with-open [r (io/reader gzis)]
      (let [ls (line-seq r)]
        (count ls)))))

(fact "Re-check stream size"
      (elem-count (streams/stream->ch s {:stream-type "cold"
                                         :stream-name "__all__"}))
      => 10)

(fact "Exporting a document gives the correct file"
      (elem-count (streams/stream->ch s {:stream-type "cold"
                                         :stream-name "__all__"}))
      => (count-result))

