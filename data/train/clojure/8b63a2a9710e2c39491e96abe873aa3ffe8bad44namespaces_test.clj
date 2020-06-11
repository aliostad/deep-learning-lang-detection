(ns server.namespaces-test
  (:require [server.namespaces :as sut]
            [midje.sweet :refer :all]
            [hydrox.core :as hydrox]
            [taoensso.timbre :refer [log spy] :as timbre]
            [clojure.test :refer [deftest is] :as t]
            [clojure.test.check :as tc]
            [clojure.spec :as s]
            [clojure.spec.gen :as gen]
            [clojure.spec.test :as stest]
            [server.db :as db]))

(background (timbre/-log! anything anything anything anything anything anything anything anything anything anything) => nil)

(deftest checks-spec
  (stest/instrument `server.db/insert! {:stub #{`server.db/insert!}})
  (stest/instrument `server.db/select {:stub #{`server.db/select}
                                       :gen {:server.db/select-result (fn [] (s/gen :sexpress/namespace-list))}})
  (let [checks (stest/summarize-results (stest/check (stest/enumerate-namespace 'server.namespaces)
                                                     {:clojure.spec.test.check/opts {:num-tests 10}}))]
    (is (= (:total checks) (:check-passed checks)) checks)
    (is (> (:total checks) 0))))
