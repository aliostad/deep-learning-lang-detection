(ns reader.crypto
  (:use [reader.io])
  (:require [clojure.java.io :as io])
  (:import (java.security KeyStore KeyStore$SecretKeyEntry KeyStore$PasswordProtection)
           (javax.crypto KeyGenerator Cipher CipherOutputStream CipherInputStream)
           (java.io FileOutputStream FileInputStream)))

(defprotocol Filter
  (init-filter [filter])
  (filter-output-stream [filter])
  (filter-input-stream [filter]))

(defn filter-key [filter] 
  (let [passwordCharArray (.toCharArray (.password filter))]
    (with-open [fis (FileInputStream. (.keystore filter))]
      (-> (doto (KeyStore/getInstance "JCEKS")
            (.load fis passwordCharArray))
          (.getKey "filter-key" passwordCharArray)))))

(deftype CryptoFilter [filename keystore password]
  Filter
  (init-filter [filter] 
    (let [passwordCharArray (.toCharArray (.password filter))
          key (.generateKey (KeyGenerator/getInstance "AES"))
          keystoreObj (doto (KeyStore/getInstance "JCEKS")
                            (.load nil passwordCharArray)
                            (.setEntry "filter-key" (KeyStore$SecretKeyEntry. key) (KeyStore$PasswordProtection. passwordCharArray)))]
      (with-open [fos (FileOutputStream. (.keystore filter))]
        (.store keystoreObj fos passwordCharArray))))
  
  (filter-output-stream [filter] (let [cipher (doto (Cipher/getInstance "AES")
                                                    (.init Cipher/ENCRYPT_MODE (filter-key filter)))]
                                   (CipherOutputStream. (io/output-stream (.filename filter)) cipher)))
  
  (filter-input-stream [filter] (let [cipher (doto (Cipher/getInstance "AES")
                                                    (.init Cipher/DECRYPT_MODE (filter-key filter)))]
                                   (CipherInputStream. (io/input-stream (.filename filter)) cipher)))
  
  IOFactory
  (makeReader [filter]
     (makeReader (filter-input-stream filter)))
  (makeWriter [filter]
     (makeWriter (filter-output-stream filter)))
  )

(extend CryptoFilter
  clojure.java.io/IOFactory
  (assoc clojure.java.io/default-streams-impl
     :make-reader (fn [x opts] (makeReader x))
     :make-writer (fn [x opts] (makeWriter x))
     :make-input-stream (fn [x opts] (filter-input-stream x))
     :make-output-stream (fn [x opts] (filter-input-stream x))))
