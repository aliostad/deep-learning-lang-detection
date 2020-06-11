;;; Import the Java libs necessary for byte seq'ing
(ns pianist.core
  (:import
    (java.io FileOutputStream FileInputStream FileReader File)
    (java.nio Buffer ByteBuffer CharBuffer)))

;; Define the record structure
(defrecord DataTest [numbytes predicate])

;; Make some datatests
(def magic
  (DataTest. 5, #(= % '(82 69 68 73 83))))
(def dumpversion
  (DataTest. 4, #(= % '(48 48 48 50))))
(def selectdb
  (DataTest. 1, #(= % '(254))))

;; Function to hold structure of records, probably not idiomatic
(defn parsemap []
  [magic dumpversion selectdb])

;; Inside a with-open, assembles a byte-array,
;; reads from a stream, and returns a seq
(defn grab-bytes [stream bytes]
  (let [ary (byte-array bytes)]
    (.read stream ary)
      (seq ary)))

;; Does the magic number and dump version number match
;; the map?
(defn is-redis-file? [stream dataseq]
  (= [true true]
    (into []
      (map
        #(let [sbytes (:numbytes %) predicate (:predicate %)]
          (predicate
            (grab-bytes stream sbytes))) dataseq))))

;; Parse the body of the data file
(defn parse-body [stream dataseq]
  (let [ary (byte-array (.available stream))]
    (.read stream ary)
      (seq ary)))

;; The main interface function
(defn parse-rdb-file [path dataseq]
  (with-open [#^FileInputStream stream (FileInputStream. path)]
    (cond
      (is-redis-file? stream dataseq) (parse-body stream dataseq)
      :else "Not a valid Redis .rdb file")))

;; Get the first unsigned byte out of the int
(defn ubyte [longlong]
  (bit-and 0xFF (short longlong)))
