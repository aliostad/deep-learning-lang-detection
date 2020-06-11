(ns pumpr.s
  (:refer-clojure :exclude [merge reduce filter map compile])
  (:require [pumpr.core :as p]))

(enable-console-print!)

(defn get-input-map [x]
    (into {}
      (for [k (js-keys x)]
        [(keyword k) (aget x k)])))

(declare Stream)

(defn ^:export input [id]
  (Stream. (p/sinput (keyword id))))

(defn ^:export cell
  ([id]
    (Stream. (p/scell (keyword id))))
  ([id initial]
    (Stream. (p/scell (keyword id) initial))))

(defn ^:export merge [f & streams]
  (Stream. (apply (partial p/smerge f) streams)))

(deftype Stream [s]
  Object
  (output [this id] (Stream. (p/soutput (keyword id) s)))
  (map [this f] (Stream. (p/smap f s)))
  (filter [this f] (Stream. (p/sfilter f s)))
  (load [this c] (Stream. (p/sload c s)))
  (store [this c] (Stream. (p/sstore c s)))
  (reduce [this f initial] (Stream. (p/sreduce f initial s)))
  (reduce [this f initial cell-id] (Stream. (p/sreduce f initial (keyword cell-id) s)))
  (label [this label] (Stream. (p/slabel label s)))
  (debug [this label] (Stream. (p/sdebug label s)))
  (compile [this] (Stream. (p/scompile s)))
  (run [this inputs]
    (if (identical? (type inputs) js/Object)
      (-> inputs
          (get-input-map)
          (p/run s)
          (clj->js))
      (p/run s)))
  (getInputs [this]
    (clj->js
     (keys (:input-map (p/scompile s)))))
  (getOutputs [this]
    (clj->js
     (clojure.core/map
      :id
      (p/find-streams
       #(or (= :output (:type %))
            (= :cell-update (:type %)))
       s))))
)

(goog/exportSymbol "pumpr.s.Stream" Stream)
(goog/exportSymbol "pumpr.s.Stream.prototype.output" (.. Stream -prototype -output))
(goog/exportSymbol "pumpr.s.Stream.prototype.map" (.. Stream -prototype -map))
(goog/exportSymbol "pumpr.s.Stream.prototype.filter" (.. Stream -prototype -filter))
(goog/exportSymbol "pumpr.s.Stream.prototype.load" (.. Stream -prototype -load))
(goog/exportSymbol "pumpr.s.Stream.prototype.store" (.. Stream -prototype -store))
(goog/exportSymbol "pumpr.s.Stream.prototype.reduce" (.. Stream -prototype -reduce))
(goog/exportSymbol "pumpr.s.Stream.prototype.label" (.. Stream -prototype -label))
(goog/exportSymbol "pumpr.s.Stream.prototype.debug" (.. Stream -prototype -debug))
(goog/exportSymbol "pumpr.s.Stream.prototype.compile" (.. Stream -prototype -compile))
(goog/exportSymbol "pumpr.s.Stream.prototype.run" (.. Stream -prototype -run))

