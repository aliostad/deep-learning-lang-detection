(ns ampere.test-router
  (:require [cljs.test :refer-macros [is deftest async]]
            [ampere.router :refer [dispatch dispatch-sync event-queue *provenance*]]
            [ampere.handlers :as handlers]
            [ampere.core :as ampere]))


(deftest test-we-can-test-dispatch
  (async done
    (let [done #(js/setTimeout done)
          test1 (fn [db [_]] (done) db)]
      (do (handlers/clear-handlers!)
          (ampere/register-handler :test1 test1)
          (ampere/dispatch [:test1])))))


(deftest test-we-can-test-dispatch-deep
  (async done
    (let [done #(js/setTimeout done)
          test1 (fn [db [_]] (ampere/dispatch [:test2]) db)
          test2 (fn [db [_]] (done) db)]
      (do (handlers/clear-handlers!)
          (ampere/register-handler :test1 test1)
          (ampere/register-handler :test2 test2)
          (ampere/dispatch [:test1])))))


(deftest test-providence
  (async done
    (let [done #(js/setTimeout done)
          test3 (fn [db [_]]
                  (is (= [[:test3]] *provenance*))
                  (done)
                  db)]
      (do (handlers/clear-handlers!)
          (ampere/register-handler :test3 test3)
          (is (= [] *provenance*))
          (ampere/dispatch [:test3])))))


(deftest test-providence-deep
  (async done
    (let [done #(js/setTimeout done)
          test4 (fn [db [_]]
                  (is (= [[:test4]] *provenance*))
                  (ampere/dispatch [:test5]) db)
          test5 (fn [db [_]]
                  (is (= [[:test4] [:test5]] *provenance*))
                  (done) db)]
      (do (handlers/clear-handlers!)
          (ampere/register-handler :test4 test4)
          (ampere/register-handler :test5 test5)
          (ampere/dispatch [:test4])))))


(deftest test-providence-of-callback
  (async done
    (let [done #(js/setTimeout done)
          test3 (fn [db [_]]
                  (is (= [[:test3]] *provenance*))
                  (js/setTimeout
                    (ampere/bind-fn
                      (fn []
                        (is (= [[:test3]] *provenance*))
                        (done))))
                  db)]
      (do (handlers/clear-handlers!)
          (ampere/register-handler :test3 test3)
          (is (= [] *provenance*))
          (ampere/dispatch [:test3])))))


(deftest test-callback
  (async done
    (let [done #(js/setTimeout done)
          test3-callback (fn [db event-v]
                           (is (= [[:test3] [:test3-callback :an-arg]] *provenance*))
                           (done))
          test3 (fn [db [_]]
                  (is (= [[:test3]] *provenance*))
                  (js/setTimeout (ampere/callback [:test3-callback]) 0 :an-arg)
                  db)]
      (do (handlers/clear-handlers!)
          (ampere/register-handler :test3 test3)
          (ampere/register-handler :test3-callback test3-callback)
          (is (= [] *provenance*))
          (ampere/dispatch [:test3])))))