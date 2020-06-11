(ns varpushaukka.core-test
  (:require [clojure.test :refer [deftest is use-fixtures]]
            [varpushaukka.core :as core]
            [varpushaukka.test-util :refer [instrument-this-ns!]]))

(instrument-this-ns!)

(defn get-local-repo-url []
  (str "file://" (System/getProperty "user.dir") "/test/fixture/repository"))

(defmacro with-test-repo [& body]
  `(binding [core/*local-repo* "target/repository"
             core/*keyring-path* "test/fixture/keyring.gpg"
             core/*repositories*
             {"fixture" (get-local-repo-url)}]
     ~@body))

(deftest get-artifact-test
  (with-test-repo
    (is (nil? (core/get-artifact '[example/does-not-exist "1.0.0"])))
    (is (core/get-artifact '[example/exists "1.0.0"]))))
