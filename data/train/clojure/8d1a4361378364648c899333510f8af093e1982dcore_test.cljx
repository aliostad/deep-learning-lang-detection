(ns respondent.core-test
  #+clj (:require [clojure.test :as t
                   :refer (is deftest testing)]
                  [cemerick.cljs.test :refer (block-or-done)]
                  [respondent.core :as r :refer [behavior]]
                  [clojure.core.async :as async
                   :refer [go go-loop chan <! >! timeout alts!]])

  #+cljs (:require [cemerick.cljs.test :as t]
                   [respondent.core :as r]
                   [cljs.core.async :as async
                    :refer [chan <! >! timeout alts!]])

  #+cljs (:require-macros [cemerick.cljs.test
                           :refer (is deftest block-or-done testing)]
                          [respondent.core :refer [behavior]]
                          [cljs.core.async.macros :refer [go go-loop]]))


(deftest event-stream-tests
  (testing "deref"
    (let [stream (r/event-stream)]
      (is (= @stream ::r/empty))))

  (testing "deliver"
    (let [stream (r/event-stream)]
      (r/deliver stream 10)
      (is (= @stream 10))))

  (testing "stream completion"
    (let [stream (r/event-stream)]
      (is (not (r/completed? stream)))
      (r/deliver stream ::r/complete)
      (is (r/completed? stream)))))


(deftest ^:async subscribe-to-event-stream
  (let [complete (chan)
        result-ch (chan)
        stream (r/event-stream)]

    (r/subscribe stream (fn [value]
                          (go (>! result-ch value))))
    (r/deliver stream 765)
    (go
      (is (= 765 (<! result-ch)))
      (>! complete true))
    (block-or-done complete)))

(deftest ^:async mapping
  (let [complete (chan)
        result-ch (chan)
        stream  (r/event-stream)
        doubled (r/map stream #(+ % %))]

    (r/subscribe doubled (fn [value]
                           (go (>! result-ch value))))
    (go
      (r/deliver stream 2)
      (<! (timeout 1))
      (r/deliver stream 4)

      (is (= 4 (<! result-ch)))
      (is (= 8 (<! result-ch)))
      (>! complete true))
    (block-or-done complete)))

(deftest ^:async filtering
  (let [complete (chan)
        result-ch (chan)
        stream  (r/event-stream)
        even (r/filter stream even?)]

    (r/subscribe even (fn [value]
                        (go (>! result-ch value))))

    (go
      (doseq [n (range 4)]
        (r/deliver stream n)
        (<! (timeout 1)))
      (is (= 0 (<! result-ch)))
      (is (= 2 (<! result-ch)))
      (>! complete true))
    (block-or-done complete)))

(deftest ^:async flatmapping
  (let [complete (chan)
        result-ch (chan)
        stream  (r/event-stream)
        flatmapped (r/flatmap stream (fn [n]
                                       (let [es (r/event-stream)]
                                         (go (doseq [n' (range n)]
                                               (r/deliver es n')
                                               (<! (timeout 1)))
                                             (r/deliver es ::r/complete))
                                         es)))]

    (r/subscribe flatmapped (fn [value]
                              (go (>! result-ch value))))

    (go
      (r/deliver stream 2)
      (<! (timeout 5))
      (r/deliver stream 3)
      (<! (timeout 1))

      (is (= 0 (<! result-ch)))
      (is (= 1 (<! result-ch)))
      (is (= 0 (<! result-ch)))
      (is (= 1 (<! result-ch)))
      (is (= 2 (<! result-ch)))
      (>! complete true))
    (block-or-done complete)))

(deftest ^:async event-stream-from-interval
  (let [complete (chan)
        result-ch (chan)
        stream  (r/from-interval 10)]

    (r/subscribe stream (fn [value]
                          (go (>! result-ch value))))

    (go (<! (timeout 40))
        (r/deliver stream ::r/complete)
        (is (= 0 (<! result-ch)))
        (is (= 1 (<! result-ch)))
        (is (= 2 (<! result-ch)))
        (>! complete true))

    (block-or-done complete)))

(deftest ^:async disposing-subscriptions
  (let [complete  (chan)
        result-ch (chan)
        stream    (r/event-stream)
        tk        (r/subscribe stream (fn [value]
                                        (go (>! result-ch value))))]

    (go (r/deliver stream 42)
        (<! (timeout 1))
        (is (= 42 (<! result-ch)))

        (r/dispose tk)

        (r/deliver stream 43)
        (<! (timeout 1))

        (let [timeout-ch (timeout 10)
              [_ ch] (alts! [result-ch timeout-ch])]
          (is (= ch timeout-ch) "Expected to timeout. Got a value from result-ch instead"))

        (>! complete true))

    (block-or-done complete)))

(deftest behavior-tests
  (testing "deref"
    (let [a (atom 0)
          b (behavior @a)]
      (is (= @b 0))
      (swap! a inc)
      (is (= @b 1)))))

(deftest ^:async behavior-sampling
  (let [complete (chan)
        result-ch (chan)
        a (atom 0)
        b (behavior (swap! a inc))
        stream (r/sample b 10)]


    (r/subscribe stream (fn [value]
                          (go (<! (timeout 1))
                              (>! result-ch value))))
    (go
      (is (= 1 (<! result-ch)))
      (is (= 2 (<! result-ch)))
      (is (= 3 (<! result-ch)))

      (>! complete true))
    (block-or-done complete)))



(comment
  (clojure.test/run-tests 'respondent.core-test)
  )
