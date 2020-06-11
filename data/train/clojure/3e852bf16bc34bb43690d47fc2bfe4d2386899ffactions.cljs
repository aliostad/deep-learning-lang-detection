(ns youtube-web-clj.actions
  (:require-macros [cljs.core.async.macros :refer [go]])
  (:require [cljs.core.async :refer [<!]]
            [youtube-web-clj.store :as store]
            [youtube-web-clj.api :as api]))

(defn- create-search-action [query]
  {:type :SEARCH_ACTION :query query})

(defn- create-search-done-action [data]
  {:type :SEARCH_DONE_ACTION :data data})

(defn- create-search-error-action [error]
  {:type :SEARCH_ERROR_ACTION :error error})

(defn search [query]
  (go
    (store/dispatch (create-search-action query)) ;; Dispatch action to show loader
    (let [{err :err data :data} (<! (api/search query))]
      (if (nil? err)
        (store/dispatch (create-search-done-action data))
        (store/dispatch (create-search-error-action err))))))
