(ns reframe.serverside-cljs-tests
  (:require [reframe.serverside :as serverside]
            [cemerick.cljs.test :as test]
            [re-frame.core :refer [dispatch-sync]]))

(test/deftest eval-js-function-tests
              (test/testing "Evaluate javascript addition"
                            (test/is (= (serverside/eval-js-function "2+2")
                                        4))))

(test/deftest run-js-tests
              (test/testing "Creates a function that evaluates javascript when called from ClojureScript"
                            (test/is (= ((serverside/run-js "2 + 2"))
                                        4))))

(test/deftest reframe-dispatch-tests
              (test/testing "Calls dispatch with supplied function"
                            (with-redefs [dispatch-sync (fn [value] value)]
                                         (test/is (= ((serverside/reframe-dispatch (fn [value] value)) 4)
                                                     4)))))
