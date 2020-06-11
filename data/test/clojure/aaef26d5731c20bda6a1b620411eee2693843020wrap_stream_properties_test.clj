(ns rill.wheel.wrap-stream-properties-test
  (:require [clojure.test :refer [are deftest is testing use-fixtures]]
            [rill.event-store :refer [append-events retrieve-events]]
            [rill.event-store.memory :refer [memory-store]]
            [rill.event-stream :refer [all-events-stream-id]]
            [rill.message :as msg]
            [rill.wheel :as aggregate :refer [defaggregate defevent ok?]]
            [rill.wheel.bare-repository :refer [bare-repository]]
            [rill.wheel.repository :as repo]
            [rill.wheel.testing :refer [sub? with-instrument-all]]
            [rill.wheel.wrap-stream-properties :refer [wrap-stream-properties]]))

(use-fixtures :once with-instrument-all)

(defaggregate person
  [given-name family-name])

(defevent registered ::person
  [p]
  p)

(deftest test-stream-properties
  (let [store (-> (memory-store)
                  (wrap-stream-properties))
        repo  (bare-repository store)]
    (is (repo/commit! repo (-> (get-person repo "Alice" "Appleseed")
                               (registered))))
    (is (sub? [{::msg/type   ::registered
                :given-name  "Alice"
                :family-name "Appleseed"}]
              (retrieve-events store (::aggregate/id (person "Alice" "Appleseed")))))
    (is (sub? [{::msg/type   ::registered
                :given-name  "Alice"
                :family-name "Appleseed"}]
              (retrieve-events store all-events-stream-id)))))
