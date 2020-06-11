(ns burningswell.db.test
  (:require [burningswell.config.core :as config]
            [burningswell.config.test :as test-config]
            [burningswell.db.connection :refer [with-db]]
            [burningswell.system :refer [with-system]]
            [clj-time.core :refer [now]]
            [clojure.spec.test.alpha :refer [instrument]]
            [datumbazo.core :refer [with-connection]]
            [schema.core :as s]))

(def env test-config/env)
(def config test-config/config)

(defmacro with-test-db [db-sym & body]
  `(s/with-fn-validation
     (with-db [db# (:db (config))]
       (with-connection [~db-sym db#]
         (instrument)
         ~@body))))

(defmacro with-test-db [[db-sym config] & body]
  `(s/with-fn-validation
     (with-db [db# (merge (:db (test-config/config)) ~config)]
       (with-connection [~db-sym db#]
         (instrument)
         ~@body))))

(defn paginateable?
  "Returns true if the query accepts pagination parameters and returns
  the correct results, otherwise false."
  [query]
  (let [results (query {:page 1 :per-page 2})
        [r1 r2] results]
    (cond
      (empty? results)
      (do (println "WARNING: Empty result set, can't test paginateable?")
          true)
      (= 1 (count results))
      (empty? (query {:page 1 :per-page 0}))
      :else
      (and (= [r1] (query {:page 1 :per-page 1}))
           (= [r2] (query {:page 2 :per-page 1}))))))

(defn date-time? [x]
  (instance? org.joda.time.DateTime x))

(defn date? [x]
  (instance? java.util.Date x))
