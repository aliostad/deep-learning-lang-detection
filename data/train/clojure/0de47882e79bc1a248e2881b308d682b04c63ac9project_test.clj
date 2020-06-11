(ns ^{:author "Adam Berger"} ulvm.project-test
  "Project tests"
  (:require [clojure.spec.test :as st]
            [ulvm.core :as ulvm]
            [ulvm.reader :as uread]
            [ulvm.project :as uprj]
            [ulvm.mod-combinators]
            [ulvm.re-loaders]
            [cats.core :as m]
            [cats.monad.either :as e])
  (:use     [clojure.test :only [is deftest]]))

(def flowfile-example
  `[(ulvm/defmodcombinator :mvn
      "Description of mvn combinator"
      {:ulvm.core/runnable-env-ref
       {:ulvm.core/runnable-env-loader-name :http
        :ulvm.core/runnable-env-descriptor {:url "http://ulvm.org/loaders/mvn.ulvm"}}})

    (ulvm/defrunnableenvloader :http
      {:ulvm.core/runnable-env-ref
       {:ulvm.core/builtin-runnable-env-loader-name :ulvm.re-loaders/project-file
        :ulvm.core/runnable-env-descriptor {:path "re-loaders/http.ulvm"}}})

    (ulvm/defscope :my-scope
      "Description of scope"
      {:ulvm.core/runnable-env-ref
       {:ulvm.core/builtin-runnable-env-loader-name :ulvm.core/project-file
        :ulvm.core/runnable-env-descriptor {:path "scopes/nodejs.ulvm"}}
       :ulvm.core/modules {:adder {:ulvm.core/mod-combinator-name :mvn
                                   :ulvm.core/mod-descriptor {:name "my-adder"}}
                           :db-saver {:ulvm.core/mod-combinator-name :mvn
                                      :ulvm.core/mod-descriptor {:name "my-db-saver"}}}
       :ulvm.core/init ((adder {:v1 42} :as my-adder))})

    (ulvm/defflow :simple []
      ; this flow's result has g as its error value and c as its default return value
      {:ulvm.core/output-descriptor {:err [g], :ret [c]}}
      ; invoke module A in scope-1 with no args, result is named 'a
      ((:A scope-1) {} :as a)
      ; invoke module B in scope-2 with arg-1 set to the default return of a, result is named 'b
      ((:B scope-2) {:arg-1 a} :as b)
      ; invoke module C in scope-1 with val set to the default return of a, result is named 'c
      ((:C scope-1) {:val a} :as c)
      ; invoke module G in scope-1 with first-val set to the other-ret return of a
      ((:G scope-1) {:first-val (:other-ret a)})
      ; invoke module D in scope-2 with v1 set to the default return of b and v2 set to the default return of c
      ((:D scope-2) {:v1 b, :v2 c}))

    (ulvm/defflow :err-handling []
      ; this flow's result has g as its error value and c as its default return value
      {:ulvm.core/output-descriptor {:err [g], :ret [c]}}
      ; invoke module A in scope-1 with no args, result is named 'a
      ((:A scope-1) {} :as a)
      ; v1 and c are calculated iff a returns a default result
      ((:B scope-1) {:the-val a} :as v1)
      ((:C scope-1) {:val-1 a, :val-2 v1} :as c)
      ; g is calculated iff a returns an error
      ((:log-err scope-1) {:err (:err a)} :as g))

    (ulvm/defflow :err-recovery []
      ; this flow's result has c as its default return value
      {:ulvm.core/output-descriptor {:ret [c]}}
      ; invoke module A in scope-1 with no args, result is named 'a
      ((:A scope-1) {} :as a)
      ; log and b are calculated iff a returns an error
      ((:log-err scope-1) {:err (:err a)} :as log)
      ((:B scope-1) {} :as b :after log))])

(deftest get-mod-combinator
  (st/instrument (st/instrumentable-syms ['ulvm 'uprj]))
  (let [ents (uread/eval-ulvm-seq flowfile-example)
        prj {:entities        ents
             :mod-combinators {}
             :renv-loaders    {}
             :renvs           {}
             :env             {::ulvm/project-root "examples/toy"}}
        {p :prj} (uprj/get prj :mod-combinators :mvn)]
    (is (= 1 (count (:mod-combinators p))))
    (is (every? #(e/right? (second %)) (:mod-combinators p)))
    (is (= 2 (count (:renv-loaders p))))
    (is (every? #(e/right? (second %)) (:renv-loaders p)))
    (is (= 2 (count (:renvs p))))
    (is (every? #(e/right? (second %)) (:renvs p)))))

(deftest resolve-env-refs-ok
  (st/instrument (st/instrumentable-syms ['ulvm 'uprj]))
  (let [prj {:entities        {}
             :mod-combinators {}
             :renv-loaders    {}
             :renvs           {}
             :env             {:my-val :wrong
                               :my {:ctx (e/right {:my-val :right})}}}
        to-resolve {:a '(ulvm.core/from-env :my-val)}
        resolved (uprj/resolve-env-refs prj [:my :ctx] to-resolve)]
    (is (e/right? resolved))
    (is (= {:a :right} (m/extract resolved)))))

(deftest resolve-env-refs-err
  (st/instrument (st/instrumentable-syms ['ulvm 'uprj]))
  (let [prj {:entities        {}
             :mod-combinators {}
             :renv-loaders    {}
             :renvs           {}
             :env             {:my-val :wrong
                               :my {:ctx (e/left 4)}}}
        to-resolve {:a '(ulvm.core/from-env :my-val)}
        resolved (uprj/resolve-env-refs prj [:my :ctx] to-resolve)]
    (is (e/left? resolved))))

(deftest selective-eval
  (st/instrument (st/instrumentable-syms ['ulvm 'uprj]))
  (let [prj {:entities        {}
             :mod-combinators {}
             :renv-loaders    {}
             :renvs           {}
             :env             {}}
        to-eval {:a '(ulvm.core/eval (str "hello" " " "world"))}
        evaled (uprj/selective-eval prj to-eval)]
    (is (e/right? evaled))
    (is (= {:a "hello world"} (m/extract evaled)))))
