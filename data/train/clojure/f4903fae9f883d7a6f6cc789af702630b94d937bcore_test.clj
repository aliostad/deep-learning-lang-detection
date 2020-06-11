(ns hbase-clj.core-test
  (:require 
    [midje.sweet :refer :all]
    (hbase-clj
      [core :refer :all]
      [driver :refer :all]
      [manage :refer :all])))

(defhbase test-hbase 
  "hbase.zookeeper.quorum" "localhost")

(def table-name "hbase_clj_teststu")

;;Delete the test table first to avoid accidents
(try 
  (delete-table! test-hbase table-name)
  (catch Exception e nil))

(create-table! 
  test-hbase table-name
  "info" "score")

(def-hbtable test-table
  {:id-type :string 
   :table-name table-name
   :hbase test-hbase}
  :info  {:--ktype :keyword  :--vtype :int :name :string}
  :score {:--ktype :keyword  :--vtype :long})

(try 
  (facts "About CRUDs"
    (with-table test-table
      (put! 
        ["101" {:info {:age 17 :name "Alice"}
                :score {:math 99 :physics 78}}]

        ["102" {:info {:age 19 :name "Bob"}
                :score {:math 63 :physics 52}}])

      (fact "Get single data by key without constraints returns the full data"
        (get "102") 
        => (just [["102"
                   {:info {:age 19 :name "Bob"}
                    :score {:math 63 :physics 52}}]]))

      (fact "with-versions works in get"
        (get :with-versions "102")
        => (just 
             [(just 
                ["102"
                 (contains 
                   {:info 
                    (contains 
                      {:age (contains [(contains {:val 19})])})})])]))

      (fact "family constraints works in get"
        (get ["101" {:info :*}])
        => (just [(just ["101" (just {:info (contains {})})])]))

      (fact "attr constraints works in get"
        (get ["101" {:score :math}])
        => (just [(just ["101" (just {:score (just {:math number?})})])]) 

        (= (get ["101" {:score :math}]) (get ["101" {:score [:math]}]))
        => truthy)

      (fact "scanning without any constraints returns every thing"
        (scan)
        => (just 
             [["101" {:info {:age 17 :name "Alice"}
                      :score {:math 99 :physics 78}}]

              ["102" {:info {:age 19 :name "Bob"}
                      :score {:math 63 :physics 52}}]]))

      (fact "`with-versions` works in scan"
        (scan :with-versions)
        => (contains 
             [(just 
                ["102"
                 (contains 
                   {:info 
                    (contains 
                      {:age (contains [(contains {:val 19})])})})])]))

      (fact "family constraints works in scan"
        (scan :attrs {:info :*})
        => (contains [(just ["101" (just {:info (contains {})})])]))

      (fact "attr constraints works in scan"
        (scan :attrs {:score [:math]})
        => (contains [(just ["101" (just {:score (just {:math number?})})])]))

      (put! 
        ["103" {:info {:age 21 :name "Cathy"}
                :score {:math 100 :physics 84 :chemistry 70}}]

        ["104" {:info {:age 20 :name "Dante"}
                :score {:math 73 :physics 92}}])

      (fact "start-id and stop-id works in scan"

        (scan :start-id "102") => (just [(contains ["102"])
                                         (contains ["103"])
                                         (contains ["104"])])

        (scan :stop-id "104")  => (just [(contains ["101"])
                                         (contains ["102"])
                                         (contains ["103"])])

        (scan :start-id "102" 
              :stop-id "104")  => (just [(contains ["102"])
                                         (contains ["103"])]))
      
      (fact "scan is lazy"
        (realized? (scan)) => falsey
        (type (scan)) => clojure.lang.LazySeq)

      (fact "scan is not lazy when `eager?` is set to be false"
        (vector? (scan :eager? true)) => truthy)

      (fact "calling `incr!` to update"
        (incr! ["101" {:info {:age 5}}])

        (get ["101" {:info [:age]}])
        => (just [(just ["101" {:info {:age 22}}])]))

      (fact "calling `incr!` on nil cols inits the col"
        (incr! ["101" {:info {:height 180}}])

        (get ["101" {:info [:height]}])
        => (just [(just ["101" {:info {:height 180}}])]))

      (fact "calling `incr!` on non-existing rows inits the row"
        (incr! ["201" {:info {:height 180}}])

        (get ["201" {:info [:height]}])
        => (just [(just ["201" {:info {:height 180}}])]))

      (fact "batch support works"
        (with-batch 
          (put! ["202" {:info {:height 180}}])
          (incr! ["202" {:info {:height 2}}])
          (incr! ["202" {:info {:height 2}}])
          
          (dotimes [x 200]
            (incr! ["202" {:info {:x 2}}])))
        
        (get ["202" {:info [:height :x]}])
        => (just [(just ["202" {:info {:height 184 :x 400}}])]))

      #_(fact "calling `delete!` on a row"
          (delete! "101")
          (scan) => (just [(contains ["102"])
                           (contains ["103"])
                           (contains ["104"])]))

      #_(fact "calling `delete!` on a family "
        (delete! ["102" [:score]])
        (scan) => (contains [(contains ["102" (just {:info map?})])]))

      #_(fact "calling `delete!` on an attr "
        (delete! ["103" [:score [:chemistry :math]]])
        (scan) => (contains [(contains ["103" (contains {:score (just {:physics 84})})])]))))

  (catch Exception e 
    (clojure.stacktrace/print-cause-trace e)))

(delete-table! test-hbase table-name)
