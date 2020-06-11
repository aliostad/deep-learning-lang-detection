(ns peloton.stream
  (:use peloton.util)
  (:use peloton.cell)
  (:require [peloton.fut :as fut]))

(defprotocol IStream
  (close! [this])
  (^boolean eof? [this]))
  
(deftype Stream 
  [^clojure.lang.PersistentQueue ^{:volatile-mutable true} buffer 
   ^boolean ^{:volatile-mutable true} closed?
   ^clojure.lang.IFn ^{:volatile-mutable true} target]
  IStream
  (eof? [this] (and (empty? buffer) closed?))
  (close! [this] 
    (set! closed? (boolean true))
    (when target (target nil)))
  ICell
  (bind! [this t]
    (set! target t)
    (while (and 
            target 
            (not (empty? buffer)))
      (t (first buffer))
      (set! buffer (rest buffer)))
    (when (and target closed?)
      (target nil)) ; send eof message
    nil)
  (unbind! [this t]
    (set! target t))
  clojure.lang.IFn
  (invoke [this a-val] 
    (if target
      (target a-val)
      (set! buffer (conj buffer a-val)))))

(defn stream
  [] 
  (Stream. (clojure.lang.PersistentQueue/EMPTY) false nil))

(defn stream?  
  "Check to see if s is a stream"
  [s] 
  (instance? Stream s))

(defmacro do-stream
  "Run a body block in a stream with a binding"
  [bindings & body]
  (assert (= (count bindings) 2) "expecting 2 bindings")
  (let [[h t] bindings]
    `(let [t# ~t
           f# (fut/fut)
           g# (fn [~h] 
                (if (.eof? t#)
                  (f# true)
                  (do ~@body)))]
       (cond
         (stream? t#) (peloton.cell/bind! t# g#)
         :else (g# t#))
       f#)))
  
