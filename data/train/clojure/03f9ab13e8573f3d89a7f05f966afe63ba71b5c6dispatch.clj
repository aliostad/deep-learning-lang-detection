(ns qseq.dispatch
  "dispatch methods to Korma or (just Korma these days) implementations"
  (:require qseq.korma)
  (:import [clojure.lang  APersistentMap]))

(def dispatch-methods [:sort-key
                       :q-empty
                       :q-inside-boundary
                       :q-outside-boundary
                       :q-sorted
                       :q-limited
                       :execute])

(defn dispatch-fn
 [& args]
 (if (isa? (type (first args)) APersistentMap)
   :korma))

(dorun (map (fn [method]
              (let [mname (name method)
                    msym (symbol mname)]
                (eval `(defmulti ~msym dispatch-fn))
                (eval `(defmethod ~msym :korma [& args#] (apply #'~(symbol "qseq.korma" mname) args#)))))
            dispatch-methods))
