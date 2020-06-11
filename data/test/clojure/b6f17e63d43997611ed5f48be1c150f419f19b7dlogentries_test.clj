(ns truckerpath.unilog-appenders.logentries-test
  (:require [clojure.test :refer :all]
            [clojure.tools.logging :as log]
            [unilog.config :as unilog]

            [truckerpath.unilog-appenders.logentries]))

(deftest logentries-test
  (testing "logentries appender"
    (let [config {:console false
                  :appenders [{:appender :logentries
                               :token "1-2-3-4"
                               :debug true
                               :ssl true
                               :pattern "%msg%n"}]}
          err-byte-stream (java.io.ByteArrayOutputStream.)
          err-stream (java.io.PrintStream. err-byte-stream)]
      (System/setErr err-stream)
      (unilog/start-logging! config)
      (log/info "Test message")
      (is (= (str "LE Setting debug to true\n"
                  "LE Setting token to 1-2-3-4\n"
                  "LE Queueing Test message\n")
             (str err-byte-stream))))))
