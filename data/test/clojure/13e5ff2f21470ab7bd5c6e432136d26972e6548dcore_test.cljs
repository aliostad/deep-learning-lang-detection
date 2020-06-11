(ns konserve-firebase.core-test
  (:require
    [konserve-firebase.test-env :refer [prefix]]
    [konserve-firebase.helpers :as h]
    [konserve-firebase.core :as c]
    [konserve-firebase.test.helpers :refer [go-async-timeoutable]]
    [cljs.test :refer-macros [deftest testing is async use-fixtures]]
    [superv.async :refer [S take? alt? go-try <?]]
    [cljs.core.async :refer [put! chan <! >! timeout close! take! alts!]]))


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

;; Test Serialization
;; ------------------

(deftest check-path-conversion
  ;; Simple path makes sense in firebase lingua
  (is (= "a/b/c" (c/->path ["a" "b" "c"])))
  ;; Keywords are different from simple strings
  (is (not= "a/b/c" (c/->path [:a "b" :c])))
  ;; Forbid slashes already in the paths, this could be
  ;; be a mistake and a source for troubles.
  (is (thrown? js/Error (c/->path ["a/a/a"]))))

(deftest simple-serialization
  (testing "encode back and forth is idempotent"
    ;; Note that we use `rec' because encoding works with javascript
    ;; objects.
    (let [back&forth #(-> % c/-frb-encode-rec c/-frb-decode-rec)]
      (is (= 12 (back&forth 12)))
      (is (= {1 2} (back&forth {1 2}))))))


;; Firebase I/Os
;; -------------

(deftest get-a-value-from-an-empty-firebase
  (go-async-timeoutable S 10000
    (let [v (<? S (c/get! @db (str @test-id "none")))]
      (is (= :nil v)))))

(deftest test-assoc-in
  (let [X (rand-int 100000)]
    (go-async-timeoutable S 10000
      (<? S (c/assoc-in! @db [prefix "core" @test-id "some-path"] X))
      (is (= X (<? S (c/get-in! @db [prefix "core" @test-id "some-path"])))))))


;; Test Encoding
;; -------------

(defmacro do-test-in-and-out [db name value]
  `(let [db# ~db
         name# ~name
         value# ~value]
     (<? S (c/assoc-in! db# [prefix "core" @test-id name#] value#))
     (is (= value# (<? S (c/get-in! db# [prefix "core" @test-id name#]))))))

(deftest test-assoc-in-edn-types-keyword
  (go-async-timeoutable S 10000
    (do-test-in-and-out @db "keyword" :some-value)))

(deftest test-assoc-in-edn-types-maps
  (go-async-timeoutable S 10000
    (do-test-in-and-out @db "maps" {:key :value :another-key "value" "42" 42})))

(deftest test-assoc-in-edn-types-nested-maps
  (go-async-timeoutable S 10000
    (do-test-in-and-out @db "nested-maps" {:a :b :c 12 :d [1 2 {:k 4 "k" 7}]})))

(deftest test-assoc-in-edn-types-vectors
  (go-async-timeoutable S 10000
    (do-test-in-and-out @db "nested-vectors" [:key 2 :again "yes again"])))

(deftest test-dissoc-in
  (go-async-timeoutable S 10000
    (<? S (c/assoc-in! @db [prefix "core" @test-id "dissocable"] 54))
    (<? S (c/dissoc-in! @db [prefix "core" @test-id "dissocable"]))
    (is (= :nil (<? S (c/get-in! @db [prefix "core" @test-id "dissocable"]))))))

(deftest test-update-in
  (go-async-timeoutable S 20000
    (<? S (c/assoc-in! @db [prefix "core" @test-id "updatable"] {:k 234}))
    (<? S (c/update-in! @db [prefix "core" @test-id "updatable" :k] inc))
    (is (= {:k 235} (<? S (c/get-in! @db [prefix "core" @test-id "updatable"]))))))

(deftest test-assoc-throws-invalid-paths
  (go-async-timeoutable S 20000
    (try
      ;; I'd like to use (is (thrown? js/Error ...))
      ;; but doo would fail with (not (isinstance? js/Error ...))
      ;; which is unbelievable.
      (c/assoc-in! @db [prefix "core" @test-id "throwable/should/fail"] {:k 234})
      (is false "should have thrown")
      (catch js/Error
             (is true "has thrown")))))