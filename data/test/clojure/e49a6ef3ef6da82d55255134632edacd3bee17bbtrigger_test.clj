(ns rill.wheel.trigger-test
  (:require [clojure.test :refer [deftest testing is use-fixtures]]
            [rill.wheel :refer [defcommand defevent defaggregate ok?]]
            [rill.wheel.testing :refer [ephemeral-repository sub? with-instrument-all]]
            [rill.wheel.trigger :refer [install-trigger]]))

(use-fixtures :once with-instrument-all)

(defaggregate turnstile
  [turnstile-id])

(defevent locked ::turnstile
  [turnstile]
  (-> turnstile
      (update :locks (fnil inc 0))
      (assoc :locked true)))

(defevent unlocked ::turnstile
  [turnstile]
  (assoc turnstile :locked false))

(defcommand unlock ::turnstile
  [turnstile]
  (unlocked turnstile))

(defevent turned ::turnstile
  [turnstile]
  (update turnstile :turns (fnil inc 0)))

(defcommand push ::turnstile
  [turnstile]
  (if (:locked turnstile)
    turnstile
    (-> turnstile
        (turned)
        (locked))))

(defaggregate slot
  [slot-id turnstile-id])

(defevent coin-inserted ::slot
  [slot]
  (update slot :coins-inserted (fnil inc 0)))

(defcommand pay ::slot
  [slot]
  (coin-inserted slot))

(def calls (atom 0))

(install-trigger ::coin-inserted ::turnstile
                 (fn [repo slot event]
                   (swap! calls inc)
                   (unlock! repo (:turnstile-id slot))))

(deftest test-install-trigger
  (let [repo (ephemeral-repository)]
    (is (ok? (push! repo 1)))
    (is (ok? (push! repo 1)))
    (is (sub? {:turns  1
               :locked true}
              (get-turnstile repo 1)))
    (is (zero? @calls))
    (is (ok? (pay! repo 2 1)))
    (is (= 1 @calls))
    (is (sub? {:turns  1
               :locked false}
              (get-turnstile repo 1)))
    (is (ok? (push! repo 1)))
    (is (sub? {:turns  2
               :locked true}
              (get-turnstile repo 1)))
    (is (ok? (pay! repo 2 1)))
    (is (sub? {:turns  2
               :locked false}
              (get-turnstile repo 1)))))
