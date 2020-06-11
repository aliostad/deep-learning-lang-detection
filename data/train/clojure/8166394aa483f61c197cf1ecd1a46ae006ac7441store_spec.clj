^{:cljs
  '(ns savant.test.store-spec
     (:require [buster-cljs.core :refer [is]]
               [clojure.set :as set]
               [savant.core
                :refer
                [IEventStore
                 exists? create-stream get-stream -same-store?
                 IEventStream get-commits-seq
                 get-events-seq get-events-vec commit-events!]])
     (:require-macros [buster-cljs.macros :refer [deftest describe it]]))}
(ns savant.test.store-spec
  (:require [clojure.test :refer :all]
            [buster-cljs.clojure :refer [describe it]]
            [slingshot.slingshot :refer (try+)]
            [clojure.set :as set]
            [savant.core :refer
             [IEventStore
              exists? create-stream get-stream -same-store?
              IEventStream get-commits-seq
              get-events-seq get-events-vec commit-events!]]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defprotocol IEventStreamReload
  (-reset-stream [this]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defn- get-event-store-fn [ns]
  ^{:cljs
    ;; ns-publics returns vars, we
    ;; replicate the deref behavior with
    ;; an atom
    '(atom (.-get-event-store ns))}
  (get (ns-publics ns) 'get-event-store))

(defn- submap? [m superm]
  (set/subset? (set (seq m)) (set (seq superm))))

(def default-test-bucket-name "event-store-tests")

(defn get-event-store-constructor-tests [ns opts invalid-opts]
  (describe "get-event-store constructor"
    (let [get-event-store (get-event-store-fn ns)]
      ^:clj
      (it "event store constructor has a get-event-store fn with arity eq to 1"
        (let [arglist (:arglists (meta get-event-store))]
          (is (= arglist '[[opts]])
              "arity of get-event-store should be 1")))

      (it "event store constructor idempotent when called with same options"
        (let [get-event-store (get-event-store-fn ns)
              store1 (@get-event-store opts)
              store2 (@get-event-store opts)]
          (is (-same-store? store1 store2)
              "get-event-store should be idempotent"))))))

(defn event-store-protocol-tests [ns opts]
  (let [get-event-store (get-event-store-fn ns)
        store (@get-event-store opts)
        test-bucket (or (:test-bucket opts) default-test-bucket-name)]

    (describe "event-store-protocol opts checker"
      (it "opts map requires string in :test-bucket key to run tests"
        (is (string? test-bucket)
            "The `opts` map must contain a string in key :test-bucket")))

    (describe "create-stream function"
      (it "requires bucket-name/id as str, keyword or symbol"
        ^:clj (is (thrown? AssertionError (create-stream store 123 "hello")))
        ^:clj (is (thrown? AssertionError (create-stream store "one" 123)))
        (is (satisfies? IEventStream (create-stream store test-bucket "bar"))
            "create-stream doesn't create a IEventStream object"))

      (it "throws an exception when called twice with same args"
        (^{:cljs 'try} try+
         (create-stream store test-bucket "world")
         (create-stream store test-bucket "world")
         (is false)
         ^{:cljs
           '(catch js/Error e
              (if (= (.-type e) :event-store/stream-exists)
                (is true
                    "create-stream twice should raise an `stream-exists` error")
                (throw e)))}
         (catch [:type :event-store/stream-exists] {}
           (is true)))))

    (it "get-stream returns nil when stream doesn't exist"
        (is (nil? (get-stream store test-bucket "non-existing"))))))

(defn event-stream-protocol-tests [ns opts]
  (let [get-event-store (get-event-store-fn ns)
        store (@get-event-store opts)
        test-bucket (or (:test-bucket opts) default-test-bucket-name)]

    (it "opts must contain a string :test-bucket to run tests"
        (is (string? test-bucket)
            "The test opts must contain a string :test-bucket"))

    (describe "on a new event-stream"
      (let [new-stream (create-stream store test-bucket "new-stream-test")]

        (it "get-commits-seq returns nil on a new event-stream"
            (is (nil? (get-commits-seq new-stream))
                "get-commits-req should return nil on a new event-stream"))

        (it "get-events-vec returns empty on a new event-stream"
            (is (empty? (get-events-vec new-stream))
              "get-events-vec should return an empty vector on a new event-stream")
            (is (empty? (get-events-vec new-stream 0))
              "get-events-vec should return an empty vector on a new event-stream")
            (is (empty (get-events-vec new-stream 0 0))
              "get-events-vec should return an empty vector on a new event-stream"))

        ;; supported by clojure only for now, patch already submitted for
        ;; clojurescript.
        ^:clj
        (it "get-events-vec -> IndexOutOfBoundsExc. if invalid subrange"
          ^{:cljs
            '(try
               (get-events-vec new-stream 0 5)
               (is false "Index out of bound error should be thrown")
               (catch js/Error e
                 (is true)))}
          (is (thrown? IndexOutOfBoundsException
                       (get-events-vec new-stream 0 5))))

        (it "get-events-seq returns nil on a new event-stream"
            (is (nil? (get-events-seq new-stream))
              "get-events-seq should return nil on a new event-stream"))

        (it "commit-events! creates an initial rev-hash"
          (let [empty-stream (create-stream store test-bucket
                                            "init-rev-hash-test")
                stream-after-commit (commit-events! empty-stream [1 2 3])
                last-commit-meta (meta (last
                                        (get-commits-seq
                                         stream-after-commit)))]
            (is (not (nil? (:event-store/rev-hash last-commit-meta)))
                "commit-events! should create an initial rev-hash")
            (is (nil? (:event-store/parent-rev-hash last-commit-meta))
                "commit-events! should have nil parent-rev-hash on first events")
            (-reset-stream empty-stream)))

        (it "commit-events! stores new events to the empty stream"
          (let [stream1 (commit-events! new-stream  [1 2 3])
                stream2 (commit-events! stream1 (with-meta [4 5 6] {:index 1}))
                stream3 (commit-events! stream2 [7 8 9])]
            (is (= (seq [1 2 3]) (get-events-seq stream1))
                "invalid event-seq")
            (is (= [1 2 3] (get-events-vec stream1))
                "invalid event-seq")
            (is (= (seq [1 2 3 4 5 6]) (get-events-seq stream2))
                "invalid event-seq")
            (is (= (seq [1 2 3 4 5 6 7 8 9]) (get-events-seq stream3))
                "invalid event-seq" )
            (is (submap? {:index 1}
                         (-> (get-commits-seq stream3)
                             second meta))
                "invalid event-seq")
            (-reset-stream new-stream)
            (-reset-stream stream1)
            (-reset-stream stream2)))))))
