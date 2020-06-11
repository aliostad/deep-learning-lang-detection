(ns io.aviso.taxi-toolkit.logs
  "Helpers for working with browser log."
  (:require [clojure.string :as str]
            [clj-webdriver.taxi :as taxi]
            [clojure.test :refer [is]]))

(defn log-entry->map
  "Converts Selenium LogEntry to simpler map."
  [log-entry]
  {:message (.getMessage log-entry)
   :timestamp (.getTimestamp log-entry)
   :level (-> log-entry (.getLevel) (.getName) keyword)})

(defn get-browser-logs
  "Fetches the entries from browser log."
  []
  (let [logs (-> (.. (:webdriver taxi/*driver*) (manage) (logs) (get "browser") (iterator))
                 (iterator-seq))]
    (map log-entry->map logs)))

(defn assert-browser-logs
  "Asserts that there is no browser log entries that denote an error (determined by given predicate).
  Formats the messages to be displayed along with assertion in case of failure."
  [pred]
  (let [logs (get-browser-logs)
        errors (filter pred logs)
        no-errors (empty? errors)]
    (is no-errors (str "Browser errors: \n" (str/join "\n" logs)))))
