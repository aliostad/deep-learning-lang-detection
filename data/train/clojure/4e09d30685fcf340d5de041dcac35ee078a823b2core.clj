(ns figleaf.test.core
  (:use [figleaf.demo.core])
  (:use [figleaf.demo.test])
  (:use [clojure.test])
  (:require [figleaf.core :as figleaf]))

;; (deftest replace-me ;; FIXME: write
;;   (is false "No tests have been written."))

(deftest standard-fn?-test
  (is (not (figleaf/standard-fn? (var standard-fn?-test)))))

(defn- test-fn []
  (println "wish you were here."))

(deftest instrument-function-test
  (let [test-value (atom 0)
        pre-post-fn (fn [& _] (swap! test-value inc))
        restore-fn (figleaf/instrument-function (var test-fn) pre-post-fn pre-post-fn)]
    (is (= 0 @test-value))
    (test-fn)
    (is (= 2 @test-value))
    (test-fn)
    (is (= 4 @test-value))
    (restore-fn)
    (test-fn)
    (is (= 4 @test-value))))

(deftest instrument-namespace-test
  (let [test-value (atom 0)
        pre-post-fn (fn [& _] (swap! test-value inc))
        restore-fns (figleaf/instrument-namespace 'figleaf.demo.core pre-post-fn pre-post-fn)]
    (is (= 0 @test-value))
    (foo)
    (is (= 2 @test-value))
    (foo)
    (is (= 4 @test-value))
    (doseq [restore-fn restore-fns]
      (restore-fn))
    (foo)
    (is (= 4 @test-value))))

(deftest with-instrument-namespace-test
  (let [test-value (atom 0)
        pre-post-fn (fn [& _] (swap! test-value inc))]
    (do
      (is (not (figleaf/instrumented? foo)))
      (figleaf/with-instrument-namespace figleaf.demo.core pre-post-fn pre-post-fn
        (do
          (is (figleaf/instrumented? foo))
          (is (= 0 @test-value))
          (foo)
          (is (= 2 @test-value))
          (foo)
          (is (= 4 @test-value))))
      (foo)
      (is (not (figleaf/instrumented? foo)))
      (is (= 4 @test-value)))))

(deftest with-instrument-namespace-exception-test
  (let [test-value (atom 0)
        pre-post-fn (fn [& _] (swap! test-value inc))]
    (do
      (is (not (figleaf/instrumented? bad-bad-foo)))
      (try
        (figleaf/with-instrument-namespace figleaf.demo.core pre-post-fn pre-post-fn
          (do
            (is (figleaf/instrumented? bad-bad-foo))
            (bad-bad-foo)))
        (catch Exception e (pre-post-fn)))
      (is (not (figleaf/instrumented? bad-bad-foo)))
      (is (= 2 @test-value)))))
