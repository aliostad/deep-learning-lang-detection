;
;   Copyright (c) Ludger Solbach. All rights reserved.
;   The use and distribution terms for this software are covered by the
;   Eclipse Public License 1.0 (http://opensource.org/licenses/eclipse-1.0.php)
;   which can be found in the file license.txt at the root of this distribution.
;   By using this software in any fashion, you are agreeing to be bound by
;   the terms of this license.
;   You must not remove this notice, or any other, from this software.
;
(ns baumeister.plugin.cobertura
  (:use [clojure.java.io :exclude [delete-file]]
        [clojure.string :only [join split]]
        [org.soulspace.clj file]
        [baumeister.utils ant-utils files log]
        [baumeister.config registry]))

(ant-taskdef {:resource "net.sourceforge.cobertura.ant.antlib.xml"})
;(ant-taskdef {:name cobertura-instrument :classname "net.sourceforge.cobertura.ant.InstrumentTask"})
;(ant-taskdef {:name cobertura-report :classname "net.sourceforge.cobertura.ant.ReportTask"})
;(ant-taskdef {:name cobertura-merge :classname "net.sourceforge.cobertura.ant.MergeTask"})
;(ant-taskdef {:name cobertura-check :classname "net.sourceforge.cobertura.ant.CheckTask"})

(define-ant-task ant-cobertura-instrument cobertura-instrument)
(define-ant-task ant-cobertura-report cobertura-report)
(define-ant-type ant-ignore net.sourceforge.cobertura.ant.Ignore)

(defmethod add-nested [:baumeister.utils.ant-utils/cobertura-instrument
                       net.sourceforge.cobertura.ant.Ignore]
  [_ task regex] (doto (.createIgnore task) (.setRegex regex)))

(defn instrument-task []
  (ant-cobertura-instrument {:toDir (param :build.instrumented.dir)
                             :datafile (param :cobertura-data-file)}
                            (ant-ignore {:regex "org.apache.log4j.*"})
                            (ant-ignore {:regex "antlr.*"})
                            (ant-fileset {:dir (param :build-classes-dir)
                                          :includes "**/*.class" :excludes "**/*Test.class"})))

(defn report-task []
  (ant-cobertura-report {:destdir (param :cobertura-report-dir) :format "xml"
                         :datafile (param :cobertura-data-file)}
                        (ant-fileset {:dir (param :module-dir) :includes (join " " (split (source-path) #":"))})))

(defn cobertura-junit [class-path test-dir report-dir]
  (log :debug class-path test-dir)
  (ant-junit {:fork (param :junit-fork) :forkMode (param :junit-fork-mode)
              :maxmemory (param :junit-max-memory)
              :printsummary (param :junit-print-summary)
              :errorProperty "unittest.error"
              :failureProperty "unittest.error"}
             (ant-path class-path)
             (ant-variable {:key "base.dir" :value (param :module-dir)})
             (ant-variable {:key "net.sourceforge.cobertura.datafile" :value (param :cobertura-data-file)})
             (ant-formatter {:type "brief" :useFile "false"})
             {:todir report-dir
              :fileset (ant-fileset {:dir test-dir :includes "**/*Test.class" :excludes "junit/**/*Test.class,**/Abstract*.class"})}))

(def cobertura-run-classpath
  (class-path [(param :build-cobertura-dir)]))

(defn cobertura-clean []
  (log :info "cleaning cobertura...")
    (delete-file (as-file (param :build-cobertura-dir)))
    (delete-file (as-file (param :cobertura-report-dir))))

(defn cobertura-init []
  (log :info "initializing cobertura...")
  (create-dir (as-file (param :cobertura-report-dir)))
  (create-dir (as-file (param :build-cobertura-dir))))

(defn cobertura-pre-coverage []
  (log :info "pre-coverage cobertura...")
  (instrument-task))

(defn cobertura-coverage []
  (log :info "coverage cobertura...")
  (cobertura-junit cobertura-run-classpath (param :build-unittest-classes-dir) (param :unittest-unittest-report-dir)))  ; add unittest classpath

(defn cobertura-post-coverage []
  (log :info "post-coverage cobertura...")
  (report-task))

(def config
  {:params [[:build-cobertura-dir "${build-dir}/cobertura"]
            [:cobertura-data-file "${build-cobertura-dir}/cobertura.ser"]
            [:cobertura-report-dir "${build-report-dir}/cobertura"]]
   :steps [[:clean cobertura-clean]
           [:init cobertura-init]
           [:pre-coverage cobertura-pre-coverage]
           [:coverage cobertura-coverage]
           [:post-coverage cobertura-post-coverage]]
   :functions []})
