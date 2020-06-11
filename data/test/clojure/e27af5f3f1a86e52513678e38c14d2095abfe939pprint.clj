(ns spark.pprint
  (:require [clojure.pprint :refer [code-dispatch with-pprint-dispatch pprint]]
            [sparkling.destructuring :as s-de])
  (:import [scala Tuple2]
           [java.util ArrayList]))

(defmulti spark-dispatch class)

(defmethod spark-dispatch :default [thing]
  (code-dispatch thing))

(defmethod spark-dispatch Tuple2 [thing]
  (code-dispatch [(s-de/first thing) (s-de/second thing)]))

(defmethod spark-dispatch ArrayList [thing]
  (code-dispatch (into [] thing)))

(defn spprint [spark-thing]
  (with-pprint-dispatch spark-dispatch
    (pprint spark-thing)))
