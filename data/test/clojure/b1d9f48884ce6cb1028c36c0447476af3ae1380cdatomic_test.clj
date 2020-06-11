(ns badge-displayer.db.datomic-test
  (:require [clojure.test :refer [deftest are testing use-fixtures]]
            [datomic.api :as d]
            [badge-displayer.db.manage-datomic :as md]
            [badge-displayer.db.queries :as qu]
            [badge-displayer.db.some-test-data :refer [badge-entity1 badge-entity2]]))

(defn datomic-test-fixture [f]
  (md/init-db)  
  (f)
  (md/destroy-db))

(use-fixtures :once datomic-test-fixture)

(deftest insert-and-pull-entities-test
  (testing "Inserting and pulling some entities"
    (testing "/ Inserting"
      (are [expected actual] (= expected actual)
           4 (let [res (md/insert-entity badge-entity1)]
               (count @res))          
           4 (let [res (first (md/insert-entities [badge-entity1 badge-entity2]))]
              (count @res))))
    
    (testing "/ Pulling"
      (are [expected actual] (= expected actual)
           1 (count (qu/pull-all-users))          
           2 (count (qu/pull-collection "ttestic" "Test badges"))
           "An Example Badge Issuer" (:issuer/name (ffirst (qu/pull-collection "ttestic" "Test badges")))
           "Awesome Robotics Badge" (:badge-class/name (ffirst (qu/pull-collection "ttestic" "Test badges")))
           2 (count (qu/pull-all-badges-of-user "ttestic"))
           #inst "2012-09-11T10:50:29.000-00:00" (:assertion/issued-on (ffirst (qu/pull-all-badges-of-user "ttestic")))
           "email" (:identity/type (ffirst (qu/pull-all-badges-of-user "ttestic")))))

    (testing "/ Finding"
      (are [expected actual] (= expected actual)
           [17592186045420 "ttestic" "Testosav" "Testic" "testosav.testic@gmail.com"] (qu/find-user "ttestic")))    
    ))

