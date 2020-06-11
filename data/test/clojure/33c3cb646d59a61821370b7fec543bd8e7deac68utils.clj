(ns clj-http-trace.utils)

(defn <->
  "Calls a function with arguments in reverse order.  If no arguments are supplied, returns a function that will call the original function with the arguments in reversed order.  This is useful for when you want to thread a value through a function using -> or ->> and the function isn't written to take the threaded argument as the first or last argument (respectively)."
  ([f]
    (fn[& args]
      (apply <-> f args)))
  ([f & args]
    (->> (reverse args)
         (apply f))))


(defn conv [v i]
  (conj (if (vector? v) v (if v (vec v) [])) i))

(defn concatv [v other]
  (concat (if (vector? v) v (if v (vec v) [])) other))

;; Used to create and manage an incremental sequence matcher.

(defn init-matcher [val]
  [[] (vec val)])

(def get-matched first)

(def get-left-to-match second)

(defn matches? [v [_ l]]
  (= v (first l)))

(def all-matched? (comp empty? second)) 

(defn reset-matcher [[m l]]
  [[] (concatv m l)])

(defn shift-one [[m l]]
  [(conv m (first l)) (vec (rest l))])

(defn map-keys [f m]
  (reduce (fn [newm [k v]] (assoc newm (f k) v)) {} m))
