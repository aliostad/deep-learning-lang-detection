(ns clj-clos.core
  "Defines some CLOS-like primitives for use with Clojure multimethods"
  (:use [clj-clos.sort :only [kahn-sort]]
        [clojure.set :only [intersection]]
        [clojure.walk :only [postwalk-replace]]))

;; TODO: use proper and more generic memoization techniques for the method chain builders
;; instead of ad hoc caching

(def NEXT-METHOD
  "Maps multi-function to maps from dispatch values to following possible method.
  So: map to a map from dispatch values to methods"
  (atom {}))

(defn recall-next-method
  "Get the cached next method, given current dispatch, for the given multifn"
  [multifn current-dispatch]
  (get-in @NEXT-METHOD [multifn current-dispatch]))

(defn memoize-next-method!
  "Cache next method given current dispatch value"
  [multifn current-dispatch next-method]
  (swap! NEXT-METHOD assoc-in [multifn current-dispatch] next-method))

(defn clear-next-method!
  "Clear the cache for methods for a multfn"
  [multifn]
  (swap! NEXT-METHOD assoc multifn {}))

(defn taxonomy
  "Yields a DAG of the given taxa, based on ancestry"
  [taxa]
  (into {} (map (fn [taxon] [taxon (intersection taxa (parents taxon))]) taxa)))

(defn dispatch-chain
  "Get a chain of potential following dispatch values for a given multifn and given dispatch value"
  [multifn dispatch-value]
  (let [meths (methods multifn)
        generic-values (intersection (set (keys meths)) (ancestors dispatch-value))]
    (->> generic-values taxonomy kahn-sort)))

(defn method-chain
  "Get a chain of potential following methods for a given multifn and current dispatch value."
  [multifn dispatch-value]
  (map (methods multifn) (dispatch-chain multifn dispatch-value)))

(defn call-next-method
  "Emulates CLOS 'call-next-method' by in call-time creating a calling chain
   based on the current dispatch value and arguments.
   NOTE: can either use a cached following dispatch value or recreate a new 
   method chain.
   Supposed to be used inside a 'defmethod', using the dispatch-value and arguments
   of that invocation."
  [multifn dispatch-value & args]
  (let [cached-method (recall-next-method multifn dispatch-value)
        next-fn (or cached-method (first (method-chain multifn dispatch-value)))]
    (when next-fn
      (when (and next-fn (not cached-method))
        (memoize-next-method! multifn dispatch-value next-fn))
      (apply next-fn args))))

(defmacro defmethod*
  "Like defmethod but allows the use of a simple parameter-less 'call-next-method'
   in the body, just like CLOS.
   One can provide a :before or :after keyword after the dispatch value.
   NOTE: if using 'call-next-method', you do need to capture the arguments, i.e.,
   no _ ..."
  [multifn dispatch-val & rest]
  ;; We replace each '(call-next-method)' form with one with parameters
  ;; TODO: we currently look for both qualified and simple symbol
  (let [key (when (#{:before :after} (first rest)) (first rest))
        params ((if key second first) rest)
        ;; We replace parameters with new symbols and wrap the body in
        ;; a let form with the formal parameters being the variables
        formal-params (vec (map gensym params))
        let-bindings (vec (interleave params formal-params))
        fn-tail (if key (drop 2 rest) (next rest))
        aug-tail (case key
                   :after `((call-next-method) ~@fn-tail)
                   :before `(~@fn-tail (call-next-method))
                   fn-tail)
        expanded-call `(call-next-method ~multifn ~dispatch-val ~@formal-params)
        new-fn-tail (postwalk-replace {`(call-next-method) expanded-call,
                                       '(call-next-method) expanded-call}
                                      aug-tail)]
    ;; We clear the cache for this multifn
    `(do (clear-next-method! ~multifn)
         (defmethod ~multifn ~dispatch-val ~formal-params (let ~let-bindings ~@new-fn-tail)))))

(defmacro defmulti*
  "Macro that expands to a defmulti, but also sets up a method DAG for
   more efficient 'call-next-method' implementations, and enabling other meta
   strategies for method chaining, similar to CLOS' defgeneric.
   TODO: actually implement, since it currently does nothing more than defmulti"
  [multifn & rest]
  `(defmulti ~multifn ~@rest))

