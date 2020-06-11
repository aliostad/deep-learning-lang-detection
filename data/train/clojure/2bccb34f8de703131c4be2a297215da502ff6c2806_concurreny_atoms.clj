(ns CookBookClojure.06_concurreny_atoms)

; Atoms provide a way to manage shared, synchronous, and independent states.

; creating 
(def first-atom (atom 1)) 

; reading
(deref first-atom)
@first-atom

; updating
(swap! first-atom inc)
(swap! first-atom (partial + 1)) 

; reset value
(reset! first-atom 100) 

; using validator
(def y (atom 1 :validator (partial > 5))) ; atom must be less than 5 
(swap! y (partial + 2)) 
;(swap! y (partial + 2)) ; StateException

; Compara and Swap (CAS)

(defn cas-test! [my-atom interval] 
  (let [v @my-atom u (inc @my-atom)] 
    (println "current value = " v ", updated value = " u) 
    (Thread/sleep interval) 
    (println "updated " (compare-and-set! my-atom v u)))) 

(def x (atom 1)) 
