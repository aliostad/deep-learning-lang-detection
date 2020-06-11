;   Copyright (c) Metadata Partners, LLC. All rights reserved.
;   The use and distribution terms for this software are covered by the
;   Eclipse Public License 1.0 (http://opensource.org/licenses/eclipse-1.0.php)
;   which can be found in the file epl-v10.html at the root of this distribution.
;   By using this software in any fashion, you are agreeing to be bound by
;   the terms of this license.
;   You must not remove this notice, or any other, from this software.

(ns cashmgmt.util.unique
  (:require [clojure.set :as set]
            [datomic.api :as d]
            [cashmgmt.util.query :as qry]))

(defn existing-values
  "Returns subset of values that already exist as unique
   attribute attr in db"
  [db attr vals]
  (->> (d/q '[:find ?val
              :in $ ?attr [?val ...]
              :where [_ ?attr ?val]]
            db attr vals)
       (map first)
       (into #{})))

(defn assert-new-values
  "Assert emaps whose attr value does not already exist in db.

   Returns transaction result or nil if nothing to assert."
  [conn part attr emaps]
  (let [vals (mapv attr emaps)
        existing (existing-values (d/db conn) attr vals)]
    (when-not (= (count existing) (count vals))
      (->> emaps
           (remove #(existing (get attr %)))
           (map (fn [emap] (assoc emap :db/id (d/tempid part))))
           (d/transact conn)
           deref
           ))))

(defn assert-new-values-on
  "Assert emaps whose attr value does not already exist in db.

   Returns transaction result or nil if nothing to assert."
  [conn entity attr emaps]
  (let [vals (mapv attr emaps)
        existing (existing-values (d/db conn) attr vals)]
    (when-not (= (count existing) (count vals))
      (->> emaps
           (remove #(existing (get attr %)))
           (map (fn [emap] (assoc emap :db/id entity)))
           (d/transact conn)
           deref
           ))))

(defn assert-on-emap
  "assert vals onto the emap which is fed in"
  [conn emap attr vals]
  (let [existing (attr emap)]
    (when (not-empty vals)
      (->> vals
           (remove #(existing %))
           (mapv (fn [val] [:db/add (qry/e emap) attr val]))
           (d/transact conn)
           deref
    ))))

(defn list-existing-values
  "Returns subset of values that already exist as unique
   attribute attr in db"
  [db attr]
  (->> (d/q '[:find ?val
              :in $ ?attr ;;[?val ...]
              :where [_ ?attr ?val]]
            db attr)
       (map first)))

(defn list-existing-values-e
  "list existing values for entity"
  [r db attr]
  (->> (d/q '[:find ?val
              :in $ ?attr ?r
              :where
              [?e ?attr ?val]
              [?e :instrument/reference ?r]]
            db attr r)
       (map first)))

(comment
  ;; in: [:bond :fixed-income]

  ;; existing: [:bond]

  ;; out: assert :db/add b133 :instrument/type :fixed-income
  )

;; below is proper usage of day-of-datomic unique.clj
(comment (let [txid (ffirst (d/q '[:find ?e :where [?e :instrument/reference "b133"]] (d/db conn)))
       emap1 {:db/id (d/tempid :db.part/tx)
              :instrument/type "a1"}
       emap2 {:db/id (d/tempid :db.part/tx)
              :instrument/type "b1"}]
   (uq/assert-new-values-on conn txid :instrument/type [emap1 emap2] )))
;; (uq/existing-values (d/db conn) :instrument/type [:bond :fixed-income :x987 :b1 :b2])
