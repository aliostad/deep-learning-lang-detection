(ns savant.test.store-spec
  (:require [clojure.test :refer :all]
            [clojure.set :as set]
            [slingshot.slingshot :refer (try+)]
            [savant.core :refer
             (IEventStore
              exists? create-stream get-stream -same-store?
              IEventStream get-commits-seq
              get-events-seq get-events-vec commit-events!)]))

(defn- namespace-fn [ns & args]
  (map #(get (ns-publics ns) %) args))

(defn- submap? [m superm]
  (set/subset? (set (seq m)) (set (seq superm))))

(def default-test-bucket-name "event-store-tests")

(defn get-event-store-constructor-tests [ns opts invalid-opts]
  (testing "event store constructor"
    (let [[get-event-store] (namespace-fn ns 'get-event-store)]

      (testing "has a get-event-store fn with arity eq to 1"
        (let [arglist (:arglists (meta get-event-store))]
          (is (= arglist '[[opts]]))))

      (let [get-event-store @get-event-store]
        (testing "idempotent when called with same options"
          (let [store1 (get-event-store opts)
                store2 (get-event-store opts)]
            (is (-same-store? store1 store2))))))))

(defn event-store-protocol-tests [ns opts]
  (let [[get-event-store] (namespace-fn ns 'get-event-store)
        store (@get-event-store opts)
        test-bucket (or (:test-bucket opts) default-test-bucket-name)]
    (is (string? test-bucket)
        "The test opts must contain a string :test-bucket")
    (testing "create-stream requires bucket-name/id as str, keyword or symbol"
      (is (thrown? AssertionError (create-stream store 123 "hello")))
      (is (thrown? AssertionError (create-stream store "one" 123)))
      (is (satisfies? IEventStream (create-stream store test-bucket "bar"))))

    (testing "create-stream throws a stone when called twice with same args"
      (try+
        (create-stream store test-bucket "world")
        (create-stream store test-bucket "world")
        (is false)
        (catch [:type :event-store/stream-exists] {}
          (is true))))

    (testing "get-stream returns nil when stream doesn't exist"
      (is (nil? (get-stream store test-bucket "non-existing"))))))

(defn event-stream-protocol-tests [ns opts]
  (let [[get-event-store] (namespace-fn ns 'get-event-store)
        store (@get-event-store opts)
        test-bucket (or (:test-bucket opts) default-test-bucket-name)]
    (is (string? test-bucket)
        "The test opts must contain a string :test-bucket")
    (testing "on a new event-stream"
      (let [new-stream (create-stream store test-bucket "new-stream-test")]

        (testing "get-commits-seq returns nil on a new event-stream"
          (is (nil? (get-commits-seq new-stream))))

        (testing "get-events-vec returns empty on a new event-stream"
          (is (empty? (get-events-vec new-stream)))
          (is (empty? (get-events-vec new-stream 0)))
          (is (empty? (get-events-vec new-stream 0 0))))

        (testing "get-events-vec -> IndexOutOfBoundsExc. if invalid subrange"
          (is (thrown? IndexOutOfBoundsException
                       (get-events-vec new-stream 0 5))))

        (testing "get-events-seq returns nil on a new event-stream"
          (is (nil? (get-events-seq new-stream))))

        (testing "commit-events! creates an initial rev-hash"
          (let [empty-stream (create-stream store test-bucket
                                            "init-rev-hash-test")
                stream-after-commit (commit-events! empty-stream [1 2 3])
                last-commit-meta (meta (last
                                        (get-commits-seq
                                           stream-after-commit)))]
            (is (not (nil? (:event-store/rev-hash last-commit-meta))))
            (is (nil? (:event-store/parent-rev-hash last-commit-meta)))))

        (testing "commit-events! stores new events to the empty stream"
          (let [stream1 (commit-events! new-stream  [1 2 3])
                stream2 (commit-events! stream1 (with-meta [4 5 6] {:index 1}))
                stream3 (commit-events! stream2 [7 8 9])]
            (is (= (seq [1 2 3]) (get-events-seq stream1)))
            (is (= [1 2 3] (get-events-vec stream1)))
            (is (= (seq [1 2 3 4 5 6]) (get-events-seq stream2)))
            (is (= (seq [1 2 3 4 5 6 7 8 9]) (get-events-seq stream3)))
            (is (submap? {:index 1}
                         (-> (get-commits-seq stream3)
                             second meta)))))))))

