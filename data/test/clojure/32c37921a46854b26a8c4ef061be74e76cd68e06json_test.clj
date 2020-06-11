(ns clj-bson-rpc.json-test
  (:require
    [clj-bson-rpc.bytes :refer :all]
    [clj-bson-rpc.json :refer :all]
    [clojure.data.json :as json]
    [clojure.test :refer :all]
    [manifold.stream :as stream]))

(defn- create-duplex-stream
  []
  (let [a (stream/stream)
        b (stream/stream)]
    [(stream/splice a b) (stream/splice b a)]))

(defn- ->json-bytes
  [m]
  (.getBytes (json/write-str m) "UTF-8"))

(defn- ->json-framed
  [m]
  (byte-array (concat [0x1e] (->json-bytes m) [0x0a])))

(deftest decode-json
  (let [[a b] (create-duplex-stream)
        original {:a "aphrodite" :b "barbara" :c "cecilia"}
        json-stream (json-codec b)]
    (is @(stream/put! a (->json-bytes original)))
    (stream/close! a)
    (is (= @(stream/take! json-stream) original))))

(deftest decode-json-rfc-7464
  (let [[a b] (create-duplex-stream)
        original {:a "aphrodite" :b "barbara" :c "cecilia"}
        json-stream (json-codec b :json-framing :rfc-7464)]
    (is @(stream/put! a (->json-framed original)))
    (is (= @(stream/take! json-stream) original))
    (stream/close! a)))

(deftest decode-multiple-jsons
  (let [[a b] (create-duplex-stream)
        original1 {:a "aphrodite" :b "barbara" :c "cecilia"}
        original2 {:pertama 123 :kedua "Apa kabar Abu Bakar!"}
        b-msg (bbuf-concat (->json-bytes original1) (->json-bytes original2))
        [b-part1 b-rest] (bbuf-split-at 14 b-msg)
        [b-part2 b-part3] (bbuf-split-at (- (count b-rest) 10) b-rest)
        json-stream (json-codec b)]
    ;; Writing both at once:
    (is @(stream/put! a b-msg))
    (is (= @(stream/take! json-stream) original1))
    (is (= @(stream/take! json-stream) original2))
    ;; Arbitrary parts:
    (is @(stream/put! a b-part1))
    (is @(stream/put! a b-part2))
    (is (= @(stream/take! json-stream) original1))
    (is @(stream/put! a b-part3))
    (stream/close! a)
    (is (= @(stream/take! json-stream) original2))))

(deftest decode-multiple-jsons-rfc-7464
  (let [[a b] (create-duplex-stream)
        original1 {:a "aphrodite" :b "barbara" :c "cecilia"}
        original2 {:pertama 123 :kedua "Apa kabar Abu Bakar!"}
        b-msg (bbuf-concat (->json-framed original1) (->json-framed original2))
        [b-part1 b-rest] (bbuf-split-at 14 b-msg)
        [b-part2 b-part3] (bbuf-split-at (- (count b-rest) 10) b-rest)
        json-stream (json-codec b :json-framing :rfc-7464)]
    ;; Writing both at once:
    (is @(stream/put! a b-msg))
    (is (= @(stream/take! json-stream) original1))
    (is (= @(stream/take! json-stream) original2))
    ;; Arbitrary parts:
    (is @(stream/put! a b-part1))
    (is @(stream/put! a b-part2))
    (is (= @(stream/take! json-stream) original1))
    (is @(stream/put! a b-part3))
    (stream/close! a)
    (is (= @(stream/take! json-stream) original2))))

(deftest decode-over-1MiB-message
  (let [[a b] (create-duplex-stream)
        ipsum (slurp "test/data/ipsum.txt")
        original {:pertama ipsum :kedua ipsum :ketiga ipsum
                  :again [ipsum ipsum ipsum ipsum ipsum]}
        json-stream (json-codec b)]
    (is @(stream/put! a (->json-bytes original)))
    (stream/close! a)
    (is (= @(stream/take! json-stream) original))))

(deftest decode-over-1MiB-message-rfc-7464
  (let [[a b] (create-duplex-stream)
        ipsum (slurp "test/data/ipsum.txt")
        original {:pertama ipsum :kedua ipsum :ketiga ipsum
                  :again [ipsum ipsum ipsum ipsum ipsum]}
        json-stream (json-codec b :json-framing :rfc-7464)]
    (is @(stream/put! a (->json-framed original)))
    (stream/close! a)
    (is (= @(stream/take! json-stream) original))))

