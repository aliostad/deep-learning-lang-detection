(ns killer.utils)

(defn swap-first! [a f & args]
  (loop []
    (let [old-val @a
          [new-val other] (apply f old-val args)]
      (if (compare-and-set! a old-val new-val)
        other
        (recur)))))

(defn vassoc [s i v]
  "associate a value into e.g. a vector but return original vector if result would be same by value"
  (if (= v (nth s i)) s (assoc s i v)))

(defn index-by [mf kf s]
  (apply mf (mapcat (fn [v] [(kf v) v]) s)))

;;------------------------------------------------------------------------------
;; anonymous multi-methods... - see tests

(defn ^clojure.lang.MultiFn make-multifn [dispatch-fn]
  (clojure.lang.MultiFn. nil dispatch-fn :default #'clojure.core/global-hierarchy))

(defn make-method! [^clojure.lang.MultiFn mf dispatch-v f]
  (.addMethod mf dispatch-v f))

(defn mfn [dispatch-fn dispatch-value-and-methods]
  (let [mf (make-multifn dispatch-fn)]
    (doseq [[dispatch-v method] dispatch-value-and-methods]
      (make-method! mf dispatch-v method))
    mf))

  
;;------------------------------------------------------------------------------

(defn count-by [pred es]
  (reduce (fn [s e] (if (pred e) (inc s) s)) 0 es))
