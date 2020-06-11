(ns invetica.uri.example-test
  (:require [clojure.spec.alpha :as s]
            [clojure.test :refer :all]
            [clojure.test.check.clojure-test :refer [defspec]]
            [clojure.test.check.properties :as prop]
            [invetica.test.spec :as test.spec]
            [invetica.uri :as uri]
            [invetica.uri.example :as sut]))

(use-fixtures :once test.spec/instrument)

(deftest t-specs
  (test.spec/is-well-specified 'invetica.uri.example))

(deftest t-endpoint+path
  (is (= (java.net.URI. "http://example.com/testing")
         (sut/endpoint+path {:endpoint "http://example.com"} "/testing"))))

(defspec t-endpoint+path-absolute?
  (prop/for-all [scheme (s/gen ::uri/scheme)
                 host (s/gen ::uri/host)
                 path (s/gen ::uri/path)]
    (let [api {:endpoint (str scheme "://" host)}]
      (uri/absolute-uri-str? (str (sut/endpoint+path api path))))))
