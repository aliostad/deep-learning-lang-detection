(ns test.css-selector
  (:use [clojure.test :only [deftest is]])
  (:require css-selector))

(defn input-stream [string] (java.io.ByteArrayInputStream. (.getBytes string "utf-8")))


(deftest tag-name-only
  (is (= 1 (count (css-selector/query "name" (input-stream "<name/>")))))
  (is (= 0 (count (css-selector/query "name" (input-stream "<noname/>")))))
  (is (= 2 (count (css-selector/query "name" (input-stream "<stuff><name/><name/></stuff>"))))))

(deftest tag-name-with-class
  (is (= 1 (count (css-selector/query "name.red" (input-stream "<stuff><name class=\"blue\"/><name class=\"red\"/></stuff>")))))
  (is (= 0 (count (css-selector/query "name.red" (input-stream "<stuff><noname class=\"blue\"/><noname class=\"red\"/></stuff>"))))))

(deftest class-only
  (is (= 1 (count (css-selector/query ".red" (input-stream "<stuff><name class=\"blue\"/><name class=\"red\"/></stuff>"))))))

(deftest hierarchial-name
  (is (= 0 (count (css-selector/query "description name" (input-stream "<name/>")))))
  (is (= 1 (count (css-selector/query "description name" (input-stream "<description><name/></description>"))))))


(clojure.test/run-tests 'test.css-selector)
