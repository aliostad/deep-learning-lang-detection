(ns user
  (:require
    [clojure.spec.alpha :as s]
    [clojure.spec.test.alpha :as st]
    [clojure.spec.gen.alpha :as g]
    [clojure.java.io :as io]
    [clojure.test :as t :refer [deftest is]]))

;; A function
(defn filtered-file-seq
  "Return a seq of all the files in the given directory, subject to the given
   predicate."
  [dir pred]
  (filter pred (file-seq dir)))

;; Example-based test
(deftest test-filtered-file-seq
  (let [dir (io/file "./test")
        clojure-file? #(.endsWith (.getName %) ".clj")
        clojure-files (filtered-file-seq dir clojure-file?)]
    (is (= 2 (count clojure-files)))))


;; Goal: Spec this function, and validate our usage of it in the example-based test.

;; We do *not* want to do generative testing in this case, because we don't want
;; to have to write a file generator or create a ton of files.

(s/def ::directory #(and (instance? java.io.File %)
                         (.isDirectory %)))

(s/def ::file #(instance? java.io.File %))

(s/def ::file-predicate
  (s/fspec :args (s/cat :file ::file)
           :ret any?))

(s/fdef filtered-file-seq
  :args (s/cat :dir ::directory
               :pred ::file-predicate)
  :ret (s/coll-of ::file))


(comment

  (st/instrument)
  (t/run-tests)
  ;;=> clojure.lang.ExceptionInfo: Unable to construct gen at: [:file] for: :user/file

  ;; Gen override does not appear to be used...
  (st/instrument {:gen {::file-predicate (g/return (constantly true))}})
  (t/run-tests)
  ;;=> clojure.lang.ExceptionInfo: Unable to construct gen at: [:file] for: :user/file


  ;; Cannot override spec, (instrument {:spec ..}) can only override by symbol name, not by spec name.

  ;; What now?

  )