(defn- bytes->hex
  [b]
  (apply str (mapv #(format "%02x" %) b)))

(deftest encode-json
  (let [[a b] (create-duplex-stream)
        original {:a "aphrodite" :b "barbara" :c "cecilia"}
        json-stream (json-codec b)]
    (is @(stream/put! json-stream original))
    (is (= (bytes->hex @(stream/take! a)) (bytes->hex (->json-bytes original))))))

(deftest encode-json-rfc-7464
  (let [[a b] (create-duplex-stream)
        original {:a "aphrodite" :b "barbara" :c "cecilia"}
        json-stream (json-codec b :json-framing :rfc-7464)]
    (is @(stream/put! json-stream original))
    (is (= (bytes->hex @(stream/take! a)) (bytes->hex (->json-framed original))))))

(deftest decoder-dirty-close
  (let [[a b] (create-duplex-stream)
        original {:a "aphrodite" :b "barbara" :c "cecilia"}
        full-raw (->json-bytes original)
        double-raw (bbuf-concat full-raw full-raw)
        [broken _t] (bbuf-split-at (- (count double-raw) 10) double-raw)
        json-stream (json-codec b :json-framing :none)]
    (is @(stream/put! a broken))
    (stream/close! a)
    (is (= @(stream/take! json-stream) original))
    (let [error @(stream/take! json-stream)]
      (is (instance? clojure.lang.ExceptionInfo error))
      (is (= (:type (ex-data error)) :trailing-garbage)))))

(deftest decoder-dirty-close-rfc-7464
  (let [[a b] (create-duplex-stream)
        original {:a "aphrodite" :b "barbara" :c "cecilia"}
        full-raw (->json-framed original)
        double-raw (bbuf-concat full-raw full-raw)
        [broken _t] (bbuf-split-at (- (count double-raw) 10) double-raw)
        json-stream (json-codec b :json-framing :rfc-7464)]
    (is @(stream/put! a broken))
    (stream/close! a)
    (is (= @(stream/take! json-stream) original))
    (let [error @(stream/take! json-stream)]
      (is (instance? clojure.lang.ExceptionInfo error))
      (is (= (:type (ex-data error)) :trailing-garbage)))))

(deftest decode-garbage
  (let [[a b] (create-duplex-stream)
        garbage (byte-array [0x7b 0x31 0x32 0x33 0x20 0x22 0x66
                             0x6f 0x6f 0x62 0x61 0x72 0x22 0x7d])
        ok-bytes (->json-bytes {:a "bom" :b "dia"})
        json-stream (json-codec b)]
    (is @(stream/put! a (bbuf-concat ok-bytes (bbuf-concat garbage ok-bytes))))
    (is (= @(stream/take! json-stream) {:b "dia" :a "bom"}))
    (let [error @(stream/take! json-stream)]
      (is (instance? clojure.lang.ExceptionInfo error))
      (is (= (:type (ex-data error)) :invalid-json)))
    (stream/close! a)))

(deftest decode-garbage-rfc-7464
  (let [[a b] (create-duplex-stream)
        garbage (byte-array [0x1e
                             0x7b 0x31 0x32 0x33 0x20 0x22 0x66
                             0x6f 0x6f 0x62 0x61 0x72 0x22 0x7d
                             0x0a])
        ok-bytes (->json-framed {:a "bom" :b "dia"})
        json-stream (json-codec b :json-framing :rfc-7464)]
    (is @(stream/put! a (bbuf-concat ok-bytes (bbuf-concat garbage ok-bytes))))
    (is (= @(stream/take! json-stream) {:b "dia" :a "bom"}))
    (let [error @(stream/take! json-stream)]
      (is (instance? clojure.lang.ExceptionInfo error))
      (is (= (:type (ex-data error)) :invalid-json)))
    (stream/close! a)))

(deftest decode-invalid-frame-and-recovery-rfc-7464
  (let [[a b] (create-duplex-stream)
        original1 {:a "aphrodite" :b "barbara" :c "cecilia"}
        original2 {:pertama 123 :kedua "Apa kabar Abu Bakar!"}
        b-msg1 (->json-framed original1)
        b-msg2 (->json-framed original2)
        broken (byte-array (concat (->json-bytes {:test "message" :xyz 123}) [0x0a]))
        content (byte-array (concat b-msg1 broken b-msg2))
        json-stream (json-codec b :json-framing :rfc-7464)]
    (is @(stream/put! a content))
    (is (= @(stream/take! json-stream) original1))
    (let [error @(stream/take! json-stream)]
      (is (instance? clojure.lang.ExceptionInfo error))
      (is (= (:type (ex-data error)) :invalid-framing)))
    (is (= @(stream/take! json-stream) original2))))
