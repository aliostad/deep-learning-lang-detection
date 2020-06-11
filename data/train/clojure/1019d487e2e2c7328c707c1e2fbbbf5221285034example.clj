(ns example
  (:import (java.io FileInputStream))
  (:use clojure.xml-stream))

(set! *warn-on-reflection* true)

(defrecord TreeSpecies [id name])
(defrecord Forest [id trees name])
(defrecord Tree [species-id branches])

(defmulti ground-element class-element)

(defmulti tree-element class-element)

(defmethod ground-element :tree [stream-reader _]
  (TreeSpecies. (attribute-value stream-reader "id") nil))

(defmethod ground-element [:TreeSpecies :name] [stream-reader tree]
  (assoc tree :name (element-text stream-reader)))

(defmethod ground-element :forest [stream-reader _]
  (Forest. (attribute-value stream-reader "id") [] nil))

(defmethod ground-element [:Forest :name] [stream-reader forest]
  (assoc forest :name (element-text stream-reader)))

(defmethod ground-element [:Forest :tree] [stream-reader forest]
  (assoc forest :trees
    (conj (:trees forest)
      (Tree. (attribute-value stream-reader "refid")
        (dispatch-partial stream-reader tree-element)))))

(defmethod tree-element :branch [stream-reader _]
  (keyword (attribute-value stream-reader "direction")))

(defmethod ground-element :default [stream-reader item]
  nil)
(defmethod tree-element :default [stream-reader item]
  nil)

(defn run [path]
  (with-open [input-stream (FileInputStream. path)]
    (let [objects (dispatch-stream (make-stream-reader input-stream) ground-element)]
      (doseq [object objects] (println object)))))

