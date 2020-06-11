;; ref https://gist.github.com/bpsm/1858654
(ns clj-utils.gunzip
  (:require [clojure.java.io :as io])
  (:require [clojure.string :as str])
  (:import java.util.zip.GZIPInputStream
           java.util.zip.GZIPOutputStream))

(defn gunzip
  "Writes the contents of input to output, decompressed.

  input: something which can be opened by io/input-stream.
      The bytes supplied by the resulting stream must be gzip compressed.
  output: something which can be copied to by io/copy."
  [input output & opts]
  (with-open [input (-> input io/input-stream GZIPInputStream.)]
    (apply io/copy input output opts)))

(defn gzip
  "Writes the contents of input to output, compressed.

  input: something which can be copied from by io/copy.
  output: something which can be opend by io/output-stream.
      The bytes written to the resulting stream will be gzip compressed."
  [input output & opts]
  (with-open [output (-> output io/output-stream GZIPOutputStream.)]
    (apply io/copy input output opts)))

(defn gunzip-text-lines
  "Returns the contents of input as a sequence of lines (strings).

  input: something which can be opened by io/input-stream.
      The bytes supplied by the resulting stream must be gzip compressed.
  opts: as understood by clojure.core/slurp pass :encoding \"XYZ\" to
      set the encoding of the decompressed bytes. UTF-8 is assumed if
      encoding is not specified."
  [input & opts]
  (with-open [input (-> input io/input-stream GZIPInputStream.)]
    (str/split-lines (apply slurp input opts))))
