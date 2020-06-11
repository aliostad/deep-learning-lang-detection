(ns ^{:doc "

Manage input to the mosaic pipeline.

"
      :author "andrew@acooke.org"}
  cl.parti.input
  (:use (cl.parti utils random))
  (:use clojure.math.numeric-tower)
  (:use clojure.java.io)
  (:import java.security.MessageDigest)
  (:import java.io.BufferedReader))

;; ## Hash functions
;;
;; These are used by the input routines (defined below) to generate
;; cryptographic hashes of the available data.  The hash algorithm used
;; is selected by the `hash` argument.  All routines return an array
;; of bytes.

(defn word-hash
  "Hash the given string directly."
  [hash]
  (fn [text]
    (let [hash (. MessageDigest getInstance hash)]
      (random-bits (.digest hash (.getBytes text))))))

(defn stream-hash
  "Hash the entire contents of the stream."
  [hash]
  (fn [stream]
    (let [hash (. MessageDigest getInstance hash)
          buffer-size 65535
          buffer (byte-array buffer-size)]
      (defn copy-stream []
        (let [n (.read stream buffer 0 buffer-size)]
          (if (not= n -1)
            (do (.update hash buffer 0 n) (recur))
            (do (.close stream) hash))))
      (random-bits (.digest (copy-stream))))))

(defn hex-hash
  "*Not* a hash function, strictly.  This is used when the input is itself
  a hash value (calculated externally).  The text is assumed to be a
  hexadecimal value and is converted to the equivalent array of bytes."
  [hash]
  (fn [hex]
    (try
      (parse-hex hex)
      (catch Exception e
        (error hex " is invalid hex: " (.getMessage e))))))

;; ## Reader functions
;;
;; These extract and format the input from command line arguments or stdin
;; then evaluate the appropriate hash (provided by the functions defined
;; above).

(defn file-reader
  "Treat each command line argument as a different filename.  The contents of
  each file are hashed in turn."
  [hash args]
  (for [path args]
    (with-open [stream (input-stream path)]
      [(hash stream) path])))

(defn literal-reader
  "Treat each command line argument as a different string that should be
  hashed."
  [hash args]
  (map (fn [arg] [(hash arg) arg]) args))

(defn literal2-reader
  [hash args]
  (map (fn [[arg1 arg2]] [(hash arg1) arg2]) (partition 2 args)))

(defn line-reader
  "Read each line from stdin as a separate value to be hashed."
  [hash _]
  (let [lines (line-seq (java.io.BufferedReader. *in*))]
    (map (fn [line] [(hash line) line]) lines)))

(defn line2-reader
  [hash _]
  (let [lines (line-seq (java.io.BufferedReader. *in*))]
    (map (fn [[line1 line2]] [(hash line1) line2]) (partition 2 lines))))

(defn stdin-reader
  "Read the entire contents of stdin as a single value to be hashed."
  [hash _]
  (error "stdin not implemented"))

(defn with-counter
  [reader]
  (let [counter (atom 0)]
    (fn [hash args]
      (for [[state arg] (reader hash args)]
        (let [n @counter]
          (swap! counter inc)
          [state n arg])))))
