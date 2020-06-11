;;   Copyright (c) Zachary Tellman. All rights reserved.
;;   The use and distribution terms for this software are covered by the
;;   Eclipse Public License 1.0 (http://opensource.org/licenses/eclipse-1.0.php)
;;   which can be found in the file epl-v10.html at the root of this distribution.
;;   By using this software in any fashion, you are agreeing to be bound by
;;   the terms of this license.
;;   You must not remove this notice, or any other, from this software.

(ns lamina.test.trace
  (:use
    [lamina core executor trace]
    [lamina.test utils]
    [clojure test]))

;;;

(defn capture []
  (let [a (atom [])]
    [a
     #(do
        (swap! a conj %)
        true)]))

(defn capture-probe [& names]
  (let [val (promise)
        ch* (channel)]
    (siphon (probe-channel names) ch*)
    (receive ch* #(do (deliver val %) (close ch*)))
    val))

;;;

(def exc (executor {:name :test-executor}))

;;;

(deftest test-canonical-probe-name
  (are [x y] (= x (canonical-probe-name y))
    "a" :a
    "a" "a"
    "a:b" :a:b
    "a:b:c" [:a "b" :c]
    "a:b:c:1:2:3" [:a [:b "c:1"] [2 3]]))

(defn test-probe [f args options probe-type]
  (let [nm (gensym "name")
        probe (probe-channel [nm probe-type])
        [val callback] (capture)
        f (instrument f (assoc options
                          :name nm))]
    (receive-all probe callback)
    (try
      (let [result (apply f args)]
        (if (async-promise? result)
          @result
          result))
      (finally
        (is (not (empty? @val)))))))

(deftest test-enter-probe
  (is (= 3 (test-probe + [1 2] {} :enter)))
  (is (= 45 (test-probe + (range 10) {} :enter)))
  (is (= 3 (test-probe + [1 2] {:executor exc} :enter)))
  (is (= 45 (test-probe + (range 10) {:executor exc} :enter))))

(deftest test-return-probe
  (is (= 3 (test-probe + [1 2] {} :return)))
  (is (= 45 (test-probe + (range 10) {} :return)))
  (is (= 3 (test-probe + [1 2] {:executor exc} :return)))
  (is (= 45 (test-probe + (range 10) {:executor exc} :return))))

(defn boom [& args]
  (throw (Exception.)))

(deftest test-error-probe
  (is (thrown? Exception (test-probe boom [1 2] {} :error)))
  (is (thrown? Exception (test-probe boom (range 10) {} :error)))
  (is (thrown? Exception (test-probe boom [1 2] {:executor exc} :error)))
  (is (thrown? Exception (test-probe boom (range 10) {:executor exc} :error))))

;;;

(defmacro def-cnt [name sub-fn options]
  `(defn-instrumented ~name ~(merge {:capture :in-out} options) [n#]
     (if (zero? n#)
       0
       (run-pipeline (~sub-fn (dec n#))
         inc))))

(def-cnt countdown* countdown* {:name :countdown*})
(def-cnt threaded-countdown* threaded-countdown* {:name :threaded-countdown*, :executor exc})

(declare semi-silent-countdown)
(def-cnt semi-silent-countdown* semi-silent-countdown {:name :countdown})
(def-cnt semi-silent-countdown semi-silent-countdown* {:name ::invisible, :implicit? false})

(def-cnt countdown countdown* {:name :countdown})
(def-cnt threaded-countdown threaded-countdown* {:name :countdown, :executor exc})

(defn timing-seq [t]
  (tree-seq
    (comp seq :sub-tasks)
    :sub-tasks
    t))

(defn test-capture [f initial-value]
  (let [val (capture-probe :countdown :return)]
    (f initial-value)
    (->> @val
      timing-seq)))

(deftest test-nested-tasks
  (let [arg-seq #(->> % (map :args) (apply concat))
        name-seq #(map :name %)]
    (is (= [2 1 0] (arg-seq (test-capture countdown 2))))
    (is (= "countdown" (first (name-seq (test-capture countdown 2)))))
    (is (= [2 1 0] (arg-seq (test-capture threaded-countdown 2))))
    (is (= "countdown" (first (name-seq (test-capture threaded-countdown 2)))))
    (is (= [0] (arg-seq (test-capture semi-silent-countdown 1))))
    (is (= "countdown" (first (name-seq (test-capture semi-silent-countdown 1)))))
    ))

(deftest test-distilled-timing

  (let [t (distill-timing (first (test-capture countdown 2)))]
    (is (= "countdown" (-> t :task)))
    (is (= "countdown*" (-> t :sub-tasks first :task)))
    (is (= "countdown*" (-> t :sub-tasks first :sub-tasks first :task))))

  (let [t (->> (test-capture countdown 2)
            first
            (repeat 10)
            (map distill-timing)
            (reduce conj!))]
    
    (is (= "countdown" (-> t :task)))
    (is (= "countdown*" (-> t :sub-tasks first :task)))
    (is (= "countdown*" (-> t :sub-tasks first :sub-tasks first :task)))))

(deftest test-trace-counters
  (let [timing (with-instrumentation
                 (increment-trace-counter :foo)
                 (increment-trace-counter :foo)
                 (increment-trace-counter :bar))
        distilled (distill-timing timing)]
    (is (= {:foo 2 :bar 1} (:counts timing) (:counts distilled)))
    (is (= {:foo 20 :bar 10} (->> timing
                               (repeat 10)
                               (map distill-timing)
                               (reduce conj!)
                               :counts)))))

(def ^{:dynamic true} n 10)

(defn-instrumented unbound-add
  {:executor exc}
  [& [x]]
  (+ x n))

(defn-instrumented bound-add
  {:executor exc
   :with-bindings? true}
  [x]
  (+ x n))

(deftest test-with-bindings
  (is (= 11 @(unbound-add 1)))
  (is (= 11 @(bound-add 1)))
  (is (= 11 @(binding [n 100] (unbound-add 1))))
  (is (= 101 @(binding [n 100] (bound-add 1)))))

;;;

(deftest test-add-sub-timing
  (is (= [{1 2, :sub-tasks [{:sub-tasks [], 3 4}]}]
        (:sub-tasks
          (with-instrumentation
            (add-sub-timing {1 2})
            (add-to-last-sub-timing {3 4}))))))

;;;

(defn benchmark-active-probe [description probe]
  (let [nm (gensym "name")
        p (probe-channel [nm probe])
        f (instrument + {:name nm})
        callback (fn [x] )]
    (receive-all p callback)
    (bench description
      (f 1 1))
    (cancel-callback p callback)))

(deftest ^:benchmark benchmark-instrument
  (bench "baseline addition"
    (+ 1 1 1))
  (bench "baseline addition with apply"
    (apply + [1 1 1]))
  (let [f (instrument + {:name :foo})]
    (bench "instrument addition with one arg"
      (f 1)))
  (let [f (instrument + {:name :foo})]
    (bench "instrument addition with three args"
      (f 1 1 1)))
  (let [f (instrument + {:name :foo})]
    (bench "instrument addition with five args"
      (f 1 1 1 1 1)))
  (benchmark-active-probe "instrument addition with return probe" :return)
  (benchmark-active-probe "instrument addition with enter probe" :enter))

;;;

