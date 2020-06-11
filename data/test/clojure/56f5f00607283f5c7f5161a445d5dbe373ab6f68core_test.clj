(ns clj-kinesis-worker.core-test
  (:require [clojure.test :refer :all]
            [clojure.core.async :as async]
            [byte-streams :as bytes]
            [clj-kinesis-worker.core :refer :all]
            [clj-kinesis-client.core :refer [create-client put-records]]))

(defn- delete-stream-if-found [client stream-name]
  (when (some #{stream-name} (-> client .listStreams .getStreamNames))
    (.deleteStream client stream-name)
    (Thread/sleep 500)))

(defn- create-stream [client stream-name]
  (.createStream client stream-name (int 1))
  (Thread/sleep 500))

(defonce publisher (create-client :endpoint "http://localhost:4567"))

(def records-chan (async/chan))

(defrecord TestProcessor [out-chan]
  RecordProcessor
  (initialize [_ _]
    (println "Sending test messages ...")
    (put-records publisher "unit-test-stream" ["foo" "bar"]))

  (process-records [_ _ rs _]
    (doseq [r rs]
      (println "Processing")
      (clojure.pprint/pprint r)
      (async/put! out-chan r)))

  (shutdown [_ _ _ _]))

(defn new-processor
  []
  (->TestProcessor records-chan))

(deftest publish-and-read
  (delete-stream-if-found publisher "unit-test-stream")
  (create-stream publisher "unit-test-stream")

  (let [worker (create-worker
                 {:kinesis              {:endpoint "http://localhost:4567"}
                  :dynamodb             {:endpoint "http://localhost:4568"}
                  :stream-name          "unit-test-stream"
                  :app-name             "unit-test-app"
                  :initial-position     :trim-horizon
                  :processor-factory-fn new-processor})]

    (future (.run worker))

    (testing "Record processing"
      (is (= "foo" (-> (async/<!! records-chan) .getData (bytes/convert String))))
      (is (= "bar" (-> (async/<!! records-chan) .getData (bytes/convert String)))))

    (.shutdown worker)))
