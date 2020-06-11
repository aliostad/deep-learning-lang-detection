(ns sandbox.protocol
  (:require [clojure.java.io :as io])
  (:import (java.io InputStream OutputStream File
                    FileInputStream InputStreamReader BufferedReader
                    FileOutputStream OutputStreamWriter BufferedWriter)
           (java.net Socket URL )
           (java.security KeyStore KeyStore$SecretKeyEntry
                          KeyStore$PasswordProtection)
           (javax.crypto KeyGenerator Cipher CipherOutputStream
                         CipherInputStream)))

(defprotocol IOFactory
  "A protocol for things that can be read from and written to."
  (make-reader [this] "Creates a BufferedReader")
  (make-writer [this] "Creates a BufferedWriter"))


(defn gulp [src]
  (let [sb (StringBuilder.)]
    (with-open [reader (make-reader src)]
      (loop [c (.read reader)]
        (if (neg? c)
          (str sb)
          (do
            (.append sb (char c))
            (recur (.read reader))))))))

(defn expectorate [dst content]
  (with-open [writer (make-writer dst)]
    (.write writer (str content))))


(extend-protocol IOFactory
  File
  (make-reader [src]
    (make-reader (FileInputStream. src)))
  (make-writer [dst]
    (make-writer (FileOutputStream. dst)))
  Socket
  (make-reader [src] (.getInputStream src))
  (make-writer [dst] (.getOutputStream dst))
  URL
  (make-reader [src]
    (if (= "file" (.getProtocol src))
      (-> src .getPath FileInputStream.)
      (.openStream src)))
  (make-writer [dst]
    (if (= "file" (.getProtocol dst))
      (-> dst .getPath FileInputStream.)
      (throw (IllegalArgumentException.
              "Can't write to non-file URL")))))

(extend InputStream
  IOFactory
  {:make-reader (fn [src]
                  (-> src InputStreamReader. BufferedReader.))
   :make-writer (fn [dst]
                  (throw (IllegalArgumentException.
                          "Can't open as an InputStream")))})

(extend OutputStream
  IOFactory
  {:make-reader (fn [src] (throw (IllegalArgumentException.
                                  "Can't open as an OutputStream.")))
   :make-writer (fn [dst]
                  (-> dst OutputStreamWriter. BufferedWriter.))})


(defprotocol Vault
  (init-vault [vault])
  (vault-output-stream [vault])
  (vault-input-stream [vault]))

(defn vault-key [vault]
  (let [password (.toCharArray (.password vault))]
    (with-open [fis (FileInputStream. (.keystore vault))]
      (-> (doto (KeyStore/getInstance "JCEKS")
            (.load fis password))
          (.getKey "vault-key" password)))))

(deftype CryptoVault [filename keystore password]
  Vault
  (init-vault [vault]
    (let [password (.toCharArray (.password vault))
          key (.generateKey (KeyGenerator/getInstance "AES"))
          keystore (doto (KeyStore/getInstance "JCEKS")
                     (.load nil password)
                     (.setEntry "vault-key"
                                (KeyStore$SecretKeyEntry. key)
                                (KeyStore$PasswordProtection. password)))]
      (with-open [fos (FileOutputStream. (.keystore vault))]
        (.store keystore fos password))))

  (vault-output-stream [vault]
    (let [cipher (doto (Cipher/getInstance "AES")
                   (.init Cipher/ENCRYPT_MODE (vault-key vault)))]
      (CipherOutputStream. (io/output-stream (.filename vault)) cipher)))

  (vault-input-stream [vault]
    (let [cipher (doto (Cipher/getInstance "AES")
                   (.init Cipher/DECRYPT_MODE (vault-key vault)))]
      (CipherInputStream. (io/input-stream (.filename vault)) cipher)))

  IOFactory
  (make-reader [vault] (make-reader (vault-input-stream vault)))

  (make-writer [vault] (make-writer (vault-output-stream vault))))


(extend CryptoVault
  clojure.java.io/IOFactory
  (assoc clojure.java.io/default-streams-impl
         :make-input-stream (fn [x opts] (vault-input-stream x))
         :make-output-stream (fn [x opts] (vault-output-stream x))))

(def vault (->CryptoVault "vault-file" "keystore" "toomanysecrets"))

(init-vault vault)

(expectorate vault "This is a test of the CryptoVault")

(gulp vault)

(spit vault "This is a test of the CryptoVault using spit and slurp")

(slurp vault)













