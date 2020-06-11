;@+leo-ver=5-thin
;@+node:conor.20160610142118.2: * @file core.clj
;@@language clojure

(ns text-nodes.core
  (:require [com.rpl.specter  :as sp :refer [ALL]]
            [clojure.spec        :as s]
            [clojure.string      :as str]
            [clojure.spec.gen :as gen]
            [clojure.pprint       :refer [pprint]]
            [datascript.core    :as db])
  (:use
   [com.rpl.specter.macros
         :only [select transform defprotocolpath
                extend-protocolpath]]))

;@+others
;@+node:conor.20160610142317.2: ** (def ts [[0 :a] [1 
(def ts [[0 :a] [1 :b] [2 :c] [0 :d] [1 :e] [2 :b] [1 :f]])


;@+node:conor.20160610145512.1: ** Depthvec
;@+node:conor.20160610142317.3: *3* specs
(s/def ::function clojure.test/function?)

(s/def ::depthvec
  (s/cat :depth integer?
         :text  (s/or
                  :s string?
                  :k keyword?)))

(s/def ::depthvecs (s/+ ::depthvec))

(gen/sample (s/gen ::depthvec))

(s/fdef transform-depthvec
        :args ::s/any
          #_(s/cat :nodefn ::function
                     :edgefn ::function
                     :sibling-collector ::function
                     :nseq  (s/+
                              ::depthvec))
        :ret ::s/any)



;@+node:conor.20160610142318.2: *3* (s/instrument #'depthvec->graph) 


;@+node:conor.20160610142318.1: *3* depthvec->graph
(defn transform-depthvec [nodefn edgefn sibling-collector nseq]
  (loop [result []
         s nseq]
    (let[[pdepth ptitle] (first s)
         [children siblings] (split-with #(< pdepth (first %)) (rest s))
         answer   (nodefn ptitle)
         answer
         (if (seq children)
           (edgefn answer (transform-depthvec nodefn edgefn sibling-collector children))
           answer)]
      (if (seq siblings)
        (recur (sibling-collector result answer) siblings)
        (sibling-collector result answer)))))


(s/instrument #'transform-depthvec)

;@+node:conor.20160610145707.1: *3* depthvec->tree
;@+node:conor.20160610145855.1: *4* helpers
;@+node:conor.20160610142318.3: *5* (defn create-node  [title]  
(defn create-node
  [title]
  {:node title})
;@+node:conor.20160610142318.4: *5* (defn connect-node [node children]  
(defn connect-node [node children]
   (assoc node :children children :expanded true))




;@+node:conor.20160610142318.7: *4* (def depthvec->tree  (partial depthvec->graph 
(def depthvec->tree
  (partial transform-depthvec create-node connect-node conj))
;@+node:conor.20160610142318.8: *3* test
(pprint (depthvec->tree ts))
;@+node:conor.20160610150430.1: ** DS Node Creation
(comment
;@+others
;@+node:conor.20160610142318.10: *3* (def fake-db (db/create-conn)) 
  (def fake-db (db/create-conn))
;@+node:conor.20160610142318.9: *3* (defn dbafter->eid [rv]  (-> 
  (defn dbafter->eid [rv]
    (-> rv
      :tx-data
      ffirst))
;@+node:conor.20160610142318.11: *3* (defn create-ds-node [db text]  
;@-others


;@-others
;@-leo
