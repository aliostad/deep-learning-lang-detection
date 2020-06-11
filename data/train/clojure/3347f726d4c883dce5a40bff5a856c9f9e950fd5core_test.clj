(ns silver.core-test
  (:require [clojure.test :refer :all]
            [silver.core :refer :all]
            [clojure.spec.test :as st])
  (:import (silver.core Order)))

(st/instrument 'silver.core/make-order)
(st/instrument 'silver.core/place-order!)
(st/instrument 'silver.core/cancel-order!)
(st/instrument 'silver.core/get-order-board)

(deftest make-order-test
  (testing "Make an Order"
    ; Switch on instrumentation. This would be enabled only when running
    ; regression tests and disabled in production deployment
    (let [order (make-order {:user "1"
                             :quantity 2M
                             :price 3.236M
                             :type :buy})]
      (is (and (instance? Order order)
               (= order
                  (Order. 1N  "1"  2M  3.236M :buy)))))))

(deftest make-order-spec-type
  (testing "Violate spec"
    (is (thrown? Throwable (make-order {:user "1"
                                        :quantity 2M
                                        :price 3.236M
                                        :type :foo})))))

(deftest make-order-spec-price
  (testing "Violate spec"
    (is (thrown? Throwable (make-order {:user "1"
                                        :quantity 2M
                                        :price -3.236M
                                        :type :sell})))))

(deftest make-order-spec-qty
  (testing "Violate spec"
    (is (thrown? Throwable (make-order {:user "1"
                                        :quantity -2M
                                        :price 3.236M
                                        :type :sell})))))

(defn- place-orders
  [type]
  (place-order!
    (make-order {:user "1"
                 :quantity 5.5M
                 :price 306M
                 :type type}))
  (place-order!
    (make-order {:user "1"
                 :quantity 1.2M
                 :price 310M
                 :type type}))
  (place-order!
    (make-order {:user "1"
                 :quantity 1.5M
                 :price 307M
                 :type type}))
  (place-order!
    (make-order {:user "1"
                 :quantity 2M
                 :price 306M
                 :type type})))

(deftest aggregate-sells
  (testing "Board aggregation and order sells"
    (place-orders :sell)
    (is (= (keys @sells) (sort (keys @sells))))))

(deftest aggregate-buys
  (testing "Board aggregation and order buys"
    (place-orders :buy)
    (is (= (keys @buys) (sort-by - (keys @buys))))))


(defn- generate-random-order
  []
  (make-order {:user "1"
               :quantity (bigdec (+ (rand 10) 1))
               :price (bigdec (+ (rand 300) 1))
               :type (if (zero? (rand-int 2)) :buy :sell)}))

(defn- random-orders
  "Generate n random orders in a vector"
  [n]
  (vec (repeatedly n generate-random-order)))

(defn- concurrency-test
  []
  (let [orders (repeatedly 50000 generate-random-order)
        futures (vec (for [order orders] (future (place-order! order))))
        shuffled (shuffle orders)]
    (doseq [f futures] @f)
    (let [xfutures (vec (for [order shuffled] (future (cancel-order! order))))]
      (doseq [f xfutures] @f)
      ; System should be empty here. We've cancelled all our orders
      ;; though not in the same order as we placed them
      )))

(deftest concurrency-exercise
  (testing "Thrash the order manager for thread safety"
    (concurrency-test)
    (is (and (empty? @orders) (empty? @buys) (empty? @sells)))))

(deftest get-order-board-test
  (testing "Order boards"
    (is (map? (get-order-board :buy)))
    (is (map? (get-order-board :sell)))))

(deftest make-order-spec-price
  (testing "Violate spec"
    (is (thrown? Throwable (get-order-board :foo)))))
