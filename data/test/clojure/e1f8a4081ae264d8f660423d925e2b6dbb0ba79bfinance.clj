(ns bot.providers.finance
  (:require [clojure.tools.cli :as cli]
            [clj-http.client :as http]
            [clojure.data.csv :as csv])
  (:use [clj-http.util :only (url-encode)]
        [bot.query-provider]))

(def ^:private yahoo-finance-url-template "https://download.finance.yahoo.com/d/quotes.csv?s=%s&f=nsl1op&e=.csv")
(def ^:private finance-options [])
(defn- to-arrow [a b]
  (cond 
    (> a b) "↘" 
    (< a b) "↗"
    :else "→"))

(defn- get-instrument [instrument]
  (let [url (format yahoo-finance-url-template instrument)
        csv (first (csv/read-csv (:body (http/get url))))
        instrument-name (first csv)
        open (bigdec (nth csv 3))
        current (bigdec (nth csv 4))
        close (bigdec (last csv))
        arrow (to-arrow open close)]
    (str instrument-name ": " open " " arrow " " close " (" current ")")
    )
  )

(deftype Finance-provider []
  Query-provider
  (provider-name [this] "Finance")
  (options [this] finance-options)
  (run-query [this query]
    (let [opts (cli/parse-opts (clojure.string/split query) finance-options)]
      (if (clojure.string/blank? query)
        (get-instrument "^OMXS30")
        (get-instrument query)
        )
      )
    )
  )
