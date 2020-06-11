(ns spede.restore-defn-arglist
  (:require  [clojure.test :as t]
             [spede.defn :as defn]
             [spede.core :as sd]
             [clojure.spec :as s]
             [clojure.spec.test :as st]
             [spede.test-utils :as tu])
  (:import clojure.lang.ExceptionInfo))

(t/deftest restore-arglist
  (t/is (= [`a `b] (defn/make-vanilla-arg-list [`a ::ugh `b ::agh])))
  (t/is (= [[`a] `b] (defn/make-vanilla-arg-list [[`a ::ugh] `b ::agh])))
  (t/is (= [[`a] `b {`c ::c}] (defn/make-vanilla-arg-list [[`a ::ugh] `b {`c ::c}]))))

(s/def ::a-spec integer?)
(s/def ::b-spec double?)

(sd/sdefn fun [a ::a-spec b ::b-spec]
  (* a b))

(sd/sdefn fun-2 [a ::a-spec & b ::a-spec]
  (map #(* a %) b))

(st/instrument [`fun
                `fun-2])

(t/deftest rest-specced
  (t/is (= [2 4 6] (fun-2 2 1 2 3)))
  (t/is (thrown-with-msg? ExceptionInfo tu/spec-err
                          (fun-2 2 1 2 3.0))))

(t/deftest arglist-spec
  (t/is (= 1.5 (* 3 0.5))))

(t/deftest speccin
  (t/is (thrown-with-msg? ExceptionInfo tu/spec-err
                          (fun 2.0 "asdf")))
  (t/is (thrown-with-msg? ExceptionInfo tu/spec-err
                          (fun 2 2))))

(sd/sdefn fun-ma
  ([a ::a-spec] (* a a))
  ([a ::a-spec b ::b-spec] (* a b)))

(st/instrument `fun-ma)

(t/deftest arglist-spec-multi-arity
  (t/is (= 4 (fun-ma 2)))
  (t/is (= 4.0 (fun-ma 2 2.0))))

(t/deftest or-names
  (t/is (= :1-arid (-> `fun-ma
                       s/get-spec
                       s/form
                       (nth 2)
                       second))))

(t/deftest multi-arity-speccin
  (t/is (thrown-with-msg? ExceptionInfo tu/spec-err
                          (fun-ma 2.0)))
  (t/is (thrown-with-msg? ExceptionInfo tu/spec-err
                          (fun-ma 2 2))))

(sd/sdefn fun-nested
  [[a ::a-spec] b ::b-spec] (* a b))

(st/instrument `fun-nested)

(t/deftest arglist-spec-multi-arity
  (t/is (= 4.0 (fun-nested [2] 2.0))))


(t/deftest multi-arity-speccin
  (t/is (thrown-with-msg? ExceptionInfo tu/spec-err
                          (fun-nested [2.0] 2.0)))
  (t/is (thrown-with-msg? ExceptionInfo tu/spec-err
                          (fun-nested 2 2))))
