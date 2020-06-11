(ns konserve-firebase.store-test
  (:require
    [konserve-firebase.test-env :refer [prefix]]
    [konserve-firebase.helpers :as h]
    [konserve-firebase.test.helpers :refer [go-async-timeoutable]]
    [konserve-firebase.store :refer [new-firebasedb-store]]
    [konserve.core :as k]
    [superv.async :refer [S <?]]
    [cljs.test :refer-macros [deftest testing is async use-fixtures]]))

;; Setup
;; -----

(defonce test-id (atom ""))
(defonce firebase-app (atom nil))
(defonce db (atom nil))

;; Manage the `firebase-app' and the firebase `db' atoms.
(use-fixtures :once
  {:before
   (fn []
     (reset! test-id (h/make-test-id))
     (reset! firebase-app (h/start-firebase!))
     (reset! db (h/make-db)))
   :after
   (fn []
     (async done
       (h/stop-firebase! @firebase-app #(done))))})


;; Tests
;; -----

(deftest retrieve-a-firebase-store
  (testing "When I build a firebase store, I'll get something"
    (go-async-timeoutable S 20000
      (let [store (<? S (new-firebasedb-store @db))]
        (is (not (nil? store)))))))

(deftest assoc-then-get-simple
  (testing "When I use the konserve store API to write a value, I can retrieve it later."
    (go-async-timeoutable S 20000
      (let [store (<? S (new-firebasedb-store @db
                                              :prefix [prefix "store" @test-id "basic"]))]
        (<? S (k/assoc-in store [:a] "a"))
        (is (= "a" (<? S (k/get-in store [:a]))))
        (is (nil? (<? S (k/get-in store [:b]))))))))

(deftest assoc-then-get-complex
  (testing "When I write a map with submaps and vectors, I can't retrieve the same value later"
    (go-async-timeoutable S 20000
      (let [store (<? S (new-firebasedb-store @db
                                              :prefix [prefix "store" @test-id "complex-values"]))]
        (<? S (k/assoc-in store [:x] {:a 1 :b 2 "c" 4 :k {:sub 1 "2" [:some "vector"]}}))
        (is (= 1 (<? S (k/get-in store [:x :a]))))
        (is (= {:sub 1 "2" [:some "vector"]}
               (<? S (k/get-in store [:x :k]))))
        (is (= {:a 1 :b 2 "c" 4 :k {:sub 1 "2" [:some "vector"]}}
               (<? S (k/get-in store [:x]))))))))

(deftest update-then-get
  (testing "When I do an update using a function, I'll see the value change on the next get"
    (go-async-timeoutable S 20000
      (let [store (<? S (new-firebasedb-store @db
                                              :prefix [prefix "store" @test-id "messy"]))]
        (<? S (k/assoc-in store [:x] {:a 1 :b 2 "c" 4 :k {:sub 1 "2" [:some "vector"]}}))
        (<? S (k/update-in store [:x :k :sub] inc))
        (<? S (k/update-in store [:x :k "2"] (fn [x] (into [] (conj x 42)))))
        (is (= 2 (<? S (k/get-in store [:x :k :sub]))))
        (is (= {:sub 2 "2" [:some "vector" 42]}
               (<? S (k/get-in store [:x :k]))))))))

(deftest test-logs
  (testing "When I append a log with some complex values, I can list them later"
    (go-async-timeoutable S 30000
      (let [store (<? S (new-firebasedb-store @db :prefix [prefix "store" @test-id "test-logs"]))]
        (<? S (k/append store :some-log {:my-elem 1}))
        (is (= [{:my-elem 1}]
               (<? S (k/log store :some-log))))))))

; TODO: make it pass
;(deftest test-invalid-path
;  (testing "When I try to write something with an incorrect path it'll raise an error"
;    (go-async-timeoutable S 30000
;      (let [store (<? S (new-firebasedb-store @db :prefix [prefix "store" @test-id "test-logs"]))
;            x (k/assoc-in store ["a/b"] {:my-elem 1})]
;        (try
;          ;; (is (thrown? js/Error (<? S x)))
;          (is (nil? (<? S x)))
;          (is false "should have thrown")
;          (catch js/Error e
;            (is true "did throw")))))))
