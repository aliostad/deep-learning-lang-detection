(ns cloth.rpc-dispatch
  (:require [clojure.edn :as edn]))

(defn dispatch [ns msg context]
  (let [_ (println msg)
        obj  (edn/read-string msg)
        _ (println obj)
        op   (:op obj)
        args (assoc (:args obj) :context context)]
    (if-let [f (ns-resolve ns (symbol (str ns "/" (name op))))]
      (let [arglists (:arglists (meta f))
            arglist (first arglists)
            vals (map #(get args (keyword (name %))) arglist)]
        (if (> (count arglists) 1)
          (println "RPC Dispatch doesn't support overloaded functions.")
          (do (println "Dispatch op:" op)
              (apply f vals))))
      (println "No matching RPC function found:" op))))
