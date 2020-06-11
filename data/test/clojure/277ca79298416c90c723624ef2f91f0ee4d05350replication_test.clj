(ns kvstore.replication-test
  (:require [clojure.test :refer :all]
            [kvstore.protocol :refer :all]
            [manifold.stream :as s]
            [kvstore.protocol :as protocol]
            [kvstore.replication :as replication]
            [kvstore.core :as core]
            [kvstore.store :as store]))

(deftest test-sent-offset
  (testing "testing the offset is sent"
    (let [stream (s/stream)
          offset (replication/get-offset)]
      (replication/send-offset stream)
      (is (= offset) (s/take! stream)))))

(deftest test-received-offset
  (testing "testing the data since the offset is sent"
    (store/put! "key" "value")
    (let [stream (s/stream)
          offset (replication/get-offset)]
      (replication/offset 0 stream)
      (is (= "RSET key value\r\n" @(s/take! stream)))
      (store/put! "key2" "value2")
      (store/put! "key3" "value3")
      (replication/offset offset stream)
      (is (= "RSET key3 value3\r\n" @(s/take! stream)))
      (is (= "RSET key2 value2\r\n" @(s/take! stream))))))

(deftest test-generate-set-cmd []
  (testing "testing the cmd set for replication is created ok."
    (is (= "RSET key value\r\n" (replication/generate-set-cmd "key" "value")))))
