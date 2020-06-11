; == 6.1 Programming to Abstractions

; -- gulp and expectorate

(ns examples.gulp
    (:import (java.io FileInputStream InputStreamReader BufferedReader)))

(defn gulp [src]
    (let [sb (StringBuilder.)]
        (with-open [reader (-> src
            FileInputStream.
            InputStreamReader.
            BufferedReader.)]
        (loop [c (.read reader)]
            (if (neg? c)
                (str sb)
                (do
                    (.append sb (char c))
                    (recur (.read reader))))))))

(ns examples.expectorate
    (:import (java.io FileOutputStream OutputStreamWriter BufferedWriter)))

(defn expectorate [dst content]
    (with-open [writer (-> dst
        FileOutputStream.
        OutputStreamWriter.
        BufferedWriter.)]
    (.write writer (str content))))

; add support for additional types
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

; closed approach - requires re-writing to add support for new types
(defn make-reader [src]
    (-> (condp = (type src)
        java.io.InputStream src
        Java.lang.Sring (FileInputStream. src)
        java.io.File (FileInputStream. src)
        java.net.Socket (.getInputStream src)
        java.net.URL (if (= "file" (.getProtocol src))
            (-> src .getPath FileInputStream.)
            (.openStream src)))
    InputStreamReader.
    BufferedReader.))

(defn make-writer [dst]
    (-> (condp = (type dst)
        java.io.OutputStream dst
        java.io.File (FileOutputStream. dst)
        java.lang.String (FileOutputStream. dst)
        java.net.Socket (.getOutputStream dst)
        java.net.URL (if (= "file" (.getProtocol dst))
            (-> dst .getPath FileOutputStream.)
            (throw (IllegalArgumentException. "Can't write to non-file URL"))))
    OutputStreamWriter.
    BufferedWriter.))

; == 6.2 Interfaces

(definterface IOFactory
    (^java.io.BufferedReader make-reader [this])
    (^java.io.BufferedWriter make-writer [this]))

; == 6.3 Protocols

(defprotocol IOFactory
    "A protocol for things that can be read from and
    written to."
    (make-reader [this] "Creates a BufferedReader.")
    (make-writer [this] "Creates a BufferedWriter."))

(extend InputStream
    IOFactory
    {:make-reader (fn [src]
        (-> src InputStreamReader. BufferedReader.))
    :make-writer (fn [dst]
        (throw (IllegalArgumentException. "Can't open as InputStream.")))})

(extend OutputStream
    IOFactory
    {:make-reader (fn [src]
        (throw (IllegalArgumentException. "Can't open as an OutputStream.")))
    :make-writer (fn [dst]
        (-> dst OutputStreamWriter. BufferedWriter.))})

; slightly cleaner syntax than extend
(extend-type File
    IOFactory
    (make-reader [src]
        (make-reader (FileInputStream. src)))
    (make-writer [dst]
        (make-writer (FileOutputStream. dst))))

(extend-protocol IOFactory
    Socket
    (make-reader [src]
        (make-reader (.getInputStream src)))
    (make-writer [dst]
        (make-writer (.getOutputStream dst)))
    URL
    (make-reader [src]
        (make-reader
            (if (= "file" (.getProtocol src))
                (-> src .getPath FileInputStream.)
                (.openStream src))))
    (make-writer [dst]
        (make-writer
            (if (= "file" (.getProtocol dst))
                (-> dst .getPath FileInputStream.)
                (throw (IllegalArgumentException.
                    "Can't write to non-file URL"))))))

(ns examples.io
    (:import (java.io File FileInputStream FileOutputStream
        InputStream InputStreamReader
        OutputStream OutputStreamWriter
        BufferedReader BufferedWriter)
    (java.net Socket URL)))

(defprotocol IOFactory
    "A protocol for things that can be read from and written to."
    (make-reader [this] "Creates a BufferedReader.")
    (make-writer [this] "Cretes a BufferedWriter."))

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
    InputStream
    (make-reader [src]
        (-> src InputStreamReader. BufferedReader.))
    (make-writer [dst]
        (throw (IllegalArgumentException.
            "Can't open as an InputStream.")))
    OutputStream
    (make-reader [src]
        (throw (IllegalArgumentException.
            "Can't open as an OutputStream.")))
    (make-writer [dst]
        (-> dst OutputStreamWriter. BufferedWriter.))
    File
    (make-reader [src]
        (make-reader (FileInputStream. src)))
    (make-writer [dst]
        (make-writer (FileOutputStream. dst)))
    Socket
    (make-reader [src]
        (make-reader (.getInputStream src)))
    (make-writer [dst]
        (make-writer (.getOutputStream dst)))
    URL
    (make-reader [src]
        (make-reader
            (if (= "file" (.getProtocol src))
                (-> src .getPath FileInputStream.)
                (.openStream src))))
    (make-writer [dst]
        (make-writer
            (if (= "file" (.getProtocol dst))
                (-> dst .getPath FileInputStream.)
                (throw (IllegalArgumentException.
                    "Can't write to non-file URL"))))))

; == 6.4 Datatypes

(deftype CryptoVault [filename keystore password])

