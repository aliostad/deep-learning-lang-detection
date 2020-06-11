(ns revent-clj.memory-event-store-test
  (:require [clojure.test :refer :all]
            [revent-clj.event :refer :all]
            [revent-clj.either :refer :all]
            [revent-clj.memory-event-store :as s]))

(def stream-id 1)

(def other-stream-id 2)

(def ^:dynamic persist-events)

(def ^:dynamic read-events)

(defn successful [[value error]] (nil? error))

(def failed (complement successful))

(defn setup-store [test]
  (let [store (s/empty-store)
        now (constantly :now)]
    (binding [persist-events (partial s/persist-events store now)
              read-events (partial s/read-events store)]
      (test))))

(use-fixtures :each setup-store)

(deftest persist-event-successfully
  (is (= (success [(->Event 1 :some-event :now)])
         (persist-events stream-id [:some-event]))))

(deftest persist-multiple-events
  (is (= (success [(->Event 1 :event1 :now)
                   (->Event 2 :event2 :now)
                   (->Event 3 :event3 :now)])
         (persist-events stream-id [:event1 :event2 :event3]))))

(deftest read-empty-event-stream
  (is (empty? (read-events stream-id))))

(deftest read-persisted-event
  (persist-events stream-id [:some-event])

  (testing "for same stream ID"
    (is (= [(->Event 1 :some-event :now)]
           (read-events stream-id))))

  (testing "for different stream ID"
    (is (empty? (read-events other-stream-id)))))

(deftest persist-first-event-with-expected-version
  (is (= (failure :concurrent-modification)
         (persist-events stream-id [:event1] 1))))

(deftest persist-subsequent-events-with-expected-version
  (persist-events stream-id [:event1 :event2])

  (testing "fail when expected version doesn't match (too low)"
    (is (failed (persist-events stream-id [:other-event] 1))))

  (testing "fail when expected version doesn't match (to high)"
    (is (failed (persist-events stream-id [:other-event] 3))))

  (testing "succeed when expected version matches"
    (is (successful (persist-events stream-id [:event3] 2)))
    (is (successful (persist-events stream-id [:event4] 3)))))

(deftest persist-events-atomically
  (is (successful (persist-events stream-id [:event1])))
  (is (failed (persist-events stream-id [:event2 :event3] 0)))
  (is (= [(->Event 1 :event1 :now)]
         (read-events stream-id))))
