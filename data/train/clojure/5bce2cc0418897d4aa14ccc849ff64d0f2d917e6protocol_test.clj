(ns kvstore.protocol-test
  (:require [clojure.test :refer :all]
            [kvstore.protocol :refer :all]
            [manifold.stream :as s]
            [kvstore.protocol :as protocol :refer [parse-cmd]]
            [kvstore.store :as store])
  (:import [java.util.concurrent ArrayBlockingQueue]))

(defn cmd1 [arg0 arg1 stream]
  (is (= arg0 "arg0"))
  (is (= arg1 "arg1"))
  (s/put! stream "CMD1\r\n"))

(defn cmd2 [arg0 stream]
  (is (= arg0 "arg0"))
  (s/put! stream "CMD2\r\n"))

(defmethod parse-cmd "CMD1"
  [cmd & args]
  (apply cmd1 args))

(defmethod parse-cmd "CMD2"
  [cmd & args]
  (apply cmd2 args))

(deftest test-run-cmd
  (testing "testing a command is well parsed."
    (protocol/run-cmd "CMD1 arg0 arg1" (s/stream))))

(deftest test-process-commands []
  (testing "testing the stream of commands is well parsed."
    (let [stream (s/stream)]
      (protocol/process-commands stream "CMD1 arg0 arg1\r\nCMD2 arg0\r\n"
                                 (fn [s cmd]
                                   (run-cmd cmd s)))
      (is (= "CMD1\r\n" @(s/take! stream)))
      (is (= "CMD2\r\n" @(s/take! stream))))))
