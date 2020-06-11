(ns sicp.streams
  (:require [clojure.tools.trace :refer [trace]]))

(defmacro scons [a b] `(list ~a (delay ~b)))

(defn car [stream] (first stream))

(defn cdr [stream] (force (second stream)))

(defn snth [stream n] (car (nth (iterate cdr stream) n)))

(defn stake [n stream] (map #(snth stream %) (range n)))

(defn smap [f stream] (if (empty? stream)
                    stream
                    (scons (f (car stream)) (smap f (cdr stream)))))

(defn sfilter [p stream] (if (empty? stream)
                           stream
                           (if (p (car stream))
                             (scons (car stream) (sfilter p (cdr stream)))
                             (sfilter p (cdr stream)))))

(def nats (scons 1 (smap inc nats)))

(def primes ((fn sieve [nats] (scons (car nats) (sfilter #(pos? (rem % (car nats))) (sieve (cdr nats))))) (cdr nats)))
