(ns shared.models.query.index
  (:require [shared.specs.core :as specs]
            [cljs.spec :as spec]
            [cljs.spec.test :as stest]
            [cuerdas.core :as str]
            [shared.protocols.loggable :as log]))

(defrecord Query [])

(spec/fdef create
           :args (spec/cat :query ::specs/query)
           :ret ::specs/query
           :fn #(spec/valid? ::specs/meta (-> %1 :ret :meta)))

(defmulti create (fn [data]
                   (if (spec/valid? ::specs/payload data)
                     (first (spec/conform ::specs/payload data))
                     :query)))

(defmethod create :profile [query]
  (with-meta (map->Query query) {:spec ::specs/query}))

(defmethod create :course [{:keys [goal curator] :as query}]
  (with-meta (map->Query {:curator curator
                          :course-slug (str/slugify goal)}) {:spec ::specs/query}))

(defmethod create :viewmodel [query]
  (with-meta (map->Query query) {:spec ::specs/query}))

(defmethod create :user [query]
  (with-meta (map->Query query) {:spec ::specs/query}))

(defmethod create :query [query]
  (with-meta (map->Query query) {:spec ::specs/query}))

(stest/instrument `create)

