(ns workflo.query-engine.data-layer.entitydb-test
  (:require [clojure.spec.test.alpha :as spec.test]
            [clojure.test :refer [deftest]]
            [workflo.query-engine.test-entitydb :refer [setup]]
            [workflo.query-engine.data-layer.no-authorization-common-test :as c]))


;;;; Instrument all spec-ed symbols


(spec.test/instrument)


;;;; Fetch individual entities


(deftest fetch-one-without-cache
  (c/test-fetch-one (assoc setup :cache? false)))


(deftest fetch-one-with-cache
  (c/test-fetch-one (assoc setup :cache? true)))


;;;; Fetch a collection of entities


(deftest fetch-many-without-cache
  (c/test-fetch-many (assoc setup :cache? false)))


(deftest fetch-many-with-cache
  (c/test-fetch-many (assoc setup :cache? true)))


;;;; Fetch all instances of an entity


(deftest fetch-all-without-cache
  (c/test-fetch-all (assoc setup :cache? false)))


(deftest fetch-all-with-cache
  (c/test-fetch-all (assoc setup :cache? true)))

