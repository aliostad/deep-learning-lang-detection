(ns evermind.test-util)
;(:require [cljs.spec.test :as t :refer [check]]))
;(:require-macros [cljs.spec.test :as t]))
;[clojure.test.check]))
;#?@(:clj [
;          (:require [clojure.spec.test.alpha :as st])
;          (:import (clojure.lang Namespace))]))

; (def test-iterations 40)

;#?(:clj (defn instrument-namespaces []
;          (let [syms (map (fn [^Namespace ns] (.getName ns)) (all-ns))]
;            (map #(-> (st/enumerate-namespace %) st/instrument) syms))))

;(defn check-sym
;  ([sym]
;   (check-sym sym {:clojure.test.check/opts {:num-tests test-iterations}}))
;               ;#?(:clj  :clojure.spec.test.check/opts
;               ;   :cljs :clojure.test.check/opts
;  ([sym params]
;   (let [outcome (cljs.spec.test/check sym params)
;                  ;#?(:clj st/check
;                  ;   :cljs cljs.spec.test/check
;         data    (-> outcome first)
;         failure (:failure data)
;         result  (nil? failure)]
;     ;(if data
;     ;  (println sym (:clojure.spec.test.check/ret data)))
;     (if (empty? outcome)
;       (println "No spec found for" sym))
;     (and result (not (empty? outcome))))))

(defmacro check-fn-clj
  "Meant to be used in a (cljs.test/deftest). Invokes cljs.spec.test/check on var and
  verifies that there weren't any failures in the generated tests."
  ([var]
   `(check-fn-clj ~var 1000))
  ([var num-tests]
   `(do
      (clojure.test/is (= (clojure.spec.test.alpha/summarize-results
                            (clojure.spec.test.alpha/check ~var {:clojure.spec.test.check/opts {:num-tests ~num-tests}}))
                          {:total 1 :check-passed 1})))))

(defmacro check-fn-cljs
  "Meant to be used in a (cljs.test/deftest). Invokes cljs.spec.test/check on var and
  verifies that there weren't any failures in the generated tests."
  ([var]
   `(check-fn-cljs ~var 1000))
  ([var num-tests]
   `(do
      (cljs.test/is (= (cljs.spec.test/summarize-results
                         (cljs.spec.test/check ~var
                                               {:clojure.test.check/opts {:num-tests (/ ~num-tests 2)}}))
                       {:total 1 :check-passed 1})))))