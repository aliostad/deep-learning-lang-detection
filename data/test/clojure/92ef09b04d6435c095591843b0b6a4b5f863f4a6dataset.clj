;-------------------------------------------------------------------------------
;Dataset.clj
;
;helpers to create and manage new datasets
;-------------------------------------------------------------------------------

(ns clj-mml.dataset
  (:use [clj-mml.core])
  (:import [MyMediaLite.Data Ratings]
           [MyMediaLite.Data.PosOnlyFeedback]
           [MyMediaLite.DataType SparseBooleanMatrix]))

; -- Items

(defn add-item! [dt-set user-id item-id]
    (.Add dt-set user-id item-id))

(defn new-items []
  (|MyMediaLite.Data.PosOnlyFeedback`1[MyMediaLite.DataType.SparseBooleanMatrix]|.))

(defn build-items [data-coll]
  (let [dt-set (new-items)]
    (doall
      (for [row  data-coll] (add-item! dt-set (first row) (second row))))
    dt-set))

; -- Ratings
(defn add-rating! [dt-set user-id item-id rating]
  (.Add dt-set user-id item-id (float rating)))

(defn new-ratings []
  (Ratings.))

(defn build-ratings [data-coll]
  (let [dt-set (new-ratings)]
    (doall
      (for [row data-coll] (add-rating! dt-set (nth row 0) (nth row 1) (nth row 2))))
      dt-set))
