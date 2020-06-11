(ns org.thelastcitadel.bnfu.prolog
  (:refer-clojure :exclude [atom])
  (:require [org.thelastcitadel.bnfu.generate :refer [bnf]]))

(defn lowercase-letter [parse-stream]
  (when (seq parse-stream)
    (if (> 123 (int (first parse-stream)) 96)
      [{:result [[:lowercase-letter (first parse-stream)]]
        :rest (rest parse-stream)}])))

(defn uppercase-letter [parse-stream]
  (when (seq parse-stream)
    (if (> 91 (int (first parse-stream)) 64)
      [{:result [[:uppercase-letter (first parse-stream)]]
        :rest (rest parse-stream)}])))

(defn EOL [parse-stream]
  (when (= \newline (first parse-stream))
    [{:result [[:EOL]]
      :rest (rest parse-stream)}]))

(declare parse-program)
(bnf "bnfu/prolog.bnf")
