(ns learn.cryptovault
  (:use [learn.io :only [IOFactory make-reader make-writer expectorate gulp]])
  (:require [clojure.java.io :as io])
  (:import (java.security KeyStore KeyStore$SecretKeyEntry
                          KeyStore$PasswordProtection)
           (javax.crypto KeyGenerator Cipher CipherOutputStream
                         CipherInputStream)
           (java.io FileOutputStream FileInputStream)))

(defprotocol Vault
  (init-vault [vault])
  (vault-input-stream [vault])
  (vault-output-stream [vault])
  )

(defn vault-key [vault]
  (let [password (.toCharArray (.password vault))]
    (with-open [fis (FileInputStream. (.keystore vault))]
      (-> (doto (KeyStore/getInstance "JCEKS")
            (.load fis password))
          (.getKey "vault-key" password)))))

(deftype CryptoVault [filename keystore password]
  Vault
  (init-vault
   [vault]
   (let [password (.toCharArray (.password vault))
         key (.generateKey (KeyGenerator/getInstance "AES"))
         keystore (doto (KeyStore/getInstance "JCEKS")
                    (.load nil password)
                    (.setEntry "vault-key"
                               (KeyStore$SecretKeyEntry. key)
                               (KeyStore$PasswordProtection. password)))]
     (with-open [fos (FileOutputStream. (.keystore vault))]
       (.store keystore fos password))))
  (vault-input-stream
   [vault]
   (let [cipher (doto (Cipher/getInstance "AES")
                  (.init Cipher/DECRYPT_MODE (vault-key vault)))]
     (CipherInputStream. (io/input-stream (.filename vault)) cipher)))
  (vault-output-stream
   [vault]
   (let [cipher (doto (Cipher/getInstance "AES")
                  (.init Cipher/ENCRYPT_MODE (vault-key vault)))]
     (CipherOutputStream. (io/output-stream (.filename vault)) cipher)))

  IOFactory
  (make-reader [vault]
               (make-reader (vault-input-stream vault)))
  (make-writer [vault]
               (make-writer (vault-output-stream vault))))

(def vault (->CryptoVault "vault-file" "keystore" "toomanysecrets"))

(extend CryptoVault
  clojure.java.io/IOFactory
  (assoc clojure.java.io/default-streams-impl
    :make-input-stream (fn [x opts] (vault-input-stream x))
    :make-output-stream (fn [x opts] (vault-output-stream x))))

(init-vault vault)

(spit vault "This is a test of the CryptoVault using spit and slurp")
(slurp vault)
