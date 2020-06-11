(ns {{name}}.core
  (:require [clojure.spec.alpha :as s]
            [expound.alpha :as expound]
            [orchestra.spec.test :as st]
            [com.rpl.specter :refer :all]
            [clojure.test.check :as tc]
            [clojure.test.check.generators :as gen]
            [clojure.test.check.properties :as prop]))

(set! s/*explain-out* (expound/custom-printer {:show-valid-values? true}))

(defn foo [x]
  (println "Hello" x))
(s/fdef foo
        :args (s/cat :x string?))

(st/instrument)

(defn -main []
  (foo "Keyser Soze"))
