(ns rill.wheel.wrap-new-events-callback-test
  (:require [clojure.test :refer [deftest is use-fixtures]]
            [rill.event-store.memory :refer [memory-store]]
            [rill.message :as msg]
            [rill.wheel :as aggregate :refer [defaggregate defevent]]
            [rill.wheel.bare-repository :refer [bare-repository]]
            [rill.wheel.repository :as repo]
            [rill.wheel.testing :refer [sub? with-instrument-all]]
            [rill.wheel.wrap-new-events-callback :refer [wrap-new-events-callback]]
            [rill.wheel.wrap-stream-properties :refer [wrap-stream-properties]]))

(use-fixtures :once with-instrument-all)

(defaggregate person
  [given-name family-name])

(defevent registered ::person
  [p]
  p)

(deftest test-stream-properties
  (let [new-events (atom [])
        store (-> (memory-store)
                  (wrap-stream-properties)
                  (wrap-new-events-callback (fn [e]
                                              (swap! new-events conj e))))
        repo  (bare-repository store)]
    (is (repo/commit! repo (-> (get-person repo "Alice" "Appleseed")
                               (registered))))
    (is (repo/commit! repo (-> (get-person repo "Somebody" "Else")
                               (registered))))
    (is (sub? [{::msg/type   ::registered
                :given-name  "Alice"
                :family-name "Appleseed"}
               {::msg/type   ::registered
                :given-name  "Somebody"
                :family-name "Else"}]
         @new-events))))
