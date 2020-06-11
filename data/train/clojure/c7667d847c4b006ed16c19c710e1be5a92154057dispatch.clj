(ns laeggen.test.dispatch
  (:require [clojure.test :refer :all]
            [laeggen.dispatch :as dispatch]
            [laeggen.views :as views]))

(defn index [& args]
  (conj args "index"))

(defn foo [& args]
  (conj args "foo"))

(defn bar [& args]
  (conj args "bar"))

(deftest test-basic-url-dispatch
  (let [urls (dispatch/urls
              #"^/$" index
              #"^/foo$" foo)]
    (is (= index (dispatch/find-match urls "/")))
    (is (= foo (dispatch/find-match urls "/foo")))
    (is (nil? (dispatch/find-match urls "/missing")))))

(deftest test-merge-urls
  (let [urls (dispatch/merge-urls
              views/default-urls
              (dispatch/urls
               #"^/$" index
               #"^/foo$" foo))]
    (is (= index (dispatch/find-match urls "/")))
    (is (= foo (dispatch/find-match urls "/foo")))
    (is (nil? (dispatch/find-match urls "/missing")))
    (is (= views/handler404 (dispatch/find-match urls :404)))
    (is (= views/handler500 (dispatch/find-match urls :500)))
    (is (nil? (dispatch/find-match urls :600)))))

(deftest test-pattern-capture
  (let [urls (dispatch/urls
              #"^/(\d+)/$" index
              #"^/foo$" foo
              #"^/([^/]+)/$" foo)]
    (is (= ["index" nil "4"] ((dispatch/find-match urls "/4/") nil)))
    (is (= foo (dispatch/find-match urls "/foo")))
    (is (nil? (dispatch/find-match urls "/missing")))
    (is (= ["foo" nil "NOT missing"]
           ((dispatch/find-match urls "/NOT missing/") nil)))))

(deftest test-precedence
  (testing "patterns that occur first have higher priority"
    (let [urls (dispatch/urls
                #"^/$" index
                #"^/foo$" foo
                #"^/foo$" index
                #"^/$" foo)]
      (is (= index (dispatch/find-match urls "/")))
      (is (= foo (dispatch/find-match urls "/foo")))
      (is (nil? (dispatch/find-match urls "/missing"))))))

(deftest test-grouping
  (let [urls (dispatch/urls
              [#"^/a/b/$" #"/a/b/c/" #"/a/b/c/d/"] index
              #"^/foo$" foo)]
    (is (= index (dispatch/find-match urls "/a/b/")))
    (is (= index (dispatch/find-match urls "/a/b/c/")))
    (is (= index (dispatch/find-match urls "/a/b/c/d/")))
    (is (= foo (dispatch/find-match urls "/foo")))
    (is (nil? (dispatch/find-match urls "/missing")))))

(deftest test-grouping-precedence
  (let [urls (dispatch/urls
              #"^/$" index
              [#"^/$" #"^/foo/$"] foo
              #"^/$" foo
              [#"^/$" #"^/bar/$" #"^/foo/$"] bar)]
    (is (= index (dispatch/find-match urls "/")))
    (is (= foo (dispatch/find-match urls "/foo/")))
    (is (= bar (dispatch/find-match urls "/bar/")))
    (is (nil? (dispatch/find-match urls "/missing")))))
