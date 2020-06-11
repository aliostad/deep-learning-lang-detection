(ns supertone.studio.audio
  (:require [overtone.sc.node                   :refer :all]
            [supertone.util                     :as util]
            [supertone.studio.bus               :as bus]
            [supertone.studio.groups            :as groups]
            [supertone.studio.control           :as control]))

(defrecord Audio [inst-store inst-control inst-nodes
                  fx-store fx-control
                  inst-io node-order])

(def inst-store* (atom nil))
(def inst-control* (atom nil))
(def inst-nodes* (atom nil))
(def fx-store* (atom nil))
(def fx-control* (atom nil))
(def inst-io* (atom nil))
(def node-order* (atom nil))

(defn init
  [s]
  (map->Audio {
    :inst-store   (util/swap-or inst-store* (:inst-store s) {})
    :inst-control (util/swap-or inst-control* (:inst-control s) {})
    :inst-nodes   (util/swap-or inst-nodes* (:inst-nodes s) {})
    :fx-store     (util/swap-or fx-store* (:fx-store s) {})
    :fx-control   (util/swap-or fx-control* (:fx-control s) {})
    :inst-io      (util/swap-or inst-io* (:inst-io s) {})
    :node-order   (util/swap-or node-order* (:node-order s) '())}))

(defn dispose
  [s]
  (map->Audio {
    :inst-store   (or @inst-store* (:inst-store s))
    :inst-control (or @inst-control* (:inst-control s))
    :inst-nodes   (or @inst-nodes* (:inst-nodes s))
    :fx-store     (or @fx-store* (:fx-store s))
    :fx-control   (or @fx-control* (:fx-control s))
    :inst-io      (or @inst-io* (:inst-io s))
    :node-order   (or @node-order* (:node-order s))}))

(defn inst-list
  "List instrument names."
  []
  (or (keys @inst-store*) '()))

(defn inst-get
  "Get an instrument by name."
  [name]
  (get @inst-store* name))

(defn fx-list
  "List the fx nodes for an instrument."
  [name]
  (or (into [] (map #(:node %) (get @fx-store* name))) []))

(defn fx-get
  "Get the fx synth for an instrument and fx node."
  [name fx-node]
  (:synth
    (some
      #(when
        (or (= (:node %) fx-node) (contains? (set (:node %)) fx-node))
        %)
      (get @fx-store* name))))

(defn param-map
  [synth pname]
  (some #(when (= (:name %) pname) %) (:params synth)))

(defn param-map-synth
  [synth pname]
  (merge
    {:min 0 :max 100000 :step 1}
    (param-map synth pname)))

(defn param-map-ctl
  [synth pname]
  (merge
    {:min 0 :max 0 :step 0}
    (param-map synth pname)))

(defn control-amt-get
  "Get control magnitude."
  [ctl-node]
  (let [nodes (if (sequential? ctl-node) ctl-node [ctl-node])]
    (util/single (map
      #(node-get-control % :amt)
      nodes))))

(defn control-amt-set
  "Set control magnitude."
  [ctl-node amt]
  (let [nodes (if (sequential? ctl-node) ctl-node [ctl-node])
        amts  (if (sequential? amt) amt (repeat (count nodes) amt))]
    (util/single (dorun (map
      #(node-control* %1 [:amt %2])
      nodes amts)))))

(defn control-amt-reset
  "Set control magnitude to zero."
  [ctl-node]
  (control-amt-set ctl-node 0.0))

(defn inst-io
  "Get all the input/output busses to/from an instrument."
  ([] @inst-io*)
  ([name] (get (inst-io) name)))

(defn bus-io
  "Get all the input/output instruments to/from a bus."
  ([] (util/map-invert (inst-io)))
  ([bus] (get (bus-io) bus)))

(defn inst-io-swap!
  "Update the input/output info for an instrument."
  [name io]
  (let [io-old (get @inst-io* name)]
    (swap! inst-io* assoc name io)
    (not= io-old io)))

(defn inst-io-into
  "Put input or output busses into input/output info."
  [io in-or-out busses]
  (let [old-busses (get io in-or-out)
        bus-set    (set busses)]
    (assoc io in-or-out (sort (into bus-set old-busses)))))

(defn inst-io-remove
  "Remove input or output busses from input/output info."
  [io in-or-out busses]
  (let [old-busses (get io in-or-out)
        bus-set    (set busses)]
    (assoc io in-or-out (sort (remove bus-set old-busses)))))

(defn sort-node-tree!
  "Sort the instruments in the node tree. Computes and returns node order."
  []
  (let [io-inst     (inst-io)
        io-bus      (util/map-invert io-inst)
        sinks       (into
                      clojure.lang.PersistentQueue/EMPTY
                      (filter #(empty? (:out (get io-bus %))) (keys io-bus)))
        dummy-group (groups/audio-dummy)]
    (swap! node-order* (constantly (into [] (distinct
      (loop [i-map  io-inst
             b-map  io-bus
             n      (peek sinks)
             queue  (pop sinks)
             sorted '()]
        (let [s      (string? n)
              f      (float? n)
              in-vec (cond
                       s (get-in i-map [n :in])
                       f (get-in b-map [n :in])
                       :else nil)
              i-new  (if s (assoc-in i-map [n :in] nil) i-map)
              b-new  (if f (assoc-in b-map [n :in] nil) b-map)]
          (when s (node-place* (:group (inst-get n)) :after dummy-group))
          (if (or s f)
            (let [q-new (reduce #(conj %1 %2) queue in-vec)]
              (recur i-new b-new (peek q-new) (pop q-new) (conj sorted n)))
            (if n (conj sorted n) sorted))))))))))

(defn node-order
  "Get the order of nodes. Must call sort-node-tree beforehand."
  []
  @node-order*)

;; Temporary helper functions

(defn clear-busses
  "Free all unused busses."
  []
  (dorun (map
    bus/free-audio-id
    (remove
      #(contains? (into #{} (keys (bus-io))) %)
      (drop (:n-channels bus/hardware) @bus/bus-audio*)))))
