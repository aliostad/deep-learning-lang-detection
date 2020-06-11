(ns profix.core
  (:require [clojure.string :as str]
            [clojure.tools.cli :as cli]
            [profix.http :as http]
            [profix.cce :as cce]
            [profix.diff :as diff]
            [profix.fix :as fix]
            [clojure.data.json :as json])
  (:import (java.net InetAddress))
  (:gen-class))

(def cli-options
  [["-H" "--hostname HOST" "Command Central host"
    :default (InetAddress/getByName "localhost")
    :default-desc "localhost"
    :parse-fn #(InetAddress/getByName %)]
   ["-p" "--port PORT" "Port number"
    :default 8090
    :parse-fn #(Integer/parseInt %)
    :validate [#(< 0 % 0x10000) "Must be a number between 0 and 65536"]]
   ["-t" "--protocol PROTOCOL" "Protocol"
    :default "http"
    :validate [#( #{"http" "https"} %) "Must be either http or https"]]
   ["-f" "--fixesRepo FIXES" "Fixes repository"
    :default "fixes"]
   ["-m" "--platform PLATFORM" "Platform"
    :default "LNXAMD64"]
   ["-s" "--secret PASSWORD" "Administrator secret"
    :default "manage"]
   ["-i" "--insecure-ssl VALUE" "Set to 'true' if CCE certificates are self-signed, 'false' otherwise"
    :default true
    :parse-fn #(Boolean/parseBoolean %)]
   ["-h" "--help"]])

(defn usage [options-summary]
  (->> ["This Command Central utility can be used to query repositories about fixes and products and compare them to an existing SPM installation."
        ""
        "Usage: profix [options] action [arguments]"
        ""
        "Options:"
        options-summary
        ""
        "Actions:"
        "  list-available-fixes <nodeAlias>    List the available fixes for a given node alias"
        ""
        "Please refer to the README for more information: https://github.com/mmacphail/profix"]
       (str/join \newline)))

(defn error-msg [errors]
  (str "The following errors occurred while parsing your command:\n\n"
       (str/join \newline errors)))

(defn validate-args
  [args]
  (let [{:keys [options arguments errors summary]} (cli/parse-opts args cli-options)]
    (cond
      (:help options)
      {:exit-message (usage summary) :ok? true}
      errors
      {:exit-message (error-msg errors)}
      (and (>= (count arguments) 1)
           (#{ "list-available-fixes" } (first arguments)))
      {:actions arguments :options options}
      :else
      {:exit-message (usage summary)})))

(defn exit [status msg]
  (println msg)
  (System/exit status))

(defn build-cce-url [options]
  (let [{:keys [protocol hostname port]} options
        host (.getHostName hostname)]
    (str protocol "://" host ":" port "/cce")))

(defn list-available-fixes [options node-alias]
  (let [{:keys [secret insecure-ssl fixesRepo platform]} options
        cce-url (build-cce-url options)
        token ["Administrator" secret]
        req (http/make-request cce-url token insecure-ssl)
        inventory-fixes (cce/list-detailed-inventory-fixes req node-alias)
        repo-fixes (fix/filter-stable-fixes (cce/list-repository-fixes req fixesRepo node-alias platform))]
    (diff/list-available-fixes inventory-fixes repo-fixes)))

(defn show [content]
  (println (json/write-str content)))

(defn -main [& args]
  (let [{:keys [actions options exit-message ok?]} (validate-args args)]
    (if exit-message
      (exit (if ok? 0 1) exit-message)
      (case (first actions)
        "list-available-fixes" (show (list-available-fixes options (last actions)))))))