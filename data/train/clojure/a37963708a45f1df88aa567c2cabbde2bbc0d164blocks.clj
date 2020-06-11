(ns clojure.com.intelliarts.starasov.sicp.cs.blocks
  (:require [clojure.com.intelliarts.starasov.sicp.cs.connector :as c]))

(defn constant [value connector]
  (println
    "connector-id" (:id (c/get-state connector))
    "connector-constraints" (:constraints (c/get-state connector))
    "connector-value" (:value (c/get-state connector)))

  (defn -dispatch [request]
    (throw (IllegalStateException. (str "Unsupported constant operation " request))))

  (c/connect connector :a)
  (c/set-value! connector value :a)

  -dispatch)

(defn -adder [a1 a2 sum state]
  (defn self [] (@state :dispatch))
  (defn self! [me] (dosync (alter state assoc :dispatch me)))

  (defn -process-new-value []
    (cond
      (and (c/has-value? a1) (c/has-value? a2))
        (c/set-value! sum (+ (c/value a1) (c/value a2)) (self))
      (and (c/has-value? a1) (c/has-value? sum))
        (c/set-value! a2 (- (c/value sum) (c/value a1)) (self))
      (and (c/has-value? a2) (c/has-value? sum))
        (c/set-value! a1 (- (c/value sum) (c/value a2)) (self))))

  (defn -process-forget-value []
    (c/forget-value! a1 (self))
    (c/forget-value! a2 (self))
    (c/forget-value! sum (self)))

  (defn -dispatch [request]
    (cond
      (= :on-new-value request) (-process-new-value)
      (= :on-lost-value request) (-process-forget-value)))

  (self! -dispatch)
  (c/connect a1 -dispatch)
  (c/connect a2 -dispatch)
  (c/connect sum -dispatch))

(defn adder [a1 a2 sum]
  (-adder a1 a2 sum (ref {:dispatch nil})))

(defn -multiplier [a1 a2 procuct state]
  (defn self [] (@state :dispatch))
  (defn self! [me] (dosync (alter state assoc :dispatch me)))

  (defn -process-new-value []
    (cond
      (and (c/has-value? a1) (c/has-value? a2))
        (c/set-value! procuct (* (c/value a1) (c/value a2)) (self))
      (and (c/has-value? a1) (c/has-value? procuct))
        (c/set-value! a2 (/ (c/value procuct) (c/value a1)) (self))
      (and (c/has-value? a2) (c/has-value? procuct))
        (c/set-value! a1 (/ (c/value procuct) (c/value a2)) (self))))

  (defn -process-forget-value []
    (c/forget-value! a1 (self))
    (c/forget-value! a2 (self))
    (c/forget-value! procuct (self)))

  (defn -dispatch [request]
    (cond
      (= :on-new-value request) (-process-new-value)
      (= :on-lost-value request) (-process-forget-value)
      :else (throw (IllegalStateException. (str "Unsupported adder operation " request)))))

  (self! -dispatch)
  (c/connect a1 -dispatch)
  (c/connect a2 -dispatch)
  (c/connect procuct -dispatch))

(defn multiplier [a1 a2 product]
  (-multiplier a1 a2 product (ref {:dispatch nil})))

(defn probe [connector name]
  (defn -process-new-value []
    (println name (c/value connector)))

  (defn -process-forget-value []
    (println name "?"))

  (defn -dispatch [request]
    (cond
      (= :on-new-value request) (-process-new-value)
      (= :on-lost-value request) (-process-forget-value)
      :else (throw (IllegalStateException. (str "Unsupported multiplier operation " request)))))

  (c/connect connector -dispatch))
