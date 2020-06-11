(ns parser.test.file
  (:use [parser.file])
  (:use [clojure.test])
  (:use [clojure.contrib.mock])
  (:use [parser.convert :only (hex-to-byte)]))

(deftest read-simple-file
  (let [file-stream (get-input-stream "test/simple-file.txt")]
    (doseq [c [\C \o \n \t \e \n \t]]
      (is (= c (char (.read file-stream)))))))

(defn mock-stream [hex-ary]
  (let [ary-size (count hex-ary)
        byte-ary (byte-array ary-size)]
    (doseq [i (range ary-size)]
        (aset-byte byte-ary i (hex-to-byte (nth hex-ary i))))
    (java.io.ByteArrayInputStream. byte-ary)))

(deftest read-mock-file
  (expect [get-input-stream (returns (mock-stream ["ff" "00" "0f"]))]
          (doseq [c [255 0 15]]
            (is (= c (.read (get-input-stream "file")))))))

(deftest read-bytes-from-input-stream
  (let [input-stream (mock-stream ["CA" "FE" "BA" "BE"])]
    (is (= [202 254 186 190] (read-next-bytes input-stream 4)))))

(deftest read-bytes-as-hex-from-input-stream
  (let [input-stream (mock-stream ["CA" "FE" "BA" "BE"])]
    (is (= ["ca" "fe" "ba" "be"] (read-next-bytes-as-hex input-stream 4)))))

(deftest read-bytes-as-hex-from-input-stream
  (let [input-stream (mock-stream ["CA" "FE" "BA" "BE"])]
    (is (= "cafebabe" (read-next-bytes-as-hex-str input-stream 4)))))

