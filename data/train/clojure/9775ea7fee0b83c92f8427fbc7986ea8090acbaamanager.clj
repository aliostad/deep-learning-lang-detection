(ns feedxcavator.manager
  (:require [feedxcavator.api :as api]
            [feedxcavator.db :as db]
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
       (enlive/clone-for [feed (sort #(compare (str/lower-case (:feed-title %1))
                                               (str/lower-case (:feed-title %2)))
                                     (db/get-all-feeds))]
                         [:.edit-link]
                         (enlive/set-attr :href (str api/+edit-url-base+ (:uuid feed)))
                         [:.delete-link]
                         (enlive/set-attr :href (str api/+delete-url-base+ (:uuid feed)))
                         [:.duplicate-link]
                         (enlive/set-attr :href (str api/+duplicate-url-base+ (:uuid feed)))
                         [:.feed-link]
                         (enlive/do-> (enlive/set-attr :href (str api/+feed-url-base+ (:uuid feed)))
                                      (enlive/content (:feed-title feed)))))))))

(defn delete-route [feed-id]
  (do
    (try
      (db/delete-feed! feed-id)
      (catch Exception e (.getMessage e)))
    (api/redirect-to api/+manager-url-base+)))

(defn duplicate-route [feed-id]
  (do
    (try
      (let [feed (db/query-feed feed-id)]
        (db/store-feed!
         (db/map->Feed
          {:uuid (api/get-uuid)
           :feed-title (str (:feed-title feed) "*")
           :target-url (:target-url feed)
           :charset (:charset feed)
           :selectors (:selectors feed)
           :enlive-selectors (:enlive-selectors feed)
           :remember-recent (:remember-recent feed)
           :recent-article (:recent-article feed)
           :realtime (:realtime feed)
           :custom-excavator (:custom-excavator feed)
           :custom-params (:custom-params feed)})))
      (catch Exception e (println (.getMessage e))))
    (api/redirect-to api/+manager-url-base+)))

(defn subscribe-route [feed-id]
  (let [feed-settings (when feed-id (db/query-feed feed-id))]
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

