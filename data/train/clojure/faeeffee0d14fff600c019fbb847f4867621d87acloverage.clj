(ns leiningen.style.cloverage
  (:require [leiningen.core.eval :as leval]
            [leiningen.core.project :as lproject]
            [bultitude.core :as blt]
            [leiningen.core.eval :refer [eval-in-project]]
            [leiningen.style.errors :refer [make-error]]
            [leiningen.style.utils :refer [with-muted-output]]
            [leiningen.style.printing :refer [colorize]]
            [clojure.set :as set]))

(defn ns-names-for-dirs [dirs]
  (map name (mapcat blt/namespaces-in-dir dirs)))

(defn run
  "Produce test coverage report for some namespaces"
  [project source-namespaces test-namespaces]
  (let [project  (lproject/merge-profiles project [{:dependencies [['cloverage "1.0.6"]]}])
        project (assoc  project :eval-in :classloader)]
    (leval/eval-in-project
     project
     `(let [namespaces#  (quote ~source-namespaces) ;(clojure.set/difference (into #{} ~source-namespaces))
            test-nses# (quote ~test-namespaces)]
        (binding [*ns* (find-ns 'cloverage.coverage)
                  cloverage.debug/*debug* false]
          (doseq [namespace# (cloverage.dependency/in-dependency-order (map symbol namespaces#))]
            (binding [cloverage.coverage/*instrumented-ns* namespace#]
              (try
                (cloverage.instrument/instrument (var cloverage.coverage/track-coverage) namespace#)
                (catch Throwable ex# (print "!"))))
            (cloverage.coverage/mark-loaded namespace#))
          (do (when-not (empty? test-nses#)
                (let [test-syms# (map symbol test-nses#)]
                  (try
                    (apply require (map symbol test-nses#))
                    (apply clojure.test/run-tests (map symbol test-nses#))
                    (catch Throwable ex# (print "!")))))
              (let [results# (cloverage.report/gather-stats (deref cloverage.coverage/*covered*))]
                (cloverage.report/total-stats results#)))))
     '(do (require 'cloverage.coverage)
          (require 'cloverage.instrument)
          (require 'cloverage.dependency)
          (require 'cloverage.report)
          (require 'cloverage.debug)
          (require 'clojure.test)))))

(defn check [project & args]
  (try (let [min-coverage (get-in project [:clj-style :min-coverage])
             source-namespaces (ns-names-for-dirs (:source-paths project))
             test-namespaces    (ns-names-for-dirs (:test-paths project))]
         (let [results (with-muted-output (run project source-namespaces test-namespaces))
               min-coverage (or min-coverage 90)
               percent-covered (:percent-lines-covered results)]
           (if (< percent-covered min-coverage)
             [(make-error ""
                          :cloverage
                          "test coverage"
                          (str "Total line coverage (" (colorize (str percent-covered "%") :red) ") not reaching minimum of " min-coverage "%"))]
             [])))
       (catch Exception ex (do (println ex) (print (colorize "!" :red))[]))))
