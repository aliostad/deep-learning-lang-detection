(ns ideamind.model.core-test
  (:require [clojure.test :refer :all]
            [clojure.test.check.clojure-test :as tcct]
            [clojure.test.check.properties :as prop]
            [ideamind.test-util :as it]
            [ideamind.model.core]
            [clojure.spec :as s]
            [ideamind.test-util :as tu]
            [clojure.test :as t]))

(defn fixture [f]
  (tu/instrument-namespaces)
  (f))

(t/use-fixtures :once fixture)

(tcct/defspec model-startup
              it/test-iterations
              (prop/for-all [model (s/gen ::ideamind.model.core/Model)]
                            (is (s/valid? ::ideamind.model.core/Model-started
                                          (.start model)))))