(ns simtwop-web.test.domain.core-test
    (:require 
      [clj-time.core :as t]
      [clojure.test :refer :all]
      [simtwop-web.domain.core :refer :all]
      ))

(deftest date-stream-generation
  (testing "produces a single bounded week sequence for a single day engagement"
    (let [date-stream (generate-date-stream (t/date-time 2016 3 23) (t/date-time 2016 3 24))]
      (is (= 1 (count date-stream)))
      (is (= "21" ((first date-stream) :start-of-week)) "Incorrect start day for week")
      (is (= "Mar" ((first date-stream) :month)) "Incorrect first month for start date")))

  (testing "produces a pair of bounded weeks for a engagement over a single week"
    (let [date-stream (generate-date-stream (t/date-time 2016 3 23) (t/date-time 2016 3 30))]
      (is (= 2 (count date-stream)))
      (is (= "21" ((first date-stream) :start-of-week)) "Incorrect start day for first week")
      (is (= "Mar" ((first date-stream) :month)) "Incorrect month for start date")
      (is (= "28" ((second date-stream) :start-of-week)) "Incorrect start day for second week")
      (is (= "Mar" ((second date-stream) :month)) "Incorrect month for start date")))

  (testing "produces a set of bounded weeks for a engagement over a month"
    (let [date-stream (generate-date-stream (t/date-time 2016 3 23) (t/date-time 2016 4 23))]
      (is (= 5 (count date-stream)))
      (is (= "21" ((first date-stream) :start-of-week)) "Incorrect start day for first week")
      (is (= "Mar" ((first date-stream) :month)) "Incorrect month for start date")
      (is (= "18" ((last date-stream) :start-of-week)) "Incorrect start day for second week")
      (is (= "Apr" ((last date-stream) :month)) "Incorrect month for start date"))))
