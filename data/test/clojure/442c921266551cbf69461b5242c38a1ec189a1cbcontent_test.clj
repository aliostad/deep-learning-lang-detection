(ns editorial.content-test
  (:require [clojure.test :refer :all]
            [editorial.content :refer :all]))

(deftest source-dispatch-test-1
  (testing "wikimedia sources must be identified as such"
    (let [in ["http://en.wikipedia.org/wiki/Montreal"
              "http://ru.wikipedia.org/wiki/Montreal"
              "http://es.wikidata.org/wiki/Montreal"]
          ex [:wikimedia :wikimedia :wikimedia]
          ou (map source-dispatch in)]
      (is (= ex ou)))))

(deftest source-dispatch-test-2
  (testing "non media wiki sources must be identified as such"
    (let [in ["http://google.com" 
              "http://wikigogobot.com"
              "http://en.lalalala.com"]
          ex [nil nil nil]
          ou (map source-dispatch in)]
      (is (= ex ou)))))

