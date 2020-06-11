(ns parser.test.constantpool
  (:use [parser.constantpool])
  (:use [parser.convert])
  (:use [clojure.test])
  (:use [parser.test.file]))

(deftest read-constant-count
  (doseq [[stream-bytes result] [
                                 ['("00" "03") 2
                                  '("00" "0F") 15]]]
    (let [input-stream (mock-stream stream-bytes)]
      (is (= result (constant-count input-stream))))))

(deftest read-class-info
  (doseq [[stream-bytes result] [
                                ['("00" "01") 1
                                 '("00" "F0") 125]]]
    (let [input-stream (mock-stream stream-bytes)]
      (is (= {:class-info {:name-index result}} (class-info input-stream))))))

(deftest read-fieldref-info
  (doseq [[stream-bytes class-index name-type-index] [
                                ['("00" "01" "00" "03") 1 3
                                 '("00" "F0" "01" "00") 125 126]]]
    (let [input-stream (mock-stream stream-bytes)]
      (is (= {:fieldref-info {:class-index class-index
                         :name-and-type-index name-type-index}}
             (fieldref-info input-stream))))))

(deftest read-methodref-info
  (doseq [[stream-bytes class-index name-type-index actual] [
                                ['("00" "01" "00" "03") 1 3
                                 '("00" "F0" "01" "00") 125 126]]]
    (let [input-stream (mock-stream stream-bytes)]
      (is (= {:methodref-info {:class-index class-index
                          :name-and-type-index name-type-index}}
             (methodref-info input-stream))))))

(deftest read-interface-methodref-info
  (doseq [[stream-bytes class-index name-type-index actual] [
                                ['("00" "01" "00" "03") 1 3
                                 '("00" "F0" "01" "00") 125 126]]]
    (let [input-stream (mock-stream stream-bytes)]
      (is (= {:interface-methodref-info {:class-index class-index
                          :name-and-type-index name-type-index}}
             (interface-methodref-info input-stream))))))

(deftest read-string-info
  (doseq [[stream-bytes result] [
                                ['("00" "01") 1
                                 '("00" "F0") 125]]]
    (let [input-stream (mock-stream stream-bytes)]
      (is (= {:string-info {:string-index result}} (string-info input-stream))))))

(deftest read-integer-info
  (doseq [[stream-bytes result] [
                                ['("00" "01" "E2" "40") 123456
                                 '("FF" "FF" "FF" "FF") -1]]]
    (let [input-stream (mock-stream stream-bytes)]
      (is (= {:integer-info {:value result}} (integer-info input-stream))))))

(deftest read-float-info
  (doseq [[stream-bytes result] [
                                ['("40" "C0" "00" "00") 6.0
                                 '("10" "0C" "00" "02") 2.761013770126649E-29]]]
    (let [input-stream (mock-stream stream-bytes)]
      (is (= {:float-info {:value result}} (float-info input-stream))))))

(deftest read-long-info
  (doseq [[stream-bytes result] [
                                ['("00" "00" "00" "00" "40" "C0" "00" "00") 1086324736
                                 '("FF" "FF" "FF" "FF" "FF" "FF" "FF" "FF") -1]]]
    (let [input-stream (mock-stream stream-bytes)]
      (is (= {:long-info {:value result}} (long-info input-stream))))))

(deftest read-double-info
  (doseq [[stream-bytes result] [
                                ['("00" "00" "00" "00" "00" "00" "00" "03") 3
                                 '("00" "00" "AB" "CD" "AB" "CD" "AB" "CD") 1.88899839028173E14]]]
    (let [input-stream (mock-stream stream-bytes)]
      (is (= {:double-info {:value result}} (double-info input-stream))))))

(deftest read-name-and-type-info
  (doseq [[stream-bytes name-index descriptor-index actual] [
                                ['("00" "01" "00" "03") 1 3
                                 '("00" "F0" "01" "00") 125 126]]]
    (let [input-stream (mock-stream stream-bytes)]
      (is (= {:name-and-type-info {:name-index name-index
                                   :descriptor-index descriptor-index}}
             (name-and-type-info input-stream))))))

(deftest read-utf8-info
  (doseq [[stream-bytes result] [
                                 ['("00" "0A" "48" "65" "6C" "6C"
                                    "6F" "57" "6F" "72" "6C" "64") "HelloWorld"]]]
    (let [input-stream (mock-stream stream-bytes)]
      (is (= {:utf8-info {:value result}} (utf8-info input-stream))))))

(deftest read-class-info-type
  (doseq [[stream-bytes result] [
                                ['("07" "00" "01") 1
                                 '("07" "00" "F0") 125]]]
    (let [input-stream (mock-stream stream-bytes)]
      (is (= {:class-info {:name-index result}} (parse-const-type input-stream))))))

(deftest read-fieldref-info-type
  (doseq [[stream-bytes class-index name-type-index] [
                                ['("09" "00" "01" "00" "03") 1 3
                                 '("09" "00" "F0" "01" "00") 125 126]]]
    (let [input-stream (mock-stream stream-bytes)]
      (is (= {:fieldref-info {:class-index class-index
                         :name-and-type-index name-type-index}}
             (parse-const-type input-stream))))))

(deftest read-methodref-info-type
  (doseq [[stream-bytes class-index name-type-index actual] [
                                ['("0A" "00" "01" "00" "03") 1 3
                                 '("0A" "00" "F0" "01" "00") 125 126]]]
    (let [input-stream (mock-stream stream-bytes)]
      (is (= {:methodref-info {:class-index class-index
                          :name-and-type-index name-type-index}}
             (parse-const-type input-stream))))))

(deftest read-interface-methodref-info-type
  (doseq [[stream-bytes class-index name-type-index actual] [
                                ['("0B" "00" "01" "00" "03") 1 3
                                 '("0B" "00" "F0" "01" "00") 125 126]]]
    (let [input-stream (mock-stream stream-bytes)]
      (is (= {:interface-methodref-info {:class-index class-index
                          :name-and-type-index name-type-index}}
             (parse-const-type input-stream))))))

(deftest read-string-info-type
  (doseq [[stream-bytes result] [
                                ['("08" "00" "01") 1
                                 '("08" "00" "F0") 125]]]
    (let [input-stream (mock-stream stream-bytes)]
      (is (= {:string-info {:string-index result}} (parse-const-type input-stream))))))

(deftest read-integer-info-type
  (doseq [[stream-bytes result] [
                                ['("03" "00" "01" "E2" "40") 123456
                                 '("03" "FF" "FF" "FF" "FF") -1]]]
    (let [input-stream (mock-stream stream-bytes)]
      (is (= {:integer-info {:value result}} (parse-const-type input-stream))))))

(deftest read-float-info-type
  (doseq [[stream-bytes result] [
                                ['("04" "40" "C0" "00" "00") 6.0
                                 '("04" "10" "0C" "00" "02") 2.761013770126649E-29]]]
    (let [input-stream (mock-stream stream-bytes)]
      (is (= {:float-info {:value result}} (parse-const-type input-stream))))))

(deftest read-long-info-type
  (doseq [[stream-bytes result] [
                                ['("05" "00" "00" "00" "00" "40" "C0" "00" "00") 1086324736
                                 '("05" "FF" "FF" "FF" "FF" "FF" "FF" "FF" "FF") -1]]]
    (let [input-stream (mock-stream stream-bytes)]
      (is (= {:long-info {:value result}} (parse-const-type input-stream))))))

(deftest read-double-info-type
  (doseq [[stream-bytes result] [
                                ['("06" "00" "00" "00" "00" "00" "00" "00" "03") 3
                                 '("06" "00" "00" "AB" "CD" "AB" "CD" "AB" "CD") 1.88899839028173E14]]]
    (let [input-stream (mock-stream stream-bytes)]
      (is (= {:double-info {:value result}} (parse-const-type input-stream))))))

(deftest read-name-and-type-info
  (doseq [[stream-bytes name-index descriptor-index actual] [
                                ['("0c" "00" "01" "00" "03") 1 3
                                 '("0c" "00" "F0" "01" "00") 125 126]]]
    (let [input-stream (mock-stream stream-bytes)]
      (is (= {:name-and-type-info {:name-index name-index
                                   :descriptor-index descriptor-index}}
             (parse-const-type input-stream))))))

(deftest read-utf8-info
  (doseq [[stream-bytes result] [
                                 ['("01" "00" "0A" "48" "65" "6C" "6C"
                                    "6F" "57" "6F" "72" "6C" "64") "HelloWorld"]]]
    (let [input-stream (mock-stream stream-bytes)]
      (is (= {:utf8-info {:value result}} (parse-const-type input-stream))))))

(deftest read-class-info-and-uft8-info
  (let [input-stream (mock-stream ["00" "03" "07" "00" "02" "01" "00"
                                   "0A" "48" "65" "6C" "6C" "6F" "57"
                                   "6F" "72" "6C" "64"])]
    (is (= {:constant-pool {:1 {:class-info {:name-index 2}}
                            :2 {:utf8-info {:value "HelloWorld"}}}}
           (constant-pool input-stream)))))

(deftest read-class-uft8-long-double-integer-methodref-info
  (let [input-stream (mock-stream ["00" "09"
                                   "07" "00" "02" "01" "00"
                                   "0A" "48" "65" "6C" "6C" "6F" "57" "6F" "72" "6C" "64"
                                   "05" "00" "00" "00" "00" "40" "C0" "00" "00"
                                   "06" "00" "00" "00" "00" "00" "00" "00" "03"
                                   "03" "00" "01" "E2" "40"
                                   "0A" "00" "01" "00" "03"
                                   ])]
    (is (= {:constant-pool {:1 {:class-info {:name-index 2}}
                            :2 {:utf8-info {:value "HelloWorld"}}
                            :3 {:long-info {:value 1086324736}}
                            :4 {:double-info {:value 3.0}}
                            :5 {:integer-info {:value 123456}}
                            :6 {:methodref-info {:class-index 1 :name-and-type-index 3}}}}
           (constant-pool input-stream)))))







