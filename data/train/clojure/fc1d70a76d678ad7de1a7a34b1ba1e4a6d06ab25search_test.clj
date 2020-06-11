(ns clj-templates.search-test
  (:require [integrant.core :as ig]
            [clojure.test :refer [use-fixtures]]
            [clj-templates.test-utils :refer [facts example-templates fact is= instrument-test test-config index-example-templates]]
            [clj-templates.search :as search :refer [base-url]]))

(def test-es-client (atom nil))

(def api-example-templates (mapv search/adapt-template-to-api example-templates))

(defn reset-system [f]
  (with-redefs [search/base-url [:clj_templates_dev]
                search/index-url [:clj_templates_dev :templates]
                search/search-url [:clj_templates_dev :templates :_search]]
    (let [system (ig/init (select-keys test-config [:search/elastic]))
          es-client (:search/elastic system)]
      (reset! test-es-client es-client)
      (index-example-templates es-client)
      (f)
      (search/delete-index es-client)
      (ig/halt! system))))

(use-fixtures :each reset-system instrument-test)

(facts "search"
  (fact "can find all templates"
    (is= {:templates api-example-templates
          :hit-count 3}
         (search/match-all-templates @test-es-client 0 10)))

  (fact "can limit number of results"
    (is= {:templates (subvec api-example-templates 1 3)
          :hit-count 3}
         (search/match-all-templates @test-es-client 1 2)))

  (fact "gives a relevant result"
    (is= {:templates [(first api-example-templates)]
          :hit-count 1}
         (search/search-templates @test-es-client "Foo" 0 10))))
