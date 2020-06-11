(ns pumpr.graph
  (:require [pumpr.core :as p])
  (:require [pumpr.eval-executor :as pee])
  (:use lacij.layouts.layout
        lacij.model.graph
        lacij.edit.graph
        lacij.view.graphview))

(defn xlate-stream [{:keys [node-priority-map]} node]
  (get node-priority-map node))

(defn xlate-streamval [node-priority-map m]
  (reduce-kv (fn [m k v] (assoc m (get node-priority-map k) v)) {} m))

(defn dump-state [{:keys [node-priority-map]} im]
  (reduce-kv (fn [m k v] (assoc m (get node-priority-map k) (xlate-streamval node-priority-map v))) {} im))

(defmulti get-stream-text :type)
(defmethod get-stream-text :input [s]
  (str "input " (name (:id s))))
(defmethod get-stream-text :output [s]
  (str "output " (name (:id s))))
(defmethod get-stream-text :cell [s]
  (str "cell " (name (:id s))))
(defmethod get-stream-text :cell-store-update [s]
  (str "cell " (name (:id (:cell s)))))
(defmethod get-stream-text :cell-merge-update [s]
  (str "cell " (name (:id (:cell s)))))
(defmethod get-stream-text :cell-group-update [s]
  (str "cell " (name (:id (:cell s)))))
(defmethod get-stream-text :default [s]
  (name (:type s)))

(defn get-stream-text-with-label [s]
  (let [prefix (if (:label s)
                 (str "[" (:label s) "] "))]
    (str prefix (get-stream-text s))))

(defn get-stream-id [stream-num]
  (keyword (str "node" stream-num)))

(defn get-node-params [{:keys [node-priority-map]} input-map exec-stream stream-index stream]
  (let [min-priority (get node-priority-map exec-stream Integer/MAX_VALUE)
        priority     (get node-priority-map stream)
        color        (cond
                       (= stream exec-stream) "lightgreen"
                       (contains? input-map stream) "lightblue"
                       (< priority min-priority) "lightgray"
                       :else "white")
        style        {:fill color}
        params       [(get-stream-id stream-index) (get-stream-text-with-label stream) :style style]]
    params))

(defn get-edge-params [sc input-map exec-stream child-stream parent-stream]
  (if (and (= (:type child-stream) :cell-update)
           (= (:type parent-stream) :cell))
    nil
    (let [parent-id (get-stream-id (xlate-stream sc parent-stream))
          child-id  (get-stream-id (xlate-stream sc child-stream))
          params    [parent-id child-id]]
      (if (contains? (get input-map child-stream) parent-stream)
        (conj params :style {:stroke "lightgreen"})
        params))))

(defn get-edges [sc input-map exec-stream stream]
  (->>
    (map (partial get-edge-params sc input-map exec-stream stream) (:parents stream))
    (filter #(not (nil? %)))))

(defn make-graph [input-map & streams]
  (let [sc           (apply pee/scompile streams)
        exec-stream  (pee/select-exec-node sc (keys input-map))
        nodes        (map-indexed (partial get-node-params sc input-map exec-stream) (:nodes sc))
        edges        (apply concat (map (partial get-edges sc input-map exec-stream) (:nodes sc)))
        add-node-fns (map #(fn [g] (apply (partial add-node g) %)) nodes)
        add-edge-fns (map #(fn [g] (apply (partial add-edge g (geneid)) %)) edges)
        g            (graph)
        g            (reduce (fn [g f] (f g)) g add-node-fns)
        g            (reduce (fn [g f] (f g)) g add-edge-fns)]
    g))

(defn export-graph [filename input-map & streams]
  (-> (apply (partial make-graph input-map) streams)
      (layout :hierarchical :flow :out)
      (build)
      (export filename :indent "yes")))

