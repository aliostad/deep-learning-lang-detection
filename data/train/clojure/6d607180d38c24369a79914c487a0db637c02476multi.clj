(ns hara.class.multi
  (:import clojure.lang.MultiFn))

(defn multimethod
  "creates a multimethod from an existing one
 
   (defmulti hello :type)
   
   (defmethod hello :a
     [e] (assoc e :a 1))
 
   (def world (multimethod hello \"world\"))
 
   (defmethod world :b
     [e] (assoc e :b 2))
 
   (world {:type :b})
   => {:type :b :b 2} 
 
   ;; original method should not be changed
   (hello {:type :b})
   => (throws)"
  {:added "2.4"}
  [source name]
  (let [table (.getMethodTable source)
        clone (MultiFn. name 
                        (.dispatchFn source) 
                        (.defaultDispatchVal source)
                        (.hierarchy source))]
    (doseq [[dispatch-val method] table]
      (.addMethod clone dispatch-val method))
    clone))