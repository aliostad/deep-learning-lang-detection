(ns feedxcavator.manager
  (:require [feedxcavator.api :as api]
            [clojure.string :as str]
            [net.cgrand.enlive-html :as enlive])
  (:use clojure.tools.macro))

(def manager-template )

(defn manage-route []
  (if api/+public-deploy+
    (api/page-not-found)
    (api/html-page
     (api/render
      (enlive/transform
       (enlive/html-resource (api/get-resource-as-stream "manager.html"))
       [:.feed-entry]
       (enlive/clone-for [feed (api/get-all-feeds)]
                         [:.edit-link]
                         (enlive/set-attr :href (str api/+edit-url-base+ (:uuid feed)))
                         [:.delete-link]
                         (enlive/set-attr :href (str api/+delete-url-base+ (:uuid feed)))
                         [:.feed-link]
                         (enlive/do-> (enlive/set-attr :href (str api/+feed-url-base+ (:uuid feed)))
                                      (enlive/content (:feed-title feed)))))))))

(defn delete-route [feed-id]
  (do
    (try
      (api/delete-feed! feed-id)
      (catch Exception e (.getMessage e)))
    (api/redirect-to api/+manager-url-base+)))

(defn subscribe-route [feed-id]
  (let [feed-settings (when feed-id (api/query-feed feed-id))]
    (if feed-settings
      (api/html-page
       (api/render
        (enlive/at (enlive/html-resource (api/get-resource-as-stream "subscribe.html"))
            [:.feed-link]
            (enlive/do-> (enlive/set-attr :href (str api/+feed-url-base+ (:uuid feed-settings)))
                         (enlive/content (:feed-title feed-settings)))
            [:#subscribe-link]
            (enlive/set-attr :href (str api/*app-host* api/+feed-url-base+ (:uuid feed-settings))))))           
        (api/page-not-found))))
