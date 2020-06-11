(ns clj-kinesis-client.core-test
  (:require [clojure.test :refer :all]
            [clj-containment-matchers.clojure-test :refer :all]
            [clj-kinesis-client.core :refer :all])
  (:import [java.util UUID]))

(defonce client (create-client :endpoint "http://localhost:4567"))
(def test-stream-name (str (UUID/randomUUID)))

(defn- ensure-stream-action-fulfilled [client stream-name assert-fn]
  (let [list-streams (fn [] (-> client .listStreams .getStreamNames vec))]
    (loop [ready (assert-fn (list-streams))]
      (when-not ready
        (do
          (Thread/sleep 100)
          (recur (assert-fn (list-streams))))))))

(defn- delete-stream-if-found [client stream-name]
  (when (some #{stream-name} (-> client .listStreams .getStreamNames))
    (do
      (.deleteStream client stream-name)
      (ensure-stream-action-fulfilled client stream-name (fn [stream-names] (not (.contains stream-names stream-name)))))))

(defn- create-stream [client stream-name]
  (.createStream client stream-name (int 1))
  (ensure-stream-action-fulfilled client stream-name (fn [stream-names] (.contains stream-names stream-name))))

(defn prepare-kinesis [suite]
  (create-stream client test-stream-name)
  (suite)
  (delete-stream-if-found client test-stream-name))

(use-fixtures :each prepare-kinesis)

(deftest put-records-batch
  (testing "returns failed count and succeeded records"
    (is (equal? (put-records client test-stream-name ["lol" "bal"])
                {:failed-record-count 0
                 :records [{:sequence-number string? :shard-id "shardId-000000000000"}
                           {:sequence-number string? :shard-id "shardId-000000000000"}]}))))

(deftest put-one-record
  (testing "returns succeeded record"
    (is (equal? (put-record client test-stream-name "lolbal")
                {:sequence-number string? :shard-id "shardId-000000000000"}))))

