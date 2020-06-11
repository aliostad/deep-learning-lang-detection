(ns server.core-test
  (:use clojure.test server.core)
  (:import java.io.ByteArrayInputStream))

(deftest test-normalize-1
  (is (= (str "GET / HTTP/1.1" crlf crlf)
         (normalize "GET / HTTP/1.1" ""))))

(deftest test-normalize-2
  (is (= (str "GET / HTTP/1.1" crlf "Header1: a" crlf "Header2: b" crlf crlf)
         (normalize "GET / HTTP/1.1" "Header1: a" "Header2: b" ""))))

(deftest test-url-decode-1
  (is (= "test" (url-decode "test"))))

(deftest test-url-decode-2
  (is (= "test test" (url-decode "test%20test"))))

(deftest test-get-config-1
  (let [properties-string "a=1\nb=2"
        stream (ByteArrayInputStream. (.getBytes properties-string))]
    (is (= (get-config stream)
           {"a" "1", "b" "2"}))))

(deftest test-get-config-2
  (let [properties-string "a=1\nb=2\nc=3"
        stream (ByteArrayInputStream. (.getBytes properties-string))]
    (is (= (get-config stream)
           {"a" "1", "b" "2", "c" "3"}))))

(deftest test-get-config-3
  (let [properties-string ""
        stream (ByteArrayInputStream. (.getBytes properties-string))]
    (is (= (get-config stream)
           {}))))

(deftest test-get-config-4
  (let [properties-string "port=3000"
        stream (ByteArrayInputStream. (.getBytes properties-string))
        opts {"port" "5000"}]
    (is (= (get-config stream opts)
           {"port" "5000"}))))

(deftest test-get-config-5
  (let [properties-string "port=6000\nwebroot=./"
        stream (ByteArrayInputStream. (.getBytes properties-string))
        opts {"webroot" "/public"}]
    (is (= (get-config stream opts)
           {"port" "6000" "webroot" "/public"}))))

(deftest test-get-config-6
  (let [properties-string "port=6000\nwebroot=./"
        stream (ByteArrayInputStream. (.getBytes properties-string))
        opts {}]
    (is (= (get-config stream opts)
           {"port" "6000" "webroot" "./"}))))

(deftest test-get-config-7
  (let [properties-string "port=6000\nwebroot=./"
        stream (ByteArrayInputStream. (.getBytes properties-string))
        opts {"port" "1" "webroot" "/public"}]
    (is (= (get-config stream opts)
           {"port" "1" "webroot" "/public"}))))
