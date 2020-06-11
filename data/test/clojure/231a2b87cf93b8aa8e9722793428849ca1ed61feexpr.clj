(ns moravec.expr
  (:refer-clojure :exclude [eval compile]))

(defn expr-dispatch [e]
  (or (and (seq? e) (first e))
      (:type (meta e))))

(defmulti eval #'expr-dispatch)

(defmethod eval :default [expr]
  (println (type expr) expr)
  (throw (dce.Exception. "unknown expr" :compiler {:type (type expr)
                                                   :expr expr})))

(defmulti compile #'expr-dispatch)

(defmulti get-compiled-class #'expr-dispatch)

(defmulti get-java-class #'expr-dispatch)

(defmulti emit (fn [o & _] (expr-dispatch o)))
