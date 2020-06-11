(ns clojure-dojo.core-test
  (:require [clojure.test :refer :all]
            [clojure-dojo.core :refer :all]))

(deftest test-stringify-track
  (testing "Parsing out notes from an instrument track")
  (let [expected "|xx--|--xx|x-x-|---|"
        result (stringify-track [1 1 0 0 0 0 1 1 1 0 1 0 0 0 0 0])]
    (is (= expected result))
    ))

(deftest test-load-binary-pattern
  (testing "Loading drum pattern."
    (let [expected "pattern_1.splice
    Saved with HW Version:"
          data (load-drum-pattern "pattern_1.splice")]
      (is (= expected data))
    )))
