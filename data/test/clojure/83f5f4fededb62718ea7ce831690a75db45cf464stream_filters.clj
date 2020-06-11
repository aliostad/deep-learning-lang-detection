(ns jiksnu.modules.core.filters.stream-filters
  (:require [ciste.filters :refer [deffilter]]
            [jiksnu.actions.stream-actions :as actions.stream]))

(deffilter #'actions.stream/fetch-by-user :page
  [action request]
  (let [item (:item request)]
    (action item)))

(deffilter #'actions.stream/outbox :page
  [action request]
  (let [item (:item request)]
    (action item)))

(deffilter #'actions.stream/index :page
  [action request]
  ;; TODO: fetch user
  (action))

(deffilter #'actions.stream/public-timeline :page
  [action request]
  (action))

(deffilter #'actions.stream/user-timeline :page
  [action request]
  (let [item (:item request)]
    (action item)))
