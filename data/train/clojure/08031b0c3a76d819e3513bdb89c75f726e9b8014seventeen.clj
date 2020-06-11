(ns adventofcode1.seventeen
  "http://adventofcode.com/2016/day/17"
  (:require
   [clojure.spec :as s]
   [clojure.spec.gen :as gen]
   [clojure.spec.test :as stest]
   [com.gfredericks.test.chuck.generators :as gen']
   [clojure.test.check :as tc]
   [clojure.test.check.generators :as tcgen]
   [clojure.test.check.properties :as tcprop]

   [clojure.core.match :refer [match]]

   spyscope.core
   adventofcode1.spec-test-instrument-debug))

;;; yet another search problem
;;; should I use core.logic or breath-search?
