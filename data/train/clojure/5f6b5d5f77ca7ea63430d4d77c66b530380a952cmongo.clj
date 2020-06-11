(ns esource.mongo
  (:require [esource.core :refer [IStore] :as core]
            [esource.help :refer [max-document]]
            [monger.collection :as collection]
            [monger.core :as monger]
            [monger.query :as query]
            [monger.result :as result]
            [monger.operators :as operators]))


(defn- read-store [db name stream start end]
  (query/with-collection db name
    (query/find {:stream stream
                 :version {operators/$gte start
                           operators/$lte end}})
    (query/sort (array-map :version 1))))


(defrecord MongoStore [db name versions]
  IStore

  (latest! [_ stream]
    (max-document db name {:stream stream} :version))

  (latest-version! [store stream]
   (let [entry (core/latest! store stream)]
     (get entry :version 0)))

  (version! [store stream]
    (if (contains? @versions stream)
      (get @versions stream)
      (let [v (core/latest-version! store stream)]
        (swap! versions assoc stream v)
        v)))

  (add! [store stream data]
    (let [v      (inc (core/version! store stream))
          n-data (assoc data :version v)]
      (swap! versions assoc stream v)
      (result/acknowledged? (collection/insert db name n-data))))

  (slice! [store stream]
    (core/slice! store stream 1))

  (slice! [store stream start]
    (if-let [end (core/version! store stream)]
      (core/slice! store stream start end)
      []))

  (slice! [store stream start end]
    (let [events (read-store db name stream start end)
          coerce (comp
                  (map #(update % :name keyword))
                  (map #(update % :type keyword)))]
      (sequence coerce events)))

  (fold! [store stream init reducer]
    (reduce reducer init (core/slice! store stream))))


(defn- setup!
  "For a given mongodb store, setup its indices"
  [{:keys [db name]}]
  (collection/ensure-index db name (array-map :version 1))
  (collection/ensure-index db name (array-map :stream 1))
  (collection/ensure-index db name (array-map :version 1
                                              :stream 1)
                           {:unique true}))


(defn new-store
  "For a given mongodb database and a collection create a store"
  [db name]
  (let [store (->MongoStore db name (atom {}))]
    (setup! store)
    store))
