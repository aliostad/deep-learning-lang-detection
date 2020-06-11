(ns jlk.math.generic
  (:refer-clojure :exclude [+ - * /]))

(defn -dispatch
  ([& args] (vec (map class args))))

(defmulti + -dispatch)
(defmulti - -dispatch)
(defmulti * -dispatch)
(defmulti / -dispatch)

(defmulti square -dispatch)
(defmulti square-root -dispatch)
(defmulti cube -dispatch)
(defmulti cube-root -dispatch)
(defmulti power -dispatch)
(defmulti nth-root -dispatch)

(defmulti exp -dispatch)
(defmulti ln -dispatch)
(defmulti log -dispatch)

(defmulti sin -dispatch)
(defmulti cos -dispatch)
(defmulti tan -dispatch)
(defmulti asin -dispatch)
(defmulti acos -dispatch)
(defmulti atan -dispatch)

(defmulti sinh -dispatch)
(defmulti cosh -dispatch)
(defmulti tanh -dispatch)
