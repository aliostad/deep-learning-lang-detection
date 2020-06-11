(ns sandbox.multi-impl
 (:refer-clojure :exclude [defmethod defmulti]))

(def multimethods (atom {}))


(defn defmulti-impl [name dispatch-fn]
  (fn [& args]
    (let [dispatch-val (apply dispatch-fn args)
          method-impl  (get-in @multimethods [name dispatch-val])]
     (if method-impl
       (apply method-impl args)
       (throw (Error. (str "No implementation of " name " for " dispatch-val)))))))

(defmacro defmulti [name dispatch-fn]
  (swap! multimethods assoc name {})
 `(def ~name ~(defmulti-impl name (eval dispatch-fn))))

(defmacro defmethod [name dispatch-val params & body]
  (swap! multimethods assoc-in [name dispatch-val]
         (eval `(fn [~@params]
                  ~@body))))
