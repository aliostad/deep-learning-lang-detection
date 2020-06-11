(ns tiny-maze.specs
  (:require [clojure.spec.alpha :as s]
            [clojure.spec.test.alpha :as stest]))
 

;; From our gilded-rose kata, just for orientation and base functions
;; (s/def ::item-name string?)
;; (s/def ::sell-in integer?)
;; (s/def ::quality integer?)
;; (s/def ::item (s/keys :req-un [::item-name ::sell-in ::quality]))

;; (s/fdef gilded-rose.core/item
;;         :args (s/cat :name string? :sell-in integer? :quality integer?)
;;         :ret ::item)

;; (stest/instrument 'gilded-rose.core/item)
;; (s/exercise-fn `gilded-rose.core/item)
;; (stest/abbrev-result (first (stest/check `gilded-rose.core/item)))
