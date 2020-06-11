(ns watershed.simple-test
  (:require [watershed.core :as w]
            [manifold.stream :as s]
            [manifold.deferred :as d]))

(defn manifold-step 
  ([] (s/stream))
  ([s] (s/close! s))
  ([s input] (s/put! s input)))

(defn manifold-connect 
  [in out] 
  (s/connect in out {:upstream? true}))

(w/assemble
  
  manifold-step 
  
  manifold-connect
  
  (w/vertex :a [:c] 
             
             (fn 
               ([] [1])
               ([stream] (s/map #(do (println %) (identity %)) stream))))
  
    (w/vertex :b [:a] 
             
             (fn 
               ([] [1])
               ([stream] (s/map identity stream))))
    
    (w/vertex :c [:b] 
             
             (fn 
               ([] [1])
               ([stream] (s/map identity stream)))))