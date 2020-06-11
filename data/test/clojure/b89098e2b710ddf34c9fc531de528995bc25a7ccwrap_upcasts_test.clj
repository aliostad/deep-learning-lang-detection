(ns rill.wheel.wrap-upcasts-test
  (:require [clojure.test :refer [deftest is use-fixtures]]
            [rill.event-store.memory :refer [memory-store]]
            [rill.event-store :refer [retrieve-events]]
            [rill.event-stream :refer [all-events-stream-id]]
            [rill.message :as msg]
            [rill.wheel :as aggregate :refer [defaggregate defevent]]
            [rill.wheel.bare-repository :refer [bare-repository]]
            [rill.wheel.repository :as repo]
            [rill.wheel.testing :refer [sub? with-instrument-all]]
            [rill.wheel.wrap-upcasts :refer [wrap-upcasts]]))

(use-fixtures :once with-instrument-all)

(defaggregate thing
  [id])

(defevent created ::thing
  [thing c]
  (assoc thing :c c))

(deftest test-stream-properties
  (let [store (-> (memory-store)
                  (wrap-upcasts #(update % :c (fnil inc 0))
                                #(update % :c * 2)))
        repo  (bare-repository store)]
    (is (repo/commit! repo (-> (get-thing repo 1)
                               (created 2))))
    (is (repo/commit! repo (-> (get-thing repo 2)
                               (created 3))))
    (is (sub? [{::msg/type   ::created
                :id 1
                :c 6}
               {::msg/type   ::created
                :id 2
                :c 8}]
              (retrieve-events store all-events-stream-id)))))
