(ns clj-neo4j-procedures.procedures
  (:import (org.neo4j.procedure Context Description Name Procedure)
           (org.neo4j.graphdb GraphDatabaseService Label Node Relationship)
           (java.util.stream Stream StreamSupport)))

;; Example of Neo4j Stored Procedures 

(definterface INeo4jProcedure
  (findDenseNodes [^Number threshold] "clojure docstring for findDenseNodes goes here"))

#_(defn ^Stream -findDenseNodes
  [this db threshold]
  (Stream/of (map #(CljObjectResult. %) (^java.util.stream.Stream .stream (.getAllNodes db)))))

#_(deftype
 neo4j-procedure []
  INeo4jProcedure
  (^{Procedure {:mode "READ"}
     Description "Finds all nodes in the database with more relationships than the specified threshold."}
    findDenseNodes
    [this ^{Name {:value "threshold"}} threshold]
    (require 'clj-neo4j-procedures.procedures)
    (-findDenseNodes this threshold)))








#_(defrecord CljObjectResult [^java.lang.Object obj])


#_(defn returnStream
  [n]
  (-> n
  ; (doto  (java.util.ArrayList.)  (.add 1)  (.add 2))
      (.stream)
      #_(.flatMap  (reify java.util.function.Function  (apply  [_ arg]  (->CljObjectResult arg))))
      #_(.collect  (java.util.stream.Collectors/toList))))

#_(defn retStream
    [n]
    (-> n
        (.stream)
;        .iterator
        #_(StreamSupport/stream false)))

; (type %1)
; => java.util.stream.ReferencePipeline$3
(comment 
(->  
    (doto (java.util.ArrayList.) (.add 1) (.add 2))  
    (.stream)  
    (.map (reify java.util.function.Function (apply [_ arg] (inc arg))))  
    (.collect  (java.util.stream.Collectors/toList))))
 
