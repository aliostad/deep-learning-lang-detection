(ns probonitor.core
  (:require [clojure.tools.cli :refer [parse-opts]]
            [clojure.string :as string]
            [probonitor.utils :refer [error-msg exit check-if-repo-exists]]
            [probonitor.project.main :as project]
            [probonitor.spotinst.main :as spotinst]
            [probonitor.rancher.main :as rancher]
            [probonitor.deploy.main :as deploy])
  (:gen-class))

(def option-specs
  [["-h" "--help" "Print help information"]
   ["-v" "--version" "Show the Probonitor version information"]])

(defn usage [summary]
  (->> ["Usage:\tprobonitor [OPTIONS] COMMAND [arg...]"
        "\tprobonitor [ -h | --help | -v | --version ]"
        ""
        "CLI tool to manage the Probo Monitoring Environment."
        ""
        "Options:"
        ""
        summary
        ""
        "Commands:"
        ""
        "  project\tFunctions dealing with Probonitor project"
        "  deploy\tFunctions dealing with deployment"
        "  spotinst\tFunctions dealing with Spotinst"
        "  rancher\tFunctions dealing with Rancher"]
       (string/join \newline)))

(def project-details
  {:version (System/getProperty "probonitor.version")
   :name "Probonitor"})

(def get-project-details
  (let [{:keys [version name]} project-details]
    (str name " version " version \newline)))

(defn -main [& args]
  (let [{:keys [options arguments errors summary]}
        (parse-opts args option-specs :in-order true)]
    (check-if-repo-exists)
    (cond
      (:help options) (exit 0 (usage summary))
      (:version options) (exit 0 get-project-details)
      (< (count arguments) 1) (exit 1 (usage summary))
      errors (exit 1 (error-msg errors)))
    (case (first arguments)
      "project" (project/handler (rest arguments))
      "deploy" (deploy/handler (rest arguments))
      "spotinst" (spotinst/handler (rest arguments))
      "rancher" (rancher/handler (rest arguments))
      (exit 1 (usage summary)))))
