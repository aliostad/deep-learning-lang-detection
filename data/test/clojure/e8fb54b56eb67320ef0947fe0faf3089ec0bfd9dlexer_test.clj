(ns clarkdown.lexer-test
  (:require [clojure.test :refer :all]
            [clarkdown.lexer :refer :all]))

(deftest try-star-1
  (let [state {:input-stream "*"
               :results []}]
    (is (= {:input-stream '() :results [:STAR]}
           (try-star state)))))

(deftest try-star-2
  (let [state {:input-stream "*a"
               :results []}]
    (is (= {:input-stream '(\a) :results [:STAR]}
           (try-star state)))))

(deftest try-star-3
  (let [state {:input-stream "a"
               :results []}]
    (is (nil? (try-star state)))))

(deftest get-text-1
  (let [state {:input-stream "*"
               :results []}]
    (is (= {:input-stream '() :results [\*]}
           (get-text state)))))

(deftest get-text-2
  (let [state {:input-stream "aa"
               :results []}]
    (is (= {:input-stream '(\a) :results [\a]}
           (get-text state)))))

(deftest try-newline-1
  (let [state {:input-stream "\n"
               :results []}]
    (is (= {:input-stream '() :results [:NEWLINE]}
           (try-newline state)))))

(deftest try-newline-2
  (let [state {:input-stream "\na"
               :results []}]
    (is (= {:input-stream '(\a) :results [:NEWLINE]}
           (try-newline state)))))

(deftest try-newline-3
  (let [state {:input-stream "\r\n"
               :results []}]
    (is (= {:input-stream '() :results [:NEWLINE]}
           (try-newline state)))))

(deftest try-newline-4
  (let [state {:input-stream "\ra"
               :results []}]
    (is (= {:input-stream '(\a) :results [:NEWLINE]}
           (try-newline state)))))

