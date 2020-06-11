(ns cim-clojure-class.2-state)

;; Vars
(def foo "foo")

;; Atoms
; Atoms provide a way to manage shared, synchronous, independent state.
; Generally all you need in Clojure for non-conncurrent programming.
(def int-atom (atom 0))
(defn add-to-int-atom [value]
  (swap! int-atom + value))

(def map-atom (atom {}))
(defn add-to-map-atom  [key value]
  (swap! map-atom assoc key value))

;; Agents
; Agents provide a way to manage shared, asyncronous, independent state.
(def int-agent (agent 0))
(defn add-to-int-agent [value]
  (send int-agent
        (fn [agent] (+ agent value))))

;; Refs and the STM
; Provide a way to manage shared, asyncronous, state.
(def vec-count (ref 0))
(def vec-ref (ref []))
(defn add-to-refs [value]
  (dosync
    (alter vec-count + value)
    (alter vec-ref conj value)))