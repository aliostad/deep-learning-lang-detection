(in-ns 'clojure.pprint)

(defn not-java-class? [x]
  (symbol? (type x)))

(defn- map-vals [f m]
  (apply merge (map (fn [[k v]] {k (f v)}) m)))

;useless
(defn nested-types->name [x]
  (letfn [(fun [x]
            (if-let [n (:name x)]
               (symbol (name n))
               (cond
                 (map? x) (map-vals fun x) 
                 (sequential? x) (mapv fun x) 
                 :else x)))]
    (if (map? x) (map-vals fun x) (mapv fun x))))

; (defn bartok-sym [x]
;   (if-let [n (:name x)]
;      (symbol (name n))
;      (cond
;        (map? x) (map-vals bartok-sym x) 
;        (sequential? x) (mapv bartok-sym x) 
;        :else x)))

(defmulti bartok-dispatch
  #(if (not-java-class? %) 
     (cond 
       (:name %) :bartok-named
       (:is-type (meta %)) :bartok-type
       :else :bartok) 
     (class %)))

; (use-method bartok-dispatch :bartok #(pprint-map (nested-types->name %)))
(use-method bartok-dispatch :bartok-named pprint-simple-default)
(use-method bartok-dispatch :bartok-type  pprint-simple-default)
(use-method bartok-dispatch :bartok #(do (pprint-simple-default '<) 
                                         (pprint-simple-default (type %)) 
                                         (pprint-map (nested-types->name %)) 
                                         (pprint-simple-default '>)))
(use-method bartok-dispatch clojure.lang.ISeq pprint-list)
(use-method bartok-dispatch clojure.lang.IPersistentVector pprint-vector)
(use-method bartok-dispatch clojure.lang.IPersistentMap pprint-map)
(use-method bartok-dispatch clojure.lang.IPersistentSet pprint-set)
(use-method bartok-dispatch clojure.lang.PersistentQueue pprint-pqueue)
(use-method bartok-dispatch clojure.lang.IDeref pprint-ideref)
(use-method bartok-dispatch nil pr)
(use-method bartok-dispatch :default pprint-simple-default)

(set-pprint-dispatch bartok-dispatch)

(ns bartok.print
  (:use [clojure.pprint :only [pprint]]))

(defn pp [& xs] (dorun (map pprint xs)))




