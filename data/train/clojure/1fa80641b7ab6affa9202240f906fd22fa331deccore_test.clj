(ns slack-slurper.core-test
  (:require [clojure.test :refer :all]
            [manifold.stream :as s]
            [manifold.deferred :as d]
            [slack-slurper.logging]
            [environ.core :refer [env]]
            [slack-slurper.core :refer :all]))

(slack-slurper.logging/configure-logging!)

#_(defn stream-test []
  (let [msg-stream (s/stream)
        msg-only (message-stream msg-stream)]
    (s/put! msg-stream "logger info - {\"type\": \"message\", \"text\": \"hi\"}")
    (s/take! msg-only)))

(defn log-contains? [output]
  (.contains (slurp (env :log-file)) output))

(defn reset-log! []
  (spit (env :log-file) ""))

(deftest integration-test
  (testing "all together now"
    (reset-log!)
    (let [stream (s/stream 5)
          sink (s/stream 5)]
      (start! stream sink)
      (s/put! stream "here's a message")
      (s/put! stream "second message")
      (is (log-contains? "here's a message"))
      (is (log-contains? "second message"))
      (stop!)
      (let [hb (s/take! sink)]
        (is d/realized? hb)
        (is (.contains @hb "\"type\":\"ping\"")))
      )))
