(ns ideamind.javafx.core-test
  (:require
    [clojure.test :refer :all]
    [ideamind.javafx.core :as ivc]
    [clojure.test.check.clojure-test :as tcct]
    [clojure.test.check.properties :as prop]
    [ideamind.test-util :as it]
    [clojure.spec :as s]
    [clojure.test :as t]
    [ideamind.test-util :as tu]))

(defn fixture [f]
  (tu/instrument-namespaces)
  (f))

(t/use-fixtures :once fixture)

(tcct/defspec view-start
              it/test-iterations
              (prop/for-all [view (s/gen ::ivc/View)
                             pres (s/gen ::ivc/presenter)]
                            (s/valid? ::ivc/View-started (.start (-> view
                                                                     (assoc :visible false)
                                                                     (assoc :presenter pres))))))

(t/deftest setup-ui
  (t/is (tu/check 'ideamind.javafx.core/setup-ui)))
