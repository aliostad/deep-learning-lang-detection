(ns nsp.aes
  (:import (javax.crypto Cipher)
           (javax.crypto.spec IvParameterSpec SecretKeySpec)))

;; aes-key 16 或 32 位的 byte-array，关于 32 位 key 的问题请参考
;; http://stackoverflow.com/questions/6481627/java-security-illegal-key-size-or-default-parameters
;; iv 为 16 位的 byte-array
(defn new-ctr-stream [aes-key iv]
  (let [c (Cipher/getInstance "AES/CTR/NoPadding")]
    (.init c Cipher/ENCRYPT_MODE (SecretKeySpec. aes-key "AES") (IvParameterSpec. iv))
    c))

(defn stream-encrypt-ctr [data ctr-stream]
  (.update ctr-stream data))

(defn stream-decrypt-ctr [data ctr-stream]
  (stream-encrypt-ctr data ctr-stream))
