(ns purdy.pretty-printers
  (:require [purdy.document :as doc]))

;; (use-method simple-dispatch clojure.lang.ISeq pprint-list)
;; (use-method simple-dispatch clojure.lang.IPersistentVector pprint-vector)
;; (use-method simple-dispatch clojure.lang.IPersistentMap pprint-map)
;; (use-method simple-dispatch clojure.lang.IPersistentSet pprint-set)
;; (use-method simple-dispatch clojure.lang.PersistentQueue pprint-pqueue)
;; (use-method simple-dispatch clojure.lang.IDeref pprint-ideref)
;; (use-method simple-dispatch nil pr)
;; (use-method simple-dispatch :default pprint-simple-default)

(defn vector-to-doc
  [vec]
  (doc/bracket "[" (doc/stack (map (comp doc/text str) vec)) "]")
  #_(doc/bracket "[" (doc/fill-str vec) "]"))

(extend-type java.lang.Object
  doc/IPrintable
  (to-doc [this] (doc/text (str this))))

(extend-type clojure.lang.IPersistentVector
  doc/IPrintable
  (to-doc [this] (vector-to-doc this)))
