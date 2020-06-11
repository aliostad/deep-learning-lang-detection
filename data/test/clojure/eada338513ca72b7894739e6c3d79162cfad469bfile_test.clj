(ns crypto.file-test
  (:require
   [crypto.file  :as crypt])
  (:use
   clojure.test)
  (:import
   [java.io ByteArrayInputStream ByteArrayOutputStream]
   [org.apache.commons.io IOUtils]))


(deftest round-robin-encrypt-stream-password
  (let [message               "this is a very secret message"
        password              "supersecretpassword123"
        input-byte-stream     (ByteArrayInputStream. (.getBytes message))
        encrypted-byte-stream (ByteArrayOutputStream.)
        data                  (crypt/encrypt-stream input-byte-stream password)
        decrypted-byte-stream (ByteArrayOutputStream.)]
    ;; First encrypt the data, stream encrypted bytes to output byte array
    (IOUtils/copy (:stream data) encrypted-byte-stream)

    ;; Then decrypt those bytes and assert that the message is correct
    (IOUtils/copy (crypt/get-decryption-stream
                   (ByteArrayInputStream. (.toByteArray encrypted-byte-stream))
                   (:skey data)
                   (:ivec data))
                  decrypted-byte-stream)

    (is (= message (.toString decrypted-byte-stream "UTF-8")))))


(deftest round-robin-encrypt-stream-crytpo-params
  (let [message               "this is a very secret message"
        crypto-params         (crypt/make-encryption-info "supersecretpassword123")
        input-byte-stream     (ByteArrayInputStream. (.getBytes message))
        encrypted-byte-stream (ByteArrayOutputStream.)
        data                  (crypt/encrypt-stream input-byte-stream (:skey crypto-params) (:ivec crypto-params))
        decrypted-byte-stream (ByteArrayOutputStream.)]
    ;; First encrypt the data, stream encrypted bytes to output byte array

    (IOUtils/copy (:stream data) encrypted-byte-stream)

    ;; Then decrypt those bytes and assert that the message is correct
    (IOUtils/copy (crypt/get-decryption-stream
                   (ByteArrayInputStream. (.toByteArray encrypted-byte-stream))
                   (:skey data)
                   (:ivec data))
                  decrypted-byte-stream)

    (is (= message (.toString decrypted-byte-stream "UTF-8")))))

(deftest test-encrypt-stream
  ;; (crypt/encode-b64 (crypt/make-secret-key "banana"))
  ;; "BaZTUTWzTsMe/sjyD5nyjub1KVeCXLXjl/7dcMxQbnM="
  (let [secret-key "BaZTUTWzTsMe/sjyD5nyjub1KVeCXLXjl/7dcMxQbnM="
        cipher     (crypt/make-cipher javax.crypto.Cipher/ENCRYPT_MODE secret-key)
        cleartext   "In computing, plain text is the contents of an ordinary sequential file readable as textual material without much processing, usually opposed to formatted text and to \"binary files \" in which some portions must be interpreted as binary objects (encoded integers, real numbers, images, etc.)."
        crypto-info (crypt/encrypt-stream (java.io.ByteArrayInputStream. (.getBytes cleartext)) secret-key (.getIV cipher))
        ostream   (crypt/get-decryption-stream (:stream crypto-info) (:skey crypto-info) (:ivec crypto-info))
        bytes       (byte-array (* 1024 1024))
        result-text (loop [totread 0]
                      (let [nread (.read ostream bytes totread (- (alength bytes) totread))]
                        (if (< nread 0)
                          (String. bytes 0 totread)
                          (recur (+ totread nread)))))]
    (is (= result-text cleartext))))


(deftest test-decode-b64
  (let [base-bytes-array (let [ba (byte-array 16)]
                           (.nextBytes (java.util.Random.) ba)
                           ba)
        encoded-string   (crypt/encode-b64 base-bytes-array)
        encoded-bytes    (.getBytes encoded-string)
        decoded-bytes    (crypt/decode-b64 encoded-string)]
    ;; string
    (is (= (seq base-bytes-array) (seq decoded-bytes)))

    ;; persistent vector
    (is (= (seq base-bytes-array) (seq (crypt/decode-b64 (vec encoded-bytes)))))

    ;; byte array
    (is (= (seq base-bytes-array) (seq (crypt/decode-b64 encoded-bytes))))))


(comment

  (run-tests)

  )
