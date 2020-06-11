(ns closure-test
  (:use [clojure.test]
	[clojure.contrib reflect])
  (:use [lein-js.closure] :reload-all)
  (:import [com.google.javascript.jscomp CompilerOptions]))

(defn- option-field
  [instance field]
  (get-field CompilerOptions field instance))

(deftest test-default-compiler-options
  (let [o (make-compiler-options default-options "output")]
    (is (= (option-field o "prettyPrint")
	   (:pretty-print default-options)))
    (is (= (option-field o "printInputDelimiter")
	   (:print-input-delimiter default-options)))
    (is (= (option-field o "closurePass")
	   (:process-closure-primitives default-options)))
    (is (= (option-field o "manageClosureDependencies")
	   (:manage-closure-deps default-options)))
    (is (= (option-field o "summaryDetailLevel")
	   ((:summary-detail default-options) summary-details)))
    (is (= (type (option-field o "codingConvention"))
	   ((:coding-convention default-options) coding-conventions)))))
