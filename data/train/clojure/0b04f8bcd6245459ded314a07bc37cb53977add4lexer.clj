(ns clj-tparse.lexer
  (:require [clojure.string :as str]))

(declare string-regex-splitter remove-comments)

(def tst-input "resources/example1.ttl")

(def regex-triple-quote #" \"\"\"|\"\"\" ")

(def regex-triple-single-quote #" '''|''' ")

(def symbols (atom []))

(defn term-splitter
  "Splits turtle input into meaningfull parts.
  Seperates strings from the rest of the turtle formatted input. Puts strings in maps labeled as string.
  Returns vector containing alternating vectors and maps"
  [string]
  (if (string? string)
    (map #(%2 %1) (str/split string #"\"|'")
          (cycle [(fn [s] (str/split s #"\s+|\n+")) (fn [s] {:string (identity s)})]))
    string))

(defn remove-comments
  [string]
  (str/replace string #"\s#[^\n]+" ""))

(defn string-regex-splitter
  [regex]
  (fn [string]
    (if (> (count (re-seq regex string)) 1)
      (map #(%2 %1) (str/split string regex) (cycle [identity (fn [s] {:multi-string (identity s)})]))
      string)))

(defn splitter-composer
  [string]
  (reduce
    (fn [p f]
      (mapv f p))
    [string]
    [remove-comments
     (string-regex-splitter regex-triple-quote)
     (string-regex-splitter regex-triple-single-quote)]))

(defn manage-nesting
  [string]
  (if (string? (first string))
    string
    (string 0)))

(defn lexer
  [string]
  (vec (filter not-empty
           (flatten
             (map term-splitter
                  (manage-nesting (splitter-composer string)))))))
