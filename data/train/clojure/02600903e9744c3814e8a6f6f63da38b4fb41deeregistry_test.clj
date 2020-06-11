(ns ppi-query.interaction.psicquic.registry-test
  (:require [clojure.test :refer :all]
            [clojure.test.check.generators :as gen]
            [clojure.spec.alpha :as s]
            [clojure.spec.test.alpha :as stest]
            [ppi-query.test.utils :refer :all]
            [ppi-query.interaction.psicquic.registry :as reg])
  (:import (org.hupo.psi.mi.psicquic.wsclient PsicquicSimpleClient)))

(def example-registry
  {:tag :registry
   :attrs nil
   :content [{:tag :service
              :attrs nil
              :content [{:tag :name
                         :attrs nil
                         :content ["name1"]}
                        {:tag :restUrl
                         :attrs nil
                         :content ["http://url1.com/rest"]}
                        {:tag :active
                         :attrs nil
                         :content ["false"]}
                        {:tag :organizationUrl
                         :attrs nil
                         :content ["http://url1.com"]}]}

             {:tag :service
              :attrs nil
              :content [{:tag :name
                         :attrs nil
                         :content ["name2"]}
                        {:tag :restUrl
                         :attrs nil
                         :content ["http://url2.com/rest"]}
                        {:tag :active
                         :attrs nil
                         :content ["true"]}
                        {:tag :organizationUrl
                         :attrs nil
                         :content ["http://url2.com"]}]}]})

(def expected-registry
  {"name1" {:name "name1" :restUrl "http://url1.com/rest"
            :active false :organizationUrl "http://url1.com"}
   "name2" {:name "name2" :restUrl "http://url2.com/rest"
            :active true :organizationUrl "http://url2.com"}})

(deftest* test-registry-client

  (testing "Parse registry xml into records"
    (is (.equals (reg/parse-registry example-registry)
                 expected-registry)))

  (testing "Fetch registry services"
    (instrument-stub-return
      `reg/fetch-registry-xml ::reg/registry-xml
      #(gen/return example-registry))

    (is (.equals (reg/fetch-registry true)
                 expected-registry))))

(comment
  (do
    (def registry (reg/fetch-registry true))))


(deftest* check-get-clients
  ; Stub registry to avoid network call
  (stest/instrument `reg/get-service
    {:stub #{`reg/get-service}})

  (let [clients (reg/get-clients ["foo", "bar"])]
    (is (= 2 (count clients)))

    (for [client clients]
      (is (instance? PsicquicSimpleClient client)))))
