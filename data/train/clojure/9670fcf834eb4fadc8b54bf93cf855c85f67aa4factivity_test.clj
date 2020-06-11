(ns de.sveri.getless.service.activity-test
  (:require [clojure.test :refer :all]
            [de.sveri.getless.service.activity :as act]
            [clj-time.core :as t-core]
            [clj-time.coerce :as t-coerce]
            [clojure.spec.test :as stest])
  (:import (java.sql Date)))

(def from-yesterday [{:id 1, :for-date (:yesterday (act/get-three-dates)), :users-id 1, :planned "cont-1"}])
(def from-today [{:id 1, :for-date (:today (act/get-three-dates)), :users-id 1, :planned "cont-1"}])
(def from-tomorrow [{:id 1, :for-date (:tomorrow (act/get-three-dates)), :users-id 1, :planned "cont-1"}])

(deftest pad-with-tomorrow-today-yesterday-if-needed-test
  (is (= 3 (count (act/pad-with-tomorrow-today-yesterday-if-needed from-yesterday))))
  (is (= 2 (count (act/pad-with-tomorrow-today-yesterday-if-needed from-today))))
  (is (= 1 (count (act/pad-with-tomorrow-today-yesterday-if-needed from-tomorrow)))))


(stest/instrument)
