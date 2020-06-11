;; This file was generated with dalap-cljsbuild from
;;
;; src/clj/savant/store/memory.clj @ Tue Nov 27 23:30:14 UTC 2012
;;
(ns savant.store.memory (:require [savant.util :refer [throw+ hex-digest with-meta-merge named?]] [savant.core :refer [IEventStore IEventStream get-rev-id get-tip create-stream exists? get-events-vec get-commits-seq]]))
(def memory-stores (atom {}))
(declare -get-stream-tip)
(declare -bind-stream-to-rev)
(declare -build-first-commit-hash)
(declare -create-stream)
(declare -get-stream)
(declare -validate-options!)
(defrecord MemoryEventStore [state-atom] IEventStore (-same-store? [this other-store] (= this other-store)) (create-stream [this bucket-name id] (-create-stream this bucket-name id)) (get-stream [this bucket-name id] (-get-stream this bucket-name id {})) (get-stream [this bucket-name id opts] (-get-stream this bucket-name id opts)) (exists? [this bucket-name id] (not (nil? (-get-stream this bucket-name id {})))))
(defrecord MemoryEventStream [state-atom current-rev] IEventStream (get-rev-id [this] current-rev) (get-tip [this] (-get-stream-tip (clojure.core/deref state-atom))) (tip? [this] (= current-rev (get-tip this))) (get-commits-seq [this] (let [commits (seq (clojure.core/deref state-atom))] (if (nil? current-rev) commits (take-while (fn* [p1__3760#] (not= current-rev (-> p1__3760# meta :event-store/parent-rev-hash))) commits)))) (get-events-seq [this] (seq (get-events-vec this))) (get-events-vec [this] (into [] (flatten (get-commits-seq this)))) (get-events-vec [this from-event-id] (subvec (get-events-vec this) from-event-id)) (get-events-vec [this from-event-id to-event-id] (subvec (get-events-vec this) from-event-id to-event-id)) (commit-events! [this events] (let [parent-hash (or current-rev (-build-first-commit-hash this)) new-rev-hash (hex-digest [parent-hash events])] (letfn [(update-stream-state [stream-state] (let [tip (-get-stream-tip stream-state)] (if (not (= current-rev tip)) (throw+ [:type :event-store/conflict-detected] (format "conflict - current: %s and tip: %s" current-rev tip)) (conj stream-state (with-meta-merge events {:event-store/parent-rev-hash parent-hash, :event-store/rev-hash new-rev-hash})))))] (swap! state-atom update-stream-state) (-bind-stream-to-rev this new-rev-hash)))))
(defn- -get-stream-tip [stream-state] (:event-store/rev-hash (meta (last stream-state))))
(defn -build-first-commit-hash [stream])
(defn- -create-stream ([store bucket-name id] {:pre [(named? bucket-name) (named? id)]} (when (exists? store bucket-name id) (throw+ {:type :event-store/stream-exists} "stream was already created")) (let [stream (map->MemoryEventStream {:state-atom (atom []), :current-rev nil})] (swap! (:state-atom store) assoc-in [bucket-name id] stream) stream)))
(defn- -bind-stream-to-rev [stream rev] (let [rev (or rev (get-tip stream))] (if (= (get-rev-id stream) rev) stream (assoc stream :current-rev rev))))
(defn- -get-stream ([store bucket-name id {:keys [rev], :as opts}] {:pre [(named? bucket-name) (named? id)]} (let [unbounded-stream (get-in (clojure.core/deref (.-state-atom store)) [bucket-name id])] (cond (not (nil? unbounded-stream)) (-bind-stream-to-rev unbounded-stream rev) :else nil))))
(defn- -validate-options! [{:keys [name init-map], :or {init-map {}}}] (cond (nil? name) (throw+ {:type :event-store/invalid-options} "`:name` option is required") (nil? init-map) (throw+ {:type :event-store/invalid-options} "`:init-map` must be a map")))
(defn -reset-store [name] (swap! memory-stores update-in [name] (constantly (map->MemoryEventStore {:state-atom (atom {})}))))
(defn get-event-store [opts] (let [{:keys [name init-map], :or {init-map {}}} opts] (-validate-options! opts) (or (get (clojure.core/deref memory-stores) name) (let [memory-store (map->MemoryEventStore {:state-atom (atom init-map)})] (swap! memory-stores assoc name memory-store) memory-store))))