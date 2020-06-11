;; to run the tests you need an aws account
;; and a file test/props3t/aws.clj that contains something like
;; (def key "...")
;; (def skey "...")
;; (def test-bucket "...")
;; for your aws account

(ns propS3t.test.core
  (:refer-clojure :exclude [key])
  (:load "aws") ;; aws credentials and test bucket name
  (:use [propS3t.core]
        [clojure.test])
  (:require [clojure.java.io :as io])
  (:import (java.util UUID)
           (java.io ByteArrayInputStream
                    ByteArrayOutputStream)))

(def ^{:dynamic true} *creds*)

(use-fixtures :once
  (fn [f]
    (create-bucket {:aws-key key
                    :aws-secret-key skey}
                   test-bucket)
    (binding [*creds* {:aws-key key
                       :aws-secret-key skey}]
      (f))))

(comment

  (deftest t-bucket-life-cycle
    (let [b (str (UUID/randomUUID))]
      (try
        (is (create-bucket {:aws-key key
                            :aws-secret-key skey}
                           b))
        (is (contains? (set (map :name (list-buckets *creds*))) b))
        (finally
          (is (delete-bucket {:aws-key key
                              :aws-secret-key skey}
                             b))))))

  (deftest t-multipart-upload
    (let [{:keys [upload-id key bucket] :as mp}
          (start-multipart *creds* test-bucket "multipart-test")]
      (is (and upload-id key bucket))
      (is (= test-bucket bucket))
      (is (= key "multipart-test"))
      (let [five-megs (.getBytes (apply str (repeat (* 5 1024 1024) \a)))
            tags (doall (pmap #(write-part *creds* mp (inc %)
                                           (ByteArrayInputStream. five-megs)
                                           :length (count five-megs))
                              (range 2)))]
        (end-multipart *creds* mp test-bucket "multipart-test" tags)
        (with-open [baos (ByteArrayOutputStream.)]
          (io/copy (read-stream *creds* test-bucket "multipart-test")
                   baos)
          (is (= (* 2 (count five-megs)) (count (.toByteArray baos))))))))
  )

(deftest t-test-bucket-exists
  (is (contains? (set (map :name (list-buckets *creds*))) test-bucket)))

(deftest t-write-stream
  (is (write-stream *creds* test-bucket "write-stream-test"
                    (ByteArrayInputStream.
                     (.getBytes "hello world"))
                    :length 11))
  (is (contains? (set (map :key (list-bucket *creds* test-bucket "" 10)))
                 "write-stream-test"))
  (dotimes [i 11]
    (is (write-stream *creds* test-bucket (str "write-stream-test" i)
                      (ByteArrayInputStream.
                       (.getBytes "hello world"))
                      :length 11)))
  (is (= 10 (count (list-bucket *creds* test-bucket "" 10))))
  (is (= 4 (count (list-bucket *creds* test-bucket "write-stream-test" 10
                               "write-stream-test5")))))

(deftest t-read-stream
  (is (write-stream *creds* test-bucket "write-stream-test"
                    (ByteArrayInputStream.
                     (.getBytes "hello world"))
                    :length 11))
  (with-open [baos (ByteArrayOutputStream.)]
    (io/copy (read-stream *creds* test-bucket "write-stream-test")
             baos)
    (is (= "hello world" (String. (.toByteArray baos)))))
  (with-open [baos (ByteArrayOutputStream.)]
    (io/copy (read-stream *creds* test-bucket "write-stream-test"
                          :offset 6)
             baos)
    (is (= "world" (String. (.toByteArray baos)))))
  (with-open [baos (ByteArrayOutputStream.)]
    (io/copy (read-stream *creds* test-bucket "write-stream-test"
                          :length 9
                          :offset 6)
             baos)
    (is (= "worl" (String. (.toByteArray baos)))))
  (with-open [baos (ByteArrayOutputStream.)]
    (io/copy (read-stream *creds* test-bucket "write-stream-test"
                          :length 4)
             baos)
    (is (= "hello" (String. (.toByteArray baos))))))

(deftest t-output-stream
  (with-open [s (output-stream *creds* test-bucket "write-stream2-test"
                               :length 5)]
    (io/copy (.getBytes "hello") s))
  (is (contains? (set (map :key (list-bucket *creds* test-bucket "" 1000)))
                 "write-stream2-test"))
  (with-open [baos (ByteArrayOutputStream.)
              stream (read-stream *creds* test-bucket "write-stream2-test")]
    (io/copy stream baos)
    (is (= "hello" (String. (.toByteArray baos))))))

(deftest t-delete-object
  (is (write-stream *creds* test-bucket "write-stream-test"
                    (ByteArrayInputStream.
                     (.getBytes "hello world"))
                    :length 11))
  (is (contains? (set (map :key (list-bucket *creds* test-bucket "" 10)))
                 "write-stream-test"))
  (is (delete-object *creds* test-bucket "write-stream-test"))
  (is (not (contains? (set (map :key (list-bucket *creds* test-bucket "" 10)))
                      "write-stream-test"))))

(deftest t-headers
  (write-stream *creds* test-bucket "write-stream-test"
                (ByteArrayInputStream.
                 (.getBytes "hello world"))
                :length 11
                :headers {"content-type" "application/octet-stream"})
  (is (contains? (set (map :key (list-bucket *creds* test-bucket "" 10)))
                 "write-stream-test"))
  (is (delete-object *creds* test-bucket "write-stream-test"))
  (is (not (contains? (set (map :key (list-bucket *creds* test-bucket "" 10)))
                      "write-stream-test"))))
