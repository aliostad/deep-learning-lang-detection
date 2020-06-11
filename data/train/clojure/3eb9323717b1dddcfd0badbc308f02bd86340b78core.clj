;; Copyright (c) 2010-2012 John H. Poplett.
;;
;; Permission is hereby granted, free of charge, to any person obtaining
;; a copy of this software and associated documentation files (the
;; "Software"), to deal in the Software without restriction, including
;; without limitation the rights to use, copy, modify, merge, publish,
;; distribute, sublicense, and/or sell copies of the Software, and to
;; permit persons to whom the Software is furnished to do so, subject to
;; the following conditions:

;; The above copyright notice and this permission notice shall be
;; included in all copies or substantial portions of the Software.

;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
;; EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
;; MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
;; NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
;; LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
;; OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
;; WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
;;
(ns figleaf.core
  (:use [clojure.set :only [difference]])
  (:require [clojure.test :as test]))

(defn standard-fn? [func]
  "Evaluate func to decide if it represents a standard function, i.e. not
a macro and not itself a test method."
  (and (.isBound func) (fn? (deref func))
       (not (:macro (meta func))) (not (:test (meta func)))))

(defn instrumented? [func]
  (not (nil? (:figleaf/original (meta func)))))

(defn instrument-function [var-name pre post]
  "Wrap given func with pre- and post-function calls. Return a let-over-lambda
expression to restore to original."
  (do
    (alter-var-root var-name
		    (fn [function]
		      (with-meta
			(fn [& args]
			  (if pre (pre (str var-name) args))
			  (let [result (apply function args)]
			    (if post (post (str var-name) args))
			    result))
			(assoc (meta function)
			  :figleaf/original function))))
    #(alter-var-root var-name (fn [function] (:figleaf/original (meta function))))))

(defn instrument-namespace [namespace-under-test pre post]
  "Instrument a namespace. Wrap in docall is necessary to make sure call methods are instrumented
ahead of use."
  (doall (map #(instrument-function %1 pre post) (filter standard-fn? (vals (ns-publics namespace-under-test))))))

;;
;; High-order function version of with-instrument-namespace.
;;
;; To avoid a compile time error in Clojure, a restore lambda function is
;; defined and called from the finally block; otherwise, Clojure complains
;; about recursion in the finally block.
;;
(defn with-instrument-namespace-fn [ns pre post body]
  "Wrap each function of the given package with pre and post function
calls. Call code specified in the body and restore the functions on exit.
Use try-finally block to guarantee recovery even when an exception occurs."
  (let [restore-list (instrument-namespace ns pre post)
	restore #(doseq [restore-fn restore-list]
		   (restore-fn))]
    (try (body)
	 (finally (restore)))))

(defmacro with-instrument-namespace [ns pre post & body]
  "Wrap each function of the given package with pre and post function
calls. Call code specified in the body and restore the functions on exit."
  `(with-instrument-namespace-fn '~ns ~pre ~post (fn [] ~@body)))

(let [funcall-counter (atom {})
      target-ns (atom 'user)]
  (defn all []
    (filter standard-fn? (vals (ns-publics @target-ns))))
;;    (loop for name being the external-symbol of package when (fboundp name) collect name))
  (defn tested []
    "Return a list of tested functions"
    (keys @funcall-counter))
  ;;  (loop for name being the hash-keys in funcall-counter collect name))
  (defn untested []
    "Return a list of untested functions."
    (difference (into #{} (all)) (into #{} (tested))))
  (defn increment-funcall-count
    "Increment count of times function is called by one. May arity2 into arity2."
    ([func-name _]
       (increment-funcall-count func-name))
    ([func-name]
    (let [current-count (get @funcall-counter func-name 0)]
      (swap! funcall-counter #(assoc % func-name (inc current-count))))))
  (defn funcall-count []
    "Return count of function calls."
    (reduce + (vals @funcall-counter)))
  (defn tested-function-count []
    "Return count of functions tested."
    (reduce + (map #(if (> %1 0) 1 0) (vals @funcall-counter))))
  (defn namespace-function-count []
    (count (all)))
  (defn reset-function-count []
    (swap! funcall-counter (fn [_] {})))
  (defn set-namespace [namespace-under-test]
    (swap! target-ns (fn [_] namespace-under-test)))
  (defmacro run-tests [namespace-under-test unit-test-namespace]
    "Instrument namespace-under-test and execute the unit tests in
unit-test-namespace. Code coverage results are appended to the output
of the standard test results."
    `(do
      (set-namespace '~namespace-under-test)
      (reset-function-count)
      (with-instrument-namespace ~namespace-under-test increment-funcall-count nil
	(test/run-tests '~unit-test-namespace))
      (printf "CODE COVERAGE: Functions %d, Tested %d, Ratio %2.0f%%\n" (namespace-function-count)
	      (tested-function-count) (/ (tested-function-count) (namespace-function-count) 0.01))))
  )