(def vault (->CryptoVault "vault-file" "keystore" "toomanysecrets"))

(.filename vault)

(.keystore vault)

(.password vault)

(defprotocol Vault
    (init-vault [vault])
    (vault-output-stream [vault])
    (vault-input-stream [vault]))

(ns examples.cryptovault
    (:use [examples.io :only [IOFactory make-reader make-writer]])
    (:require [clojure.java.io :as io])
    (:import (java.security KeyStore KeyStore$SecretKeyEntry KeyStore$PasswordProtection)
        (javax.crypto KeyGenerator Cipher CipherOutputStream CipherInputStream)
        (java.io FileOutputStream)))

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
        (let [cipher (doto (CIpher/getInstance "AES")
            (.init CIpher/DECRYPT_MODE (vault-key vault)))]
        (CipherInputStream. (io/input-stream (.filename vault)) cipher)))
    IOFactory
    (make-reader [vault]
        (make-reader (vault-input-stream vault)))
    (make-writer [vault]
        (make-writer (vault-output-stream))))

(defn vault-key [vault]
    (let [password (.toCharArray (.password vault))]
        (with-open [fis (FileInputStream. (.keystore vault))]
            (-> (doto (KeyStore/getInstance "JCEKS")
                (.load fis password))
            (.getKey "vault-key" password)))))

(def vault (->CryptoVault "vault-file" "keystore" "toomanysecrets"))

(init-vault vault)

(expectorate vault "This is a test of the CryptoVault")

(gulp vault)

(extend CryptoVault
    clojure.java.io/IOFactory
    (assoc clojure.java.io/default-streams-impl
        :make-input-stream (fn [x opts] (vault-input-stream x))
        :make-output-stream (fn [x opts] (vault-output-stream x))))

(spit vault "This is a test of the CryptoVault using spit and slurp")

(slurp vault)

; == 6.5 Records

(defrecord Note [pitch octave duration])

(->Note :D# 4 1/2)

(.pitch (->Note :D# 4 1/2))

(map? (->Note :D# 4 1/2))

(:pitch (->Note :D# 4 1/2))

(assoc (->Note :D# 4 1/2) :pitch :Db :duration 1/4)

(update-in (->Note :D# 4 1/2) [:octave] inc)

(assoc (->Note :D# 4 1/2) :velocity 100)

(dissoc (->Note :D# 4 1/2) :octave)

((->Note :D# 4 1/2) :pitch)

(defprotocol MidiNote
    (to-msec [this tempo])
    (key-number [this])
    (play [this tempo midi-channel]))

(import 'javax.sound.midi.MidiSystem)

(extend-type Note
    MidiNote
    (to-msec [this tempo]
        (let [duration-to-bpm {1 240, 1/2 120, 1/4 60, 1/8 30, 1/16 15}]
            (* 1000 (/ (duration-to-bpm (:duration this))
                tempo))))
    (key-number [this]
        (let [scale {:C 0, :C# 1, :Db 1, :D 2,
            :D# 3, :Eb 3, :E 4, :F 5,
            :F# 6, :Gb 6, :G 7, :G# 8,
            :Ab 8, :A 9, :A# 10, :Bb 10,
            :B 11}]
            (+ (* 12 (inc (:octave this)))
                (scale (:pitch this)))))
    (play [this tempo midi-channel]
        (let [velocity (or (:velocity this) 64)]
            (.noteOn midi-channel (key-number this) velocity)
            (Thread/sleep (to-msec this tempo)))))

(defn perform [notes & {:keys [tempo] :or {tempo 120}}]
    (with-open [synth (doto (MidiSystem/getSynthesizer) .open)]
        (let [channel (aget (.getChannels synth) 0)]
            (doseq [note notes]
                (play note tempo channel)))))

(def close-encounters [
    (->Note :D 3 1/2)
    (->Note :E 3 1/2)
    (->Note :C 3 1/2)
    (->Note :C 2 1/2)
    (->Note :G 2 1/2)])

(perform close-encounters)

(def jaws (for [duration [1/2 1/2 1/4 1/4 1/8 1/8 1/8 1/8]
    pitch [:E :F]]
    (Note. pitch 2 duration)))

(perform jaws)

(perform (map #(update-in % [:octave] inc) close-encounters))

(perform (map #(update-in % [:octave] dec) close-encounters))

(perform (for [velocity [64 80 90 100 110 120]]
    (assoc (Note. :D 3 1/2) :velocity velocity)))

; == 6.6 reify

; reify creates an anonymous instance of a datatype that implements
; either a protocol or an interface.  you get access by closure, not
; by declaration.

(import '[examples.datatypes.midi MidiNote])

(let [min-duration 250
    min-velocity 64
    rand-note (reify
        MidiNote
        (to-msec [this tempo] (+ (rand-int 1000) min-duration))
        (key-number [this] (rand-int 100))
        (play [this tempo midi-channel]
            (let [velocity (+ (rand-int 100) min-velocity)]
                (.noteOn midi-channel (key-number this) velocity)
                (Thread/sleep (to-msec this tempo)))))]
    (perform (repeat 15 rand-note)))
