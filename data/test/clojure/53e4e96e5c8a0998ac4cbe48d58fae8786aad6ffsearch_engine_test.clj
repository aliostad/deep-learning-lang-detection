(ns com.potetm.search-engine-test
  (:require [com.potetm.search-engine :as se]
            [clojure.spec :as spec]
            [clojure.spec.gen :as sgen]
            [clojure.spec.test :as stest]
            [clojure.test.check.generators :as gen]
            [clojure.string :as str]
            [clojure.test :refer [deftest testing is] :as test]
            [nio2.core :as nio2])
  (:import (com.google.common.jimfs Jimfs Configuration)
           (java.nio.charset StandardCharsets)))

;; from https://gist.github.com/alexanderkiel/931387c7a86c1879b2267ad064067af7
(defmethod test/assert-expr 'check [msg form]
  (let [args (rest form)]
    `(let [result# (stest/check ~@args)]
       (if (some :failure result#)
         (test/do-report {:type :fail
                          :message ~msg
                          :expected :no-errors
                          :actual (map (comp ex-data :failure)
                                       result#)})
         (test/do-report {:type :pass
                          :message ~msg
                          :expected '~form
                          :actual result#}))
       result#)))

(defn wrap-instrument [f]
  (println "instrumenting")
  (stest/instrument)
  (f)
  (stest/unstrument))

(test/use-fixtures :once wrap-instrument)

(def filename-parts-gen
  (gen/vector (gen/such-that (complement str/blank?)
                             gen/string-alphanumeric)
              1
              20))

(defn read-files-gen []
  (gen/bind (sgen/tuple filename-parts-gen
                        (gen/list (sgen/tuple filename-parts-gen
                                              (gen/one-of [(gen/return "invalid")
                                                           (spec/gen ::se/article)]))))
            (fn [[search-dir-parts files]]
              (let [fs (Jimfs/newFileSystem (Configuration/unix))
                    search-path (apply nio2/path fs search-dir-parts)]
                (doseq [[file-parts contents] files]
                  (let [p (apply nio2/path search-path file-parts)]
                    (nio2/create-dirs (.getParent p))
                    (nio2/write-bytes p (.getBytes contents
                                                   StandardCharsets/UTF_8))))
                (gen/return [fs (str search-path)])))))

(deftest generated-tests
  (testing "generated-tests"
    (is (check [`se/title
                `se/normalize
                `se/tokenize-and-rank
                `se/build-index
                `se/search]))))

(deftest read-files
  (testing "read-files generated tests"
    (is (check `se/read-files
               {:clojure.spec.test.check/opts {:num-tests 150}
                :gen {::se/read-files-args read-files-gen}}))))
