(ns uk.co.hughpowell.railway-oriented-clj.v1.result-test
  (:require [clojure.test :refer :all]
            [clojure.spec.test.alpha :as spec-test]
            [uk.co.hughpowell.railway-oriented-clj.v1.verifiers :as verifiers]
            [uk.co.hughpowell.railway-oriented-clj.v1.public.result :as result]))

(spec-test/instrument)

(deftest result
  (testing "success constructor"
    (let [value "foo"]
      (verifiers/verify-success value (result/succeed value))))
  (testing "failure constructor"
    (let [error "fail"]
      (verifiers/verify-failure error (result/fail error)))))

