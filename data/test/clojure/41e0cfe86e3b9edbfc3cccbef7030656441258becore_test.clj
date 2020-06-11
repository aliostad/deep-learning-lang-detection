(ns ideamind.presentation.core-test
  (:require [clojure.test :refer :all]
            [ideamind.presentation.core :as pres]
            [clojure.test.check.clojure-test :as tcct]
            [ideamind.test-util :as it]
            [clojure.test.check.properties :as prop]
            [clojure.spec :as s]
            [clojure.test :as t]
            [ideamind.test-util :as tu]))

(defn fixture [f]
  (tu/instrument-namespaces)
  (f))

(t/use-fixtures :once fixture)

(tcct/defspec presenter-setup
              it/test-iterations
              (prop/for-all [presenter (s/gen ::pres/Presenter)
                             model     (s/gen ::pres/model)]
                            (is (s/valid? ::pres/Presenter-started (-> presenter
                                                                       (assoc :model model)
                                                                       .start)))))

(tcct/defspec presenter-start
              it/test-iterations
              (prop/for-all [presenter (s/gen ::pres/Presenter-started)]
                            (is (s/valid? ::pres/Presenter-started (.start presenter)))))