;; Feedxcavator (a HTML to RSS converter)
;; (C) 2011 g/christensen (gchristnsn@gmail.com)

(ns feedxcavator.core
  (:require [feedxcavator.api :as api]
            [feedxcavator.editor :as editor]
            [feedxcavator.manager :as manager]
            [feedxcavator.custom :as custom]
            [feedxcavator.excavation :as excv]
            [compojure.handler :as handler])
  (:use compojure.core))

(defn deliver-route [feed-id]
  (let [feed-settings (when feed-id (api/query-feed feed-id))]
    (if feed-settings
      (try
        (apply api/page-found (excv/perform-excavation feed-settings))
        (catch Exception e
          (if (api/in-debug-env?)
            (throw e)
            (api/internal-server-error))))
      (api/page-not-found))))

(defroutes feedxcavator-app-routes
  (GET "/" [] (api/redirect-to "/create"))
  (GET "/create" [] (editor/create-feed-route))
  (GET "/edit" [feed] (editor/edit-feed-route feed))
  (POST "/do-test" request (editor/do-test-route request))
  (POST "/do-create" request (editor/do-create-route request))
  (GET "/deliver" [feed] (deliver-route feed))
;;  (GET "/subscribe" [feed] (manager/subscribe-route feed))
  (GET "/delete" [feed] (manager/delete-route feed))
  (GET "/manage" [] (manager/manage-route))
  (GET "/custom" [] (custom/custom-route))
  (GET "/robots.txt" [] (api/text-page "User-agent: *"))
  (ANY "*" [] (api/page-not-found)))

(defn context-binder [handler]
  (fn [req]
    (binding [api/*servlet-context* (:servlet-context req)
              api/*remote-addr* (:remote-addr req)
              api/*app-host* (str (name (:scheme req)) "://"
                                  (:server-name req)
                                  (let [port (:server-port req)]
                                        (when (and port (not= port 80))
                                          (str ":" port))))]
      (handler req))))

(def feedxcavator-app-handler (handler/site
                                (context-binder feedxcavator-app-routes)))

(api/perform-initialization #'feedxcavator-app-handler)