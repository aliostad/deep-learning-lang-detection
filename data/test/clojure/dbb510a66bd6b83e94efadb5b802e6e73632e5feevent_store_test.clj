(ns jarvis.event-store-test
  (require [clojure.test :refer :all]
           [jarvis.event_store :refer :all])
  (:import (jarvis.event MidAirCollision)
           (jarvis.event_store InMemory SqlStore)))


(deftest in-memory-eventstore
  (testing "append and retrieve events"
    (let [store (-> (InMemory.)
                    (append-events 7 0
                                   [{:type :created}
                                    {:type :name-changed :data {:name "jarvis"}}
                                    {:type :skills-added :data #{:java}}
                                    {:type :skills-added :data #{:clojure :erlang}}
                                    {:type :skills-removed :data #{:java}}]))
          stream1 (stream-of store 7 {:max-sequence 1})
          stream2 (stream-of store 7 {:min-sequence 2 :max-sequence 3})]
      ;(pprint store)
      (is (= [{:stream-id "7" :sequence 1 :data {:type :created}}]
             (:events stream1)))
      (is (= [{:stream-id "7" :sequence 2 :data {:type :name-changed :data {:name "jarvis"}}}
              {:stream-id "7" :sequence 3 :data {:type :skills-added :data #{:java}}}]
             (:events stream2)))
      (is (= 5 (:version stream1)))
      (is (= 5 (:version stream2)))
      (is (= "7" (:stream-id stream1)))
      (is (= "7" (:stream-id stream2)))))

  (testing "retrieve events of an unknown stream"
    (let [store (InMemory.)
          stream (stream-of store "7" {:max-sequence 1})]
      (is (nil? stream))))

  (testing "retrieve empty events of an empty version range"
    (let [store (-> (InMemory.)
                    (append-events "7" 0
                                   [{:type :created}
                                    {:type :name-changed :data {:name "jarvis"}}
                                    {:type :skills-added :data #{:java}}]))
          stream (stream-of store "7" {:min-sequence 7})]
      (is (not (nil? stream)))
      (is (= "7" (:stream-id stream)))
      (is (= 3 (:version stream)))
      (is (= [] (:events stream)))))

  (testing "mid-air-collision when expected-version is invalid"
    (let [store (-> (InMemory.)
                    (append-events 7 0
                                   [{:type :created}
                                    {:type :name-changed :data {:name "jarvis"}}
                                    {:type :skills-added :data #{:java}}]))]
      ;(pprint store)
      (is (thrown? MidAirCollision
                   (append-events store 7 1
                                  [{:type :skills-added :data #{:clojure :erlang}}]))))))



(def db-spec {:classname   "org.postgresql.Driver"
              :subprotocol "postgresql"
              :subname     "//localhost:5432/jarvis-test"
              :user        "postgres"
              :password    "postgres"})

(defn- reset-event-store [db-spec]
  (do
    (drop-schema db-spec)
    (create-schema db-spec)
    (SqlStore. db-spec)))

(deftest sql-eventstore
  (testing "append and retrieve events"
    (drop-schema db-spec)
    (create-schema db-spec)
    (let [store (-> (SqlStore. db-spec)
                    (append-events "7" 0
                                   [{:type :created}
                                    {:type :name-changed :data {:name "jarvis"}}
                                    {:type :skills-added :data #{:java}}
                                    {:type :skills-added :data #{:clojure :erlang}}
                                    {:type :skills-removed :data #{:java}}]))
          stream1 (stream-of store 7 {:max-sequence 1})
          stream2 (stream-of store 7 {:min-sequence 2 :max-sequence 3})]
      (is (= [{:stream-id "7" :sequence 1 :event {:type :created}}]
             (:events stream1)))
      (is (= [{:stream-id "7" :sequence 2 :event {:type :name-changed :data {:name "jarvis"}}}
              {:stream-id "7" :sequence 3 :event {:type :skills-added :data #{:java}}}]
             (:events stream2)))
      (is (= 5 (:version stream1)))
      (is (= 5 (:version stream2)))
      (is (= 7 (:stream-id stream1)))
      (is (= 7 (:stream-id stream2))))

    (testing "retrieve events of an unknown stream"
      (let [store (reset-event-store db-spec)
            stream (stream-of store "7" {:max-version 1})]
        (is (nil? stream))))

    (testing "retrieve empty events of an empty version range"
      (let [store (-> (reset-event-store db-spec)
                      (append-events "7" 0
                                     [{:type :created}
                                      {:type :name-changed :data {:name "jarvis"}}
                                      {:type :skills-added :data #{:java}}]))
            stream (stream-of store "7" {:min-sequence 7})]
        (is (not (nil? stream)))
        (is (= "7" (:stream-id stream)))
        (is (= 3 (:version stream)))
        (is (= [] (:events stream)))))

    (testing "mid-air-collision when expected-version is invalid"
      (let [store (-> (reset-event-store db-spec)
                      (append-events "7" 0
                                     [{:type :created}
                                      {:type :name-changed :data {:name "jarvis"}}
                                      {:type :skills-added :data #{:java}}]))]
        (is (thrown? MidAirCollision
                     (append-events store "7" 1
                                    [{:type :skills-added :data #{:clojure :erlang}}])))))))
