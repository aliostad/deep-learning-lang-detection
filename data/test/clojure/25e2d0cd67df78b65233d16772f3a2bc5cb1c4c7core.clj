(ns compiler.core
  (:gen-class)
  (:require [clojure.core.match :refer [match]]
            [compiler.common.stream :refer [make-stream]]
            [compiler.common.location :refer [get-row get-col]]
            [compiler.common.token :refer [print-token]]
            [compiler.lexer.lexer :refer [lexer]])
  (:import [compiler.common.token Id Bad Keyword Puncuation Int-constant]
           [compiler.common.stream Stream]
           [compiler.common.location Location]))

(defn -main [f]
  (loop [stream (make-stream)
         loc (Location. 1 1)]
    (if (stream)
      (let [[token stream loc] (lexer stream)]
        (do
          (print-token token)
          (recur stream loc)))
      (do
        (println "Done!")
        true))))
