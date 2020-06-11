(ns org.thelastcitadel.bnfu.primitives)

(defn parse [parse-stream rules outer-result]
  (if (seq rules)
    (let [[rule & rules] rules
          result (rule parse-stream)]
      (for [result result
            item (parse (:rest result)
                        rules
                        (concat outer-result (:result result)))]
        item))
    [{:result outer-result
      :rest parse-stream}]))

(defn lit [value]
  (let [size (count value)
        vs (seq value)]
    (fn [parse-stream]
      (let [x (seq (take size parse-stream))]
        (when (= x vs)
          [{:result [[value]]
            :rest (drop size parse-stream)}])))))

(defn wrap [name result-seq]
  (for [result result-seq
        :when (seq (:result result))]
    (update-in result [:result] (comp list (partial cons name)))))

(defn parse-or [a b]
  (fn [parse-stream]
    (for [s [(parse parse-stream a [])
             (parse parse-stream b [])]
          item s
          :when (seq (:result item))]
      item)))

(defmacro defrule [rule-name args & body]
  `(defn ~(symbol (name rule-name)) ~args
     (doall (wrap ~(keyword (name rule-name))
                  ~@body))))
