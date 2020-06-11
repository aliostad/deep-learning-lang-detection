(ns cav.mtj-test
  (:require [clojure.test :refer :all]
            [clojure.core.matrix :refer [matrix equals]]
            [cav.mtj.core.matrix]
            [cav.mtj :refer :all]
            [clojure.java.io :as io]))

(deftest io-test
  (testing "save read matrix"
    (let [A (matrix :mtj [[1 2] [3 4] [5 6]])]
      (with-open [stream (java.io.ByteArrayOutputStream.)
                  writer (io/writer stream)]
        (save-matrix A writer)
        (with-open [reader (io/reader (.toByteArray stream))]
          (is (equals (read-matrix reader) (matrix :mtj [[1 2] [3 4] [5 6]])))))))
  (testing "save read vector"
    (let [a (matrix :mtj (range 10))]
      (with-open [stream (java.io.ByteArrayOutputStream.)
                  writer (io/writer stream)]
        (save-vector a writer)
        (with-open [reader (io/reader (.toByteArray stream))]
          (is (equals (read-vector reader) (matrix :mtj (range 10)))))))))
