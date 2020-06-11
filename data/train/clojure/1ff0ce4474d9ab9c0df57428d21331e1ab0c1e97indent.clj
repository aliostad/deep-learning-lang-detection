(ns indent.indent
  (:use [clojure.pprint :only [formatter-out simple-dispatch]]))

(defn- use-method
  "Installs a function as a new method of multimethod associated with dispatch-value. "
  [multifn dispatch-val func]
  (. multifn addMethod dispatch-val func))

(def pprint-simple-list (formatter-out "~:<~1i~_~@{~w~^ ~_~}~-1i~_~:>"))
(def pprint-vector (formatter-out "~<[~;~1i~@{~w~^ ~_~}~-1i~_~;]~:>"))
(def ^{:private true} pprint-array (formatter-out "~<[~;~@{~w~^, ~:_~}~;]~:>"))
(def pprint-map (formatter-out (str "~<{~;~1i~_~@{~<~w~^ ~_~w~:>~^, ~_~}~-1i~_~;}~:>")))
(def ^{:private true} pprint-set (formatter-out "~<#{~;~1i~_~@{~w~^ ~:_~}~-1i~_~;}~:>"))
(def ^{:private true} pprint-pqueue (formatter-out "~<<-(~;~1i~_~@{~w~^ ~_~}~-1i~_~;)-<~:>"))

(defmulti 
  indent-dispatch
  "The pretty print dispatch function for simple data structure format, with definable indent"
  {:arglists '[[object]]} 
  class)

(use-method indent-dispatch clojure.lang.ISeq pprint-simple-list)
(use-method indent-dispatch clojure.lang.IPersistentVector pprint-vector)
(use-method indent-dispatch clojure.lang.IPersistentMap pprint-map)
(use-method indent-dispatch clojure.lang.IPersistentSet pprint-set)
(use-method indent-dispatch clojure.lang.PersistentQueue pprint-pqueue)
(use-method indent-dispatch nil pr)
(use-method indent-dispatch :default simple-dispatch)
