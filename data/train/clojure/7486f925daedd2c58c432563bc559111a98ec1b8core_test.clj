(ns flatland.io.core-test
  (:use clojure.test
        flatland.io.core
        [clojure.java.io :only [input-stream]])
  (:import (java.nio ByteBuffer)))

(deftest byte-buffer-input-stream
  (let [stream (input-stream (ByteBuffer/wrap (byte-array (map byte (range 10)))))]
    (is (= 0 (.read stream)))
    (is (= 1 (.read stream)))
    (is (= 8 (.available stream)))
    (let [buf (byte-array 5)]
      (is (= 5 (.read stream buf)))
      (is (= [2 3 4 5 6] (seq buf)))
      (is (= 3 (.read stream buf 1 4)))
      (is (= [2 7 8 9 6] (seq buf)))
      (is (= -1 (.read stream))))))

(deftest concat-input-stream
  (let [stream (input-stream [(ByteBuffer/wrap (byte-array (map byte (range 5))))
                              (byte-array (map byte (range 5 10)))])]
    (is (= 0 (.read stream)))
    (is (= 1 (.read stream)))
    (is (= 3 (.available stream)))
    (let [buf (byte-array 5)]
      (is (= 3 (.read stream buf)))
      (is (= [2 3 4 0 0] (seq buf)))
      (is (= 2 (.read stream buf 3 2)))
      (is (= [2 3 4 5 6] (seq buf)))
      (is (= 3 (.read stream buf 0 5)))
      (is (= [7 8 9 5 6] (seq buf)))
      (is (= -1 (.read stream))))))

(deftest test-bufseq->bytes
  (let [inputs (for [input [[1 2 3] [9 8 7]]]
                 (ByteBuffer/wrap (byte-array (map byte input))))
        expected [1 2 3 9 8 7]
        output (bufseq->bytes inputs)]
    (is (= (class (byte-array 0)) (class output))
        "should return a byte array")
    (is (= (count output) (count expected))
        "should use exactly enough bytes")
    (is (= (seq output) expected)
        "should concat the inputs")))


(deftest test-catbytes
  (let [contents [[1 2 3] [4 5 6] [7 8 9]]
        arrays (for [data contents]
                 (byte-array (map byte data)))
        merged (apply catbytes arrays)]
    (is (= (class merged) (class (first arrays))))
    (is (= (apply concat contents)
           (seq merged)))))
