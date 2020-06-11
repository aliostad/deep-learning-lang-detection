(ns sandbox.analyze
  (:import (org.apache.lucene.analysis SimpleAnalyzer Token)
           (org.apache.lucene.analysis.tokenattributes 
             OffsetAttribute TermAttribute)
           (java.io StringReader)))

(def *analyzer* (SimpleAnalyzer.))

(defn apply-analyzer 
  "returns a TokenStream"
  [analyzer field s]
  (.tokenStream analyzer field (StringReader. s)))

(defn token-stream-seq
  ([stream]
    (let [termAttribute (.getAttribute stream TermAttribute)]
      (token-stream-seq stream termAttribute [])))
  ([stream term-attribute result]
    (do
      (let [more (.incrementToken stream)
            term (.term term-attribute)]
        (if more
          (recur stream term-attribute (conj result term))
          result)))))

(defn -main [& args]
  (let [s "HeLlO world what is up?"]
    (println (token-stream-seq (apply-analyzer *analyzer* "name" s)))))
