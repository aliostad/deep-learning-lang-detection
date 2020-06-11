(ns manage-topics.core-test
  (:require [clojure.test :refer :all]
            [manage-topics.core :refer :all]
            [clojure-ini.core :refer [read-ini]]
            [clojure.java.io :as io]))

(defmacro with-private-fns [[ns fns] & tests]
  "Refers private fns from ns and runs tests in context."
  `(let ~(reduce #(conj %1 %2 `(ns-resolve '~ns '~%2)) [] fns)
     ~@tests))

(def foo "[wow]")

(defn stream [string]
   (io/input-stream (.getBytes string)))

(def my-ini "[DEFAULT]
replication = 2

[my-topic.one]
retention.ms = 10000
index.interval.bytes = 20000
partitions = 10

[my-topic.two]
")


(with-private-fns [manage-topics.core
                   [keywordize-keys
                    kafka-config-from-target-config
                    get-target-config-from-options]]

  (deftest test-keywordize
    (testing "can keywordize a string-keyed hashmap"
      (is (= {:wow 1, :ok.cool. 2}
             (keywordize-keys {"wow" 1, "ok.cool." 2})))))

  (deftest test-prepare-config
    (testing "prepares and filters configuration map"
      (is (= {"cleanup.policy" "foo", "flush.ms" 100}
             (kafka-config-from-target-config
              {:cleanup.policy "foo", :flush.ms 100, :invalid "filterme"})))))

  (deftest get-config
    (testing "can get config from options with overrides"
      (let [my-options {:topics-ini (stream my-ini) :partitions "4"}]
        (is (= {:my-topic.one {:partitions "4"
                               :replication "2"
                               :retention.ms "10000"
                               :index.interval.bytes "20000"}
                :my-topic.two {:partitions "4"
                               :replication "2"}}
               (get-target-config-from-options my-options))))))

)
