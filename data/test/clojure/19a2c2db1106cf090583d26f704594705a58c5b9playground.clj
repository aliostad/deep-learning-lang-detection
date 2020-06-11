(ns playground
  (:refer-clojure :exclude [doubles])
  (:require [clojure.pprint :as p]
            [clojure.spec.alpha :as s]
            [clojure.walk :as w]
            [criterium.core :as c]
            [mikron.runtime.core :as mikron :refer [defschema schema schema* pack unpack gen valid? diff undiff diff* undiff* interp]]
            [mikron.runtime.buffer :refer :all]
            [mikron.compiler.core :as compiler]
            [no.disassemble :as d]))

(set! *warn-on-reflection* true)

(set! *unchecked-math* :warn-on-boxed)

(defmacro c! [& body]
  `(c/with-progress-reporting (c/quick-bench (do ~@body))))

(defmacro p! [expr]
 `(->> (quote ~expr)
       (macroexpand)
       (p/pprint)
       (p/with-pprint-dispatch p/code-dispatch)
       (binding [p/*print-suppress-namespaces* true])))

(defmacro p!! [expr]
 `(->> (quote ~expr)
       (walk/macroexpand-all)
       (p/pprint)
       (p/with-pprint-dispatch p/code-dispatch)
       (binding [p/*print-suppress-namespaces* true])))

(defmacro d! [expr]
  `(println (d/disassemble ~expr)))

(defn ppm [obj]
  (let [orig-dispatch p/*print-pprint-dispatch*]
    (p/with-pprint-dispatch
      (fn [o]
        (when (meta o)
          (print "^")
          (orig-dispatch (meta o))
          (print " ")
          (p/pprint-newline :fill))
        (orig-dispatch o))
      (p/pprint obj))))

(comment
  (let [buffer (allocate 2000)]
    (reset buffer)
    (dotimes [_ 100]
      (put-byte buffer 10))
    (reset buffer)
    (dotimes [_ 100]
      (println (take-byte buffer))))

  (let [buffer (allocate 2000)]
    (c! (reset buffer)
        (dotimes [_ 100]
          (put-varint buffer 10))))

  (let [s (schema [:vector :byte])
        v (vec (repeat 100 1))]
    (c! (pack s v)))

  (let [s (schema [:vector :nil])
        v (vec (repeat 100 nil))]
    (c! (pack s v)))

  (->> (schema [:vector :int])
       :processors
       :pack
       (d!)))
