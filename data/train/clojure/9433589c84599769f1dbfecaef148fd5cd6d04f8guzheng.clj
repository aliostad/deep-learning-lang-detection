(ns leiningen.guzheng
  (:use bultitude.core)
  (:use clojure.pprint)
  (:require leiningen.test)
  (:use robert.hooke)
  (:require [clojure.java.io :as io])
  (:import (java.io PushbackReader)))

(def ^ {:private true :const :true}
  guzheng-version
  ['guzheng "1.2.5"])

(def ^:private hooke-injection
  (with-open [rdr  (-> "robert/hooke.clj" io/resource io/reader PushbackReader.)]
    `(do (ns ~'lein-guzheng.core.injected)
       ~@(doall (take 6 (rest (repeatedly #(read rdr)))))
       (ns ~'user))))

(defn- split-ns-subtask
  "Takes the namespaces followed by \"--\" followed
  by the leiningen command to run with an instrumented
  eval-in-project."
  [args]
  (let [[nses subtask] (split-with #(not= "--" %) args)]
    [(map symbol nses) subtask]))

(defn- instrument-form
  "Takes the form to be wrapped with the
  guzheng data collector and result displayer.
  This uses a shutdown hook in the JVM in order to be
  portable-ish between lein1 and lein2. This may
  cause problems if there is tons of missing coverage."
  [form nses lein2?]
  (let [libspecs-sym (gensym "libspecs")
        nses (map str nses)
        form
        `(do
           (-> (java.lang.Runtime/getRuntime)
             (.addShutdownHook (java.lang.Thread. guzheng.core/report-missing-coverage)))
           ~hooke-injection
           (defn require-instrumented#
             [f# & ~libspecs-sym]
             (let [loaded-ref# @#'clojure.core/*loaded-libs*
                   loaded# (map str @loaded-ref#)]
               (doseq [ns# (vector ~@nses)]
                 (when-not (some #{ns#} loaded#)
                   (dosync (alter loaded-ref# conj (symbol ns#)))
                   (guzheng.core/instrument-nses
                     guzheng.core/trace-if-branches
                     (vector ns#)))))
             (apply f# ~libspecs-sym))
           (~(if lein2?
               'lein-guzheng.core.injected/add-hook
               'leiningen.util.injected/add-hook) #'require #'require-instrumented#)
           ~form)]
    form))

(defn- lein-probe
  "Returns eip and whether this is lein 1 or lein 2.
  If it's lein 2, the 2nd element of the returned vector
  will be true."
  []
  (or (try (require 'leiningen.core.eval)
        [(resolve 'leiningen.core.eval/eval-in-project)
         true]
        (catch java.io.FileNotFoundException _))
      (try (require 'leiningen.compile)
        [(resolve 'leiningen.compile/eval-in-project)]
        (catch java.io.FileNotFoundException _))) )

(defn- instrument-init
  "Takes an init form and adds guzheng to it."
  [form nses]
  `(do
     ~form
     (require 'guzheng.core)))

(def ^{:dynamic true :private true} *instrumented-nses*)

(defn- instrument-eip-1
  "Calls eval in project w/ instrumentation."
  [f project form x y init]
  (if-not (or x y)
    (f project
       (instrument-form form *instrumented-nses* false)
       nil nil
       (instrument-init init *instrumented-nses*))
    (f project form x y init)))

(defn- instrument-eip-2
  "Calls eval in project w/ instrumentation."
  [f project form init]
  ;TODO: remove this hack where I have to add guzheng here instead of in the
  ;main task. For some reason, it seems that the test task reset the project
  ;map.
  (let [project (-> project
                  (update-in [:dependencies] conj guzheng-version) 
                  (update-in [:injections] conj hooke-injection))]
    (f project
       (instrument-form form *instrumented-nses* true)
       (instrument-init init *instrumented-nses*))))

(defn guzheng
  "Takes a list of namespaces followed by -- and
  another leiningen task and executes that task
  with the given namespaces instrumented."
  [project & args]
  (let [project (-> project
                  (update-in [:dependencies] conj guzheng-version))
        [nses [_ subtask & sub-args]] (split-ns-subtask args)
        [eip two?] (lein-probe)
        apply-task (if two?
                     (resolve 'leiningen.core.main/apply-task) 
                     (resolve 'leiningen.core/apply-task))]
    ;Instrument the correct eval-in-project fn
    (add-hook eip (if two?
                    #'instrument-eip-2
                    #'instrument-eip-1))
    (binding [*instrumented-nses* nses
              leiningen.test/*exit-after-tests* false]
      (apply apply-task subtask project sub-args
             (if two?
               [] ;lein1 has a 4 arg form, lein2 is 3 arg form
               [(resolve 'leiningen.core/task-not-found)])))))
