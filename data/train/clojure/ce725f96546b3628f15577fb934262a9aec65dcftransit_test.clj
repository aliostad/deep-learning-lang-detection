(ns clj-templates.util.transit-test
  (:require [clojure.test :refer [use-fixtures]]
            [clj-templates.test-utils :refer [facts fact is= instrument-test]]
            [clj-templates.util.transit :refer [transit-json read-transit-json]]))

(use-fixtures :each instrument-test)

(facts "transit-json-fns"
  (let [value {:foo {:bar ["baz" 1 2 3]}}
        encoded-value "[\"^ \",\"~:foo\",[\"^ \",\"~:bar\",[\"baz\",1,2,3]]]"]

    (fact "transit-json returns a transit-encoded string"
      (is= encoded-value
           (transit-json value)))

    (fact "read-transit-json returns the encoded clojure value"
      (is= value
           (read-transit-json encoded-value)))))
