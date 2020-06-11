(ns clj-bson-rpc.bson-test
  (:require
    [clojure.test :refer :all]
    [clj-bson-rpc.bson :refer :all]
    [clj-bson-rpc.bytes :refer :all]
    [manifold.stream :as stream]))

(defn- bytes->hex
  [b]
  (apply str (mapv #(format "%02x" %) b)))

(defn- hex->bytes
  [h]
  (byte-array
    (mapv
      (fn [[x y]] (unchecked-byte (Integer/parseInt (str x y) 16)))
      (partition 2 h))))

(defn- slurp-bytes
  [filename]
  (with-open [out (java.io.ByteArrayOutputStream.)]
    (-> (clojure.java.io/input-stream filename)
        (clojure.java.io/copy out))
    (.toByteArray out)))

(defn- create-duplex-stream
  []
  (let [a (stream/stream)
        b (stream/stream)]
    [(stream/splice a b) (stream/splice b a)]))

(deftest simple-encoding
  (let [data {:a "foo" :b "bar"}
        expected (str "1b000000"  ; 27 bytes
                      "02""6100""04000000""666f6f00" ; type-str key=a len=4 foo\0
                      "02""6200""04000000""62617200" ; type-str key=b len=4 bar\0
                      "00")] ; 0
    (is (= (bytes->hex (encode data)) expected))))

(deftest simple-decoding
  (let [data (str "29000000" ; 41 bytes
                  "12""6100""0100000000000000" ; type-int64 key=a 1
                  "02""6200""07000000""7365636f6e6400"
                  "12""6300""0300000000000000"
                  "00")
        expected {:a 1 :b "second" :c 3}]
    (is (= (decode (hex->bytes data)) expected))))

(deftest roundtrip
  (let [data {:some 1 :items ["first" "second"] :nested {:foo "bar"}}]
    (is (= (decode (encode data)) data))))

(deftest unicode-keys
  (let [data {:some 1 :päivää {:even "more" :อรุณสวัสดิ์ "challenging"}}]
    (is (= (decode (encode data)) data))))

(deftest encoding-tiny-binary
  (let [data {:test "some"
              :int 988
              :content (hex->bytes "000503abba")}
        expected (str "34000000"
                      "02""7465737400""05000000""736f6d6500"
                      "12""696e7400""dc03000000000000"
                      "05""636f6e74656e7400""05000000""00""000503abba"
                      "00")]
    (is (= (bytes->hex (encode data)) expected))))

(deftest binary-content
  (let [binary-data (slurp-bytes "test/data/penguin.png")
        data {:filename "penguin.png"
              :filesize 27466
              :content binary-data}
        encoded (encode data)
        head73 (str "896b0000"
                    "02""66696c656e616d6500""0c000000""70656e6775696e2e706e6700"
                    "12""66696c6573697a6500""4a6b000000000000"
                    "05""636f6e74656e7400""4a6b0000""00"
                        "89504e470d0a1a0a000000") ; etc
        decoded (decode encoded)]
    (is (= (bytes->hex (take 73 encoded)) head73))
    (is (= (:filename decoded) (:filename data)))
    (is (= (:filesize decoded) (:filesize data)))
    ; (= data decoded) does not work as expected because
    ;  byte array equality only compares objects themselves and not the
    ;  equality of the content bytes. Comparing the hexified contents however
    ;  proves content equality.
    (is (= (bytes->hex (:content decoded)) (bytes->hex (:content data))))))

(deftest bson-codec-decoding-simple
  (let [[a b] (create-duplex-stream)
        original {:a "foo" :b "bar" :c "barbara"}
        bson-stream (bson-codec b)]
    (is @(stream/put! a (encode original)))
    (is (= @(stream/take! bson-stream) original))))

(deftest bson-codec-decoding-dirty-close
  (let [[a b] (create-duplex-stream)
        original {:a "foo" :b "bar" :c "barbara"}
        full-raw (encode original)
        double-raw (bbuf-concat full-raw full-raw)
        [broken tail] (bbuf-split-at (- (count double-raw) 10) double-raw)
        bson-stream (bson-codec b)]
    (is @(stream/put! a broken))
    (stream/close! a)
    (is (= @(stream/take! bson-stream) original))
    (let [error @(stream/take! bson-stream)]
      (is (instance? clojure.lang.ExceptionInfo error))
      (is (= (:type (ex-data error)) :trailing-garbage)))
    (is (nil? @(stream/take! bson-stream)))))

(deftest bson-codec-decoding-garbage
  (let [[a b] (create-duplex-stream)
        garbage (byte-array [0x0c 0x00 0x00 0x00   ; len 12 bytes
                             0xb5 0xae 0xbc 0x67
                             0x22 0xa2 0x06 0x00])
        ok-bytes (encode {:a "bom" :b "dia"})
        bson-stream (bson-codec b)]
    (is @(stream/put! a (bbuf-concat garbage ok-bytes)))
    ;(stream/close! a)
    (let [error @(stream/take! bson-stream)]
      (is (instance? clojure.lang.ExceptionInfo error))
      (is (= (:type (ex-data error)) :invalid-bson)))
    (stream/close! a)
    (is (= @(stream/take! bson-stream) {:b "dia" :a "bom"}))
    (is (nil? @(stream/take! bson-stream)))))

(deftest bson-codec-decoding-framing-error
  (let [[a b] (create-duplex-stream)
        garbage (byte-array [0xdf 0xff 0xff 0xff   ; len -3 bytes
                             0x02 0x02 0x02 0x02])
        bson-stream (bson-codec b)]
    (is @(stream/put! a garbage))
    (let [error @(stream/take! bson-stream)]
      (is (instance? clojure.lang.ExceptionInfo error))
      (is (= (:type (ex-data error))) :invalid-framing)
      )
    ))

(deftest bson-codec-encoding-simple
  (let [[a b] (create-duplex-stream)
        original {:a "foo" :b "bar" :c "barbara"}
        bson-stream (bson-codec b)]
    (is @(stream/put! bson-stream original))
    (is (= (bytes->hex @(stream/take! a)) (bytes->hex (encode original))))))
