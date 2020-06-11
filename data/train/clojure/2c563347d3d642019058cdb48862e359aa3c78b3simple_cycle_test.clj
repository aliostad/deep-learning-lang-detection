(ns assemble.simple-cycle-test
  (:require [assemble.core :as a]
            [manifold.stream :as s]
            [manifold.deferred :as d]))

(defn manifold-step 
  ([] (s/stream))
  ([s] (s/close! s))
  ([s input] (s/put! s input)))

(defn manifold-connect 
  [in out] 
  (s/connect in out))

(defn generator 
  [f] 
  (fn [stream] (s/map f stream)))

(a/assemble
  
  manifold-step 
  
  manifold-connect
  
  (a/vertex :a [:c] generator
             
            (fn 
              ([] [1])
              ([x] (println x) x)))
        
  (a/vertex :b [:a] generator
       
            (fn 
              ([] [1])
              ([x] x)))
    
  (a/vertex :c [:b] generator
             
            (fn 
              ([] [1])
              ([x] x))))

