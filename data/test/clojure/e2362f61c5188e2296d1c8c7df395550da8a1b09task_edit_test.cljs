(ns tasks.models.task-edit-test
  (:require [cljs.spec.test :as stest]
            [cljs.test :as test :refer-macros [is testing use-fixtures]]
            [devcards.core :as dc :refer-macros [deftest]]
            [tasks.models.task-edit :as task-edit]))

(use-fixtures :once
  {:before (fn [] (stest/instrument 'tasks.models.task-edit))
   :after (fn [] (stest/unstrument 'tasks.models.task-edit))})

(deftest task-edit-model
  "Return a map of validation errors message for a task edit"
  (testing "describe-errors"
    (is (= {}
           (task-edit/describe-errors
            {:id "42"
             :title "title"
             :body "body"
             :done false})))
    (is (= {:title "Title should be a non-empty string"}
           (task-edit/describe-errors
            {:id "42"
             :title ""
             :body "body"
             :done false})))))
