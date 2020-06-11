(ns sicp.generic-arithmetic)

(defn tagged[data type]
  (with-meta data {:type-of type}))

(defn tag-in[data]
  (:type-of (meta data)))

(defmulti raise (fn [data] (tag-in data)))
(defmulti higher-type-in :default)
(defmethod  higher-type-in :default [& xs] (tag-in (first xs)))

(defn raise-to [target-type x]
  (if (= target-type (tag-in x))
    x
    (recur target-type (raise x))))

(defn raise-arguments [& xs]
  (let [target-type (apply higher-type-in xs)]
    (map #(raise-to target-type %) xs)))

(defn dispatch [& xs]
  (map tag-in xs))

(defn- re-dispatch [f & xs]
  (let [ args (flatten xs)
         types (apply dispatch (flatten args))]
    (if (not= 1 (count (set types)))
      (apply f (apply raise-arguments args))
      (throw (Exception. "invalid arguments")))))

(defmulti add dispatch)
(defmethod add :default [& xs]
  (re-dispatch add xs))

(defmulti sub dispatch)
(defmethod sub :default [& xs]
  (re-dispatch sub xs))

(defmulti mul   dispatch)
(defmethod mul :default [& xs]
  (re-dispatch mul xs))

(defmulti div   dispatch)
(defmethod div :default [& xs]
  (re-dispatch div xs))

(defmulti equ?  dispatch)
(defmethod equ? :default [& xs]
  (re-dispatch equ? raise-arguments xs))

