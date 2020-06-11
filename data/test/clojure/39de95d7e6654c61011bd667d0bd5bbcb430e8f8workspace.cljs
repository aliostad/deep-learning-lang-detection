(ns cosmos.workspace
  (:refer-clojure :exclude [empty])
  (:require
    [cosmos.protocols.ownership :as ownership]
    [cosmos.protocols.chronicle :as chronicle]
    [cosmos.protocols.world :as world]
    [cosmos.timeline :as timeline]
    [cljs.spec :as spec]))

(declare ->Workspace)

(deftype Workspace [stores]
  world/World
  (to-world [this] this)
  ownership/Ownership
  (owner [this key]
    (some
      (fn [[id store]]
        (when (contains? @@store key) id))
      stores))
  (owner? [this key]
    (some? (ownership/owner this key)))
  ILookup
  (-lookup [_ id]
    (-> stores (get id) chronicle/present))
  IAssociative
  (-assoc [this id value]
    (->Workspace
      (update stores id timeline/record (constantly value))))
  ISeqable
  (-seq [this]
    (->> stores
      (mapcat (comp seq deref second)))))

(defn mount [workspace stores]
  (->Workspace
    (reduce
      (fn [memo [id store]]
        (assoc memo id (timeline/inception store)))
        (.-stores workspace) stores)))

(defn create [stores]
  (->Workspace stores))

(def workspace? (partial instance? Workspace))

(spec/fdef create
  :args (spec/cat :stores (spec/map-of uuid? timeline/timeline?))
  :ret  (spec/spec workspace?))

;(stest/instrument `create)

(def new create)

(def empty
  (->Workspace {}))