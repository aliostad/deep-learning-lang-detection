(ns lambda-ski-iota.lambda-to-ski-translator-test
  (:require [clojure.test :refer :all]
            [lambda-ski-iota.lambda-to-ski-translator :refer :all]))


(deftest translate-application-test-1
(testing "translate-application"
(is (= (translate-application '(u x y z)) '(((u x) y) z)))
))


(deftest contains-var?-test-1
(testing "contains-var?"
(is (contains-var? 'x '((u) (i, (x, y)) z)))
))

(deftest contains-var?-test-2
(testing "contains-var?"
(is (contains-var? 'x 'x))
))

(deftest contains-var?-test-3
(testing "contains-var?"
(is (contains-var? 'x '(K x)))
))

(deftest contains-var?-test-4
(testing "contains-var?"
(is (not (contains-var? 'x '((u) (i) z))))
))


(deftest translate-dispatch-test-1
(testing "translate-dispatch"
(is (= (translate-dispatch 's) 's))
))

(deftest translate-dispatch-test-2
(testing "translate-dispatch"
(is (= (translate-dispatch '(fn [x] x)) 'I))
))

(deftest translate-dispatch-test-3
(testing "translate-dispatch"
(is (= (translate-dispatch '(fn [x] y)) '(K y)))
))

(deftest translate-dispatch-test-4
(testing "translate-dispatch"
(is (= (translate-dispatch '(fn [x] (fn [y] x))) '(S (K K) I)))
))

(deftest translate-dispatch-test-5
(testing "translate-dispatch"
(is (= (translate-dispatch '(fn [x] (fn [y] y))) '(K I)))
))

(deftest translate-dispatch-test-6
(testing "translate-dispatch"
(is (= (translate-dispatch '(s1 s2)) '(s1 s2)))
))

(deftest translate-dispatch-test-7
(testing "translate-dispatch"
(is (= (translate-dispatch '(fn [x] 2)) '(K 2)))
))

(deftest translate-dispatch-test-8
(testing "translate-dispatch"
(is (= (translate-dispatch '(fn [x] (x (fn [z] z)))) '(S I (K I))))
))

(deftest translate-dispatch-test-9
(testing "translate-dispatch"
(is (= (translate-dispatch '(fn [x] (fn [y] (y x)))) '(S (K (S I)) (S (K K) I))))
))

(deftest translate-dispatch-test-10
(testing "translate-dispatch"
(is (= (translate-dispatch '(fn [x y]  (y x))) '(S (K (S I)) (S (K K) I))))
))

(deftest translate-dispatch-test-11
(testing "translate-dispatch"
(is (= (translate-dispatch '(fn [x] (fn [y] (x y)))) '(S (S (K S) (S (K K) I)) (K I))))
))


(deftest translate-dispatch-test-12
(testing "translate-dispatch"
(is (= (translate-dispatch '(fn [x y z] 5)) '(K (K (K 5)))))
))

(def tm {'x '(1 2 3), 'y  'yy, 'yy '(4 5 6), 'y* '(7 8 9), 'z? '(10 11 12)})
(def fd '(x (y [z yy x-x u y* yy* yy*x x z?])))

(deftest get-symbols-to-substitute-test-1
(testing "get-symbols-to-substitute"
(is (= (get-symbols-to-substitute tm fd) #{'x 'y 'y* 'yy 'z?}))
))

(deftest substitute-translations-test-1
(testing "substitute-translations"
(is (= (substitute-translations tm fd) '((1 2 3) ((4 5 6) [z (4 5 6) x-x u (7 8 9) yy* yy*x (1 2 3) (10 11 12)]))))
))


(run-tests)
