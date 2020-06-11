(ns clojure-dojo.core
  (:require [clojure.java.io :as io]
            [clj-mmap :as mmap]
            [clojurewerkz.buffy.core :refer :all]
            [clojurewerkz.buffy.frames :refer :all]
            )
  (:import [java.nio ByteBuffer]))

(defn xl [n] (if (= n 1) \x \-))

(defn stringify-track
  "take a track and make a string with bars, x, dash"
  [bytes]
  (str \| (apply str (flatten (interpose \| (partition 4 bytes))))\|))

(def instrument-string
  (frame-type
    (frame-encoder [value]
                   length (short-type) (count value)
                   string (string-type (count value)) value)
    (frame-decoder [buffer offset]
                   length (short-type)
                   string (string-type (read length buffer offset)))
    second ;; Value Formatter
    ))

(def notes-pattern
  (spec :notes (bit-type 4)))

(def track-frame
  (composite-frame
    (spec :instrument (int32-type)
    instrument-string
    (spec :notes (bit-type 4)
               ))))


(def track-pattern
  (spec :instrument (int32-type)
        :name-len (byte-type)
        ;;:name (string-type )
        ))

(def drum-pattern
  (composite-frame
    (spec :tag (string-type 6)
          :empty (bytes-type 6)
          :size-b (short-type)
          :hw-version (string-type 32)
          :tempo (float-type))
    track-pattern))

(defn load-drum-pattern
  "load a drum pattern."
  [filename]
  (let [f (io/file (io/resource filename))]
    (with-open [in (io/input-stream f)]
      (let [buf (byte-array (.length f))
            n (.read in buf)
            buffer (dynamic-buffer drum-pattern :orig-buffer buf)
            result (str filename "\n")]
        (println "Read" n "bytes from" filename)
        ;;(println "Type of buffer is" (type buffer))
        (println "Tag is" (get-field buffer :tag))
        (println "Remaining size" (get-field buffer :size-b))
        (println "HW version is" (get-field buffer :hw-version))
        (println "Tempo is" (get-field buffer :tempo))
        (if (not= "SPLICE" (get-field buffer :tag))
          (throw (Exception. "Not a valid splice pattern file.")))
        (str result)
        ))))

(defn load-drum-pattern-mmap
  "Load a binary drum pattern from mmaped resources."
  [filename]
  (println "Opening " filename)
  (with-open [f (mmap/get-mmap (.getPath (io/resource filename)))]
    (let [size (.size f)
          bytes (mmap/get-bytes f 0 size)
          ]
      (println (type Thread))
      (println "Mapped a file containing" size "bytes." (type bytes))
      ;;(prn (hex-dump bytes))
      )))