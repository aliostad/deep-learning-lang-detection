(ns tiger.core
  (:require [tiger.lexer :as lexer])
  (:import (java.io FileInputStream InputStreamReader BufferedReader))
  (:import (java.io FileOutputStream OutputStreamWriter BufferedWriter)))


(defn parser [src]
   (let [sb (StringBuilder.)]
     (with-open [reader (-> src
                            FileInputStream.
                            InputStreamReader.
                            BufferedReader.)]
       (loop [t (tiger.lexer/next-token reader 1 )]
         (if (= (t :kind) :TOKEN_EOF)
           (println t)
           (do
             (println t)
             (recur (lexer/next-token reader (t :linenum)))))))))

