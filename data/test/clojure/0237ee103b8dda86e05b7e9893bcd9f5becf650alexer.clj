(ns compiler.lexer.lexer
  (:require
    [clojure.core.match :refer [match]]
    [compiler.common.stream 
     :refer [peek-char empty-stream? advance-1 char-count]]
    [compiler.common.common :refer [str->int space? newline?]]
    [compiler.common.location :refer [inc-row inc-col]]
    [compiler.common.token
     :refer [keywords single-char-puncuation multi-char-puncuation
             const-prefix? id-prefix? id-keyword? d-puncuation-prefix?
             s-puncuation-prefix?]])
  (:import [compiler.common.token Id Bad Keyword Puncuation Int-constant]
           [compiler.common.location Location]
           [compiler.common.stream Stream]))


(defn get-lexeme [p stream]
  {:pre [(false? (empty-stream? stream))]}
  (letfn [(helper [acc s] 
            (let [c (peek-char s)] 
              (if (p c) 
                (recur (str acc c) (advance-1 s))
                [acc s])))]
    (helper "" stream)))


(defn s->id-keyword [stream loc]
  {:pre [(false? (empty-stream? stream))
         (let [c (peek-char stream)]
           (id-prefix? c))]}
  (let
      [[lexeme rest-stream] (get-lexeme id-keyword? stream)
       n (- (char-count rest-stream) (char-count stream))
       new-loc (inc-col n loc)]
    (if (keywords lexeme) 
      [(Keyword. lexeme new-loc) rest-stream new-loc] 
      [(Id. lexeme new-loc) rest-stream new-loc])))


(defn s->int-constant
  [stream loc]
  {:pre [(false? (empty-stream? stream))
         (let [c (peek-char stream)]
           (const-prefix? c))]}
  (let [[lexeme rest-stream] (get-lexeme const-prefix? stream)
        n (- (char-count rest-stream) (char-count stream))
        new-loc (inc-col n loc)
        i (str->int lexeme)]
    [(Int-constant. i loc) stream new-loc]))


(defn s->single-puncuation [stream loc]
  {:pre [(false? (empty-stream? stream))
         (let [c (peek-char stream)]
           (c single-char-puncuation))]}
  (let [c1 (peek-char stream)
        rest-stream (advance-1 stream)
        c2 (peek-char rest-stream)
        c1c2 (str c1 c2)]
    (if (c1c2 multi-char-puncuation)
      [(Puncuation. c1c2 loc) (advance-1 rest-stream) (inc-col 2 loc)]
      [(Puncuation. (str c1) loc) rest-stream (inc-col 1 loc)])))


(defn s->double-puncuation [stream loc]
  {:pre [(false? (empty-stream? stream))
         (let [c (peek-char stream)]
           (d-puncuation-prefix? c))]}
  (let [c1 (peek-char stream)
        rest-stream (advance-1 stream)
        c2 (peek-char rest-stream)
        c1c2 (str c1 c2)]
    (if (c1c2 multi-char-puncuation)
      [(Puncuation. c1c2 loc) (advance-1 rest-stream) (inc-col 2 loc)]
      [(Bad. (str c1) loc) rest-stream (inc-col 1 loc)])))


(defn ^:dynamic lexer [stream loc]
  (if (empty-stream? stream)
    false
    (let [c (peek-char stream)]
      (cond
        (space? c) (lexer (advance-1 stream) (inc-col loc))
        (newline? c) (lexer (advance-1 stream) (inc-row loc))
        (id-prefix? c) (s->id-keyword stream loc)
        (const-prefix? c) (s->int-constant stream loc)
        (s-puncuation-prefix? c) (s->single-puncuation stream loc)
        (d-puncuation-prefix? c) (s->double-puncuation stream loc)
        :else (Bad. (str c) loc)))))


(def s (Stream. (seq "x = 10;") 0))
(lexer s (Location. 1 1))
;;(lexer (Stream. (seq "x = 10;") 0) (Location. 0 0))
;;(lexer (Stream. (seq "int x;") 0) (Location. 0 0))
