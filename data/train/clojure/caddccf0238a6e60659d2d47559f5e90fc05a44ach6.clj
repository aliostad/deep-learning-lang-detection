(ns programming-clojure.ch6
  (:import (java.io FileInputStream InputStreamReader BufferedReader FileOutputStream OutputStreamWriter BufferedWriter InputStream File OutputStream)
           (java.net Socket URL)
           (java.security KeyStore KeyStore$SecretKeyEntry
                          KeyStore$PasswordProtection)
           (javax.crypto KeyGenerator Cipher CipherOutputStream)
           (java.io FileOutputStream))
  (:require [clojure.java.io :as io]))

(defn make-reader [src]
  (-> src FileInputStream. InputStreamReader. BufferedReader.))

(defn make-writer [dst]
  (-> dst FileOutputStream. OutputStreamWriter. BufferedWriter.))

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


(defn make-reader [src]
  (-> (condp = (type src)
        InputStream src
        String (FileInputStream. src)
        File (FileInputStream. src)
        Socket (.getInputStream src)
        URL (if (= "file" (.getProtocol src))
              (-> src .getPath FileInputStream.)
              (.openStream src)))
      InputStreamReader.
      BufferedReader.))


(defn make-writer [dst]
  (-> (condp = (type dst)
        OutputStream dst
        File (FileOutputStream. dst)
        Socket (.getOutputStream dst)
        URL (if (= "file" (.getProtocol dst))
              (-> dst .getPath FileOutputStream.)
              (throw (IllegalArgumentException.
                       "Can't write to non-file URL"))))
      OutputStreamWriter. BufferedWriter.))

(defprotocol IOFactory
  (make-reader [this] "Creates a BufferedReader.")
  (make-writer [this] "Creates a BufferedWriter."))

(extend InputStream IOFactory
  {:make-reader (fn [src] (-> src InputStreamReader. BufferedReader.))
   :make-writer (fn [dst] (throw (IllegalArgumentException. "Can't open as InputStream.")))})


(extend OutputStream
  IOFactory
  {:make-reader (fn [src]
                  (throw
                    (IllegalArgumentException.
                      "Can't open as an OutputStream.")))
   :make-writer (fn [dst]
                  (-> dst OutputStreamWriter. BufferedWriter.))})


(extend-type File IOFactory
  (make-reader [src] (make-reader (FileInputStream. src)))
  (make-writer [dst] (make-writer (FileOutputStream. dst))))


(extend-protocol IOFactory
  Socket
  (make-reader [src] (make-reader (.getInputStream src)))
  (make-writer [dst] (make-writer (.getOutputStream dst)))
  URL
  (make-reader [src] (make-reader (if (.getProtocol src)
                                    (-> src .getInputStream FileInputStream.)
                                    (.openStream src))))
  (make-writer [dst] (make-writer (if (.getProtocol dst)
                                    (-> dst .getOutputStream FileOutputStream.)
                                    (throw (IllegalArgumentException. "Can't write to non-file URL"))))))


(deftype CryptoVault [filename keystore password])

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
  (init-vault [vault] (let [password (.toCharArray (.password vault))
                            key (.generateKey (KeyGenerator/getInstance "AES"))
                            keystore (doto (KeyStore/getInstance "JCEKS")
                                       (.load nil password)
                                       (.setEntry "vault-key"
                                                  (KeyStore$SecretKeyEntry. key)
                                                  (KeyStore$PasswordProtection. password)))]
                        (with-open [fos (FileOutputStream. (.keystore vault))]
                          (.store keystore fos password))
                        ))
  (vault-output-stream [vault]
    (let [cipher (doto (Cipher/getInstance "AES")
                   (.init Cipher/ENCRYPT_MODE (vault-key vault)))]
      (CipherOutputStream. (io/output-stream (.filename vault)) cipher)))
  (vault-input-stream [vault] (println "Input " vault))
  IOFactory
  (make-reader [vault] (make-reader (vault-input-stream vault)))
  (make-writer [vault] (make-writer (vault-output-stream vault))))


(and 1 2 3)















