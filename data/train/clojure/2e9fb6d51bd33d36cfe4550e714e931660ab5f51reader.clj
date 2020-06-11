;; Copyright (c) 2014, Paul Mucur (http://mudge.name)
;; Released under the Eclipse Public License:
;; http://www.eclipse.org/legal/epl-v10.html

(ns php_clj.reader
  (:require [clojure.string :as s])
  (:import [java.io ByteArrayInputStream BufferedInputStream]))

(defn buffered-input-stream
  "Returns a BufferedInputStream for a string."
  [^String s]
  (-> s .getBytes ByteArrayInputStream. BufferedInputStream.))

(defn read-char
  "Reads a single character from a BufferedInputStream and returns it. Note that
  this mutates the given stream."
  [^BufferedInputStream stream]
  (-> stream .read char))

(defn read-str
  "Reads n bytes from a BufferedInputStream and returns them as a string. Note
  that this mutates the given stream."
  [^BufferedInputStream stream n]
  (let [selected-bytes (byte-array n)]
    (.read stream selected-bytes)
    (String. selected-bytes)))

(defn read-until
  "Reads from the given stream until a specified character is found and returns
  the string up to that point (not including the delimiter). Note that this
  mutates the given stream."
  [reader delimiter]
  (loop [acc []]
    (let [c (read-char reader)]
      (if (= delimiter c)
          (s/join acc)
          (recur (conj acc c))))))
