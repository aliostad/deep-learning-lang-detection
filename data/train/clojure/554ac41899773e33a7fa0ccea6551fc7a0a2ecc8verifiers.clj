(ns uk.co.hughpowell.railway-oriented-clj.v1.verifiers
  (:require [clojure.test :refer :all]
            [clojure.spec.test.alpha :as spec-test]
            [uk.co.hughpowell.railway-oriented-clj.v1.public.result :as result]))

(spec-test/instrument)

(defn- assert-fail [_] (is false))

(defn- verify-data [expected]
  (fn [actual]
    (is (= actual expected))))

(defn verify-success [expected actual]
  (result/handle (verify-data expected) assert-fail actual))

(defn verify-failure [expected actual]
  (result/handle assert-fail (verify-data expected) actual))

(defn- exception-verifier [expected]
  (fn [actual]
    (is (instance? (type expected) actual))
    (is (= (.getMessage expected) (.getMessage actual)))))

(defn verify-exception [expected actual]
  (result/handle
    assert-fail
    (exception-verifier expected)
    actual))

