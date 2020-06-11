(ns
  ^{:author mark}
  clj-ws.dispatcher-test
  (:require [clojure.test :refer :all]
            [clj-ws.dispatcher :refer :all]))

(defn do-nothing-function
  [request]
  )

(defn cause-exception-function
  [request]
  (prn (/ 3 0))
  )

(deftest dispatch-to-known-target
  (testing "dispatch to known target"
    (def handler-map {"request-id-1" do-nothing-function})
    (is
      (=
        (dispatch-request {"id" "request-id-1"} handler-map)
        :dispatched
        ))))

(deftest dispatch-to-unknown-target
  (testing "dispatch to unknown target"
    (def handler-map {})
    (is
      (=
        (dispatch-request {"id" "request-id-1"} handler-map)
        :unknown-target
        ))))

(deftest trap-and-report-exception
  (testing "trap and report exception"
    (def handler-map {"request-id-1" cause-exception-function})
    (is
      (=
        (dispatch-request {"id" "request-id-1"} handler-map)
        :handler-error
        ))))

(deftest trap-and-report-missing-request-id
  (testing "trap and report missing request id"
    (def handler-map {"request-id-1" cause-exception-function})
    (is
      (=
        (dispatch-request {} handler-map)
        :invalid-request
        ))))