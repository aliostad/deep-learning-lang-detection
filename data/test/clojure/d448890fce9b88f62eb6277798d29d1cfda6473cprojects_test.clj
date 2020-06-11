(ns server.projects-test
  (:require [server.projects :as sut]
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

;; ^{:refer sut/create :added "0.1"}
;; ^{:refer sut/list :added "0.1"}
;; (facts "writes to database"
;;   (fact "create inserts"
;;     (sut/create ..db.. ..data..)
;;     => ..result..
;;     (provided (db/insert! ..db.. anything) => ..result..))
;;   (fact "list reads"
;;     (sut/list ..db..)
;;     => [{:sexpress/project-name ..name..}]
;;     (provided (db/select ..db.. :project) => [{:sexpress/project-name ..name..}])))

(deftest checks-spec
  (stest/instrument `server.db/insert! {:stub #{`server.db/insert!}})
  (stest/instrument `server.db/select {:stub #{`server.db/select}
                                       ;; :spec {`server.db/select (s/fspec :args (s/cat :db :server.db/db :selector any?)
                                       ;;                                   :ret :sexpress/project-list)}
                                       :gen {:server.db/select-result (fn [] (s/gen :sexpress/project-list))}
                                       ;; :replace {`server.db/select (fn [_ _] (gen/generate (gen/fmap (fn [a] [{:sexpress/project-name a}]) (gen/string))))}
                                       })
  (let [checks (stest/summarize-results (stest/check (stest/enumerate-namespace 'server.projects)
                                                     {:clojure.spec.test.check/opts {:num-tests 10}}))]
    (is (= (:total checks) (:check-passed checks)) checks)
    (is (> (:total checks) 0))))
