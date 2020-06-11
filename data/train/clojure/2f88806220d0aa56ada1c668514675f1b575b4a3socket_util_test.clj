(ns server.socket-util-test
  (:use server.core server.socket-util clojure.test
        [clojure.java.io :only [reader]])
  (:import server.java.MockSocket java.io.ByteArrayInputStream))

(deftest test-stream-to-string-1
  (let [rdr (reader (ByteArrayInputStream. (.getBytes "hello")))]
    (is (= (stream-to-string rdr 5)
           "hello"))))

(deftest test-stream-to-string-2
  (let [rdr (reader (ByteArrayInputStream. (.getBytes "hello")))]
    (is (= (stream-to-string rdr 2)
           "he"))))


(deftest test-stream-to-string-2
  (let [rdr (reader (ByteArrayInputStream. (.getBytes "hello")))]
    (is (nil? (stream-to-string rdr 7)))))


(deftest send-message-to-socket-1
  (let [sock (MockSocket. "")]
    (send-message-to-socket sock "hello world")
    (is (= "hello world"
           (-> sock
               .getOutputStream
               .toString)))))

(deftest send-message-to-socket-2
  (let [sock (MockSocket. "hello world")]
    (send-message-to-socket sock "goodbye world")
    (is (= "goodbye world")
        (-> sock
            .getOutputStream
            .toString))))
