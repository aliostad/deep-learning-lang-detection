(ns ^{:author "Adam Berger"} ulvm.cli
  (:require [clojure.tools.cli :as cli]
            [clojure.string :as string]
            [clojure.spec.test :as st]
            [ulvm.compiler :as cmpl]))

(def cli-opts
 [["-d" "--dir DIR" "Directory"
   :default "."]
  ["-i" "--instrument" "Instrument"]
  ["-h" "--help"]])

(defn- usage
  ([summary]
    (usage summary []))
  ([summary errors]
    (string/join \newline (conj errors summary))))

(defn- validate-opts
  [{:keys [errors summary options]}]
  (cond
    (some? errors)  {:msg (usage summary errors), :exit-with 2}
    (:help options) {:msg (usage summary), :exit-with 0}
    :else           {:opts options}))

(defn- run-compiler
  [opts]
  (when
    (:instrument opts) 
    (st/instrument (st/instrumentable-syms 'ulvm)))
  (let [dir  (:dir opts)
        prj  (cmpl/ulvm-compile dir)]
    (println prj)))

(defn- exit
  [msg status]
  (println msg)
  (System/exit status))

(defn -main [& args]
  (let [{:keys [msg opts exit-with]} (-> (cli/parse-opts args cli-opts)
                                         (validate-opts))]
    (cond
      (some? exit-with) (exit msg exit-with)
      :else             (run-compiler opts))))
