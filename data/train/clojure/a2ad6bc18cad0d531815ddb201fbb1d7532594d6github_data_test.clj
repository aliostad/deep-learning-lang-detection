(ns clj-templates.github-data-test
  (:require [clojure.test :refer [use-fixtures]]
            [clj-templates.test-utils :refer [facts fact is= example-templates instrument-test]]
            [clj-templates.github-data :as github]))

(use-fixtures :each instrument-test)

(facts "update-template-github-info"
  (fact "updates template github stars and readme on successful requests"
    (let [stars-req (promise)
          readme-req (promise)]
      (deliver stars-req {:body "{\"stargazers_count\": 10}" :status 200})
      (deliver readme-req {:body "{\"content\": \"Zm9v\"}" :status 200}) ; base64-encoded "foo"
      (is= {:template-name "Foo"
            :description   ""
            :build-system  "lein"
            :github-url    "https://foo"
            :github-readme "foo"
            :github-id     nil
            :github-stars  10
            :homepage      "https://foo"
            :downloads     10}
           (github/update-template-github-info (first example-templates) stars-req readme-req))))

  (fact "removes github-url for template when stars request fails"
    (let [stars-req (promise)
          readme-req (promise)]
      (deliver stars-req {:status 404})
      (deliver readme-req {})
      (is= {:template-name "Foo"
            :description   ""
            :build-system  "lein"
            :github-url    nil
            :github-readme nil
            :github-id     nil
            :github-stars  nil
            :homepage      nil
            :downloads     10}
           (github/update-template-github-info (first example-templates) stars-req readme-req)))))
