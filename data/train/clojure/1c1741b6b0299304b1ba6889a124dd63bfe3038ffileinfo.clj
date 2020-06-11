(ns parser.test.fileinfo
  (:use [parser.fileinfo])
  (:use [parser.convert])
  (:use [clojure.test])
  (:use [parser.test.file]))

(deftest read-magic-number
  (doseq [[stream-bytes result] [
                                 ['("CA" "FE" "BA" "BE")
                                  "cafebabe"]
                                 ['("CA" "FE" "BA" "BE" "01" "02")
                                  "cafebabe"]
                                 ['("AA" "BB" "CC" "DD" "EE")
                                  "aabbccdd"]]]
    (let [input-stream (mock-stream stream-bytes)]
      (is (= {:magic-number result} (magic-number input-stream))))))

(deftest read-minor-version
  (doseq [[stream-bytes result] [
                                 ['("00" "00")
                                  "0000"]
                                 ['("00" "00" "01" "02")
                                  "0000"]
                                 ['("20" "01" "DD" "EE")
                                  "2001"]]]
    (let [input-stream (mock-stream stream-bytes)]
      (is (= {:minor-version result} (minor-version input-stream))))))

(deftest read-major-version
  (doseq [[stream-bytes result] [
                                 ['("00" "00")
                                  "0000"]
                                 ['("00" "00" "01" "02")
                                  "0000"]
                                 ['("20" "01" "DD" "EE")
                                  "2001"]]]
    (let [input-stream (mock-stream stream-bytes)]
      (is (= {:major-version result} (major-version input-stream))))))