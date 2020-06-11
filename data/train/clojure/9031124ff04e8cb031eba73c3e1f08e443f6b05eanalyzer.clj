(ns spam-and-eggs.tools.analyzer
  (:gen-class)
  (:require [clojure.java.io :as io]
            [clojure.tools.logging :as log])
  (:import (java.io BufferedReader InputStreamReader)
           (org.apache.lucene.analysis TokenStream
                                       Tokenizer)
           (org.apache.lucene.analysis.core LowerCaseFilter
                                            WhitespaceTokenizer)
           (org.apache.lucene.analysis.tokenattributes CharTermAttribute)))

(defn tokenizer [rdr]
  (doto (WhitespaceTokenizer.)
    (.setReader rdr)))

(defn downcaser [^TokenStream token-stream]
  (LowerCaseFilter. token-stream))

(defn token-stream-to-seq [^TokenStream token-stream]
  (.reset token-stream)
  (letfn [(f []
            (lazy-seq
             (let [attr (.getAttribute token-stream CharTermAttribute)]
               (if (.incrementToken token-stream)
                 (cons (.toString attr)
                       (f))
                 (do
                   (.end token-stream)
                   (.close token-stream)
                   nil)))))]
    (f)))

(defn token-stream-seq-to-pairs [token-seq]
  (partition 2 1 token-seq))

(defn add-transition [m from to]
  (update-in m [from to] (fnil inc 0)))

(defn markov-transition-count
  "Record each trainsition represented in each word pair. If the word
  ends in a period, also record that word as a starter word -
  i.e. add a value for it under the \"\" (empty string) key."
  [token-pairs]
  (reduce (fn [m [from to]]
            (cond-> m
              (.endsWith from ".") (add-transition "" to)
              :always (add-transition from to)))
          {"" {(ffirst token-pairs) 1}}
          token-pairs))

(defn analyze [is]
  (->> is
       InputStreamReader.
       BufferedReader.
       tokenizer
       downcaser
       token-stream-to-seq
       token-stream-seq-to-pairs
       markov-transition-count))

(defn -main [filename & args]
  (let [f (-> filename io/file)]
    (if-not (.exists f)
      (do (log/error "File does not exist:" filename)
          (java.lang.System/exit 1))
      (prn (analyze (io/input-stream f))))))

