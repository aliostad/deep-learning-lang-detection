(ns telegram-bot-api.api-test
  (:require [clojure.spec.test :as stest]
            [clojure.test :as t]
            [telegram-bot-api
             [api :as sut]
             [core :as tcore]]))

(defn- call-fixture [f]
  (stest/instrument `tcore/call {:replace {`tcore/call (fn [& r] {:ok false})}})
  (f)
  (stest/unstrument `tcore/call))

(def get-updates-check
  (stest/summarize-results (stest/check `sut/get-updates)))

(t/deftest get-updates-test
  (t/is (= (:total get-updates-check) (:passed get-updates-check))))

(t/use-fixtures :once call-fixture)
