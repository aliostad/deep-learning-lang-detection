(ns comic-reader.routes
  (:require [comic-reader.history :as h]
            [re-frame.core :as rf]
            [secretary.core :as secretary
             :refer-macros [defroute]]))

;; Have secretary pull apart URL's and then dispatch with re-frame
(defroute sites-path "/" []
  (rf/dispatch [:sites]))

(defroute comics-path "/comics/:site" {:keys [site]
                                       {:keys [filter]}
                                       :query-params}
  (rf/dispatch [:comics site filter]))

(defroute read-path "/read/:site/:comic/:chapter/:page"
  {site :site
   :as location}
  (let [location (dissoc location :site)]
    (rf/dispatch [:read site location])))

(defroute "*" {:as _}
  (rf/dispatch [:unknown]))

(defn go-to [page-url]
  (h/set-token page-url))

(defn make-link [page-url]
  (str "/#" page-url))

(defn setup-secretary! []
  (secretary/set-config! :prefix ""))
