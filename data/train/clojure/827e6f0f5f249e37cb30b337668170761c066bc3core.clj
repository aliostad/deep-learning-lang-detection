;; Feedxcavator (a HTML to RSS converter)
;; (C) 2011 g/christensen (gchristnsn@gmail.com)

(ns feedxcavator.core
  (:require [feedxcavator.api :as api]
            [feedxcavator.editor :as editor]
            [feedxcavator.manager :as manager]
            [feedxcavator.custom :as custom]
            [feedxcavator.admin :as admin]
            [feedxcavator.custom-code :as custom-code]
            [feedxcavator.excavation :as excv]
            [feedxcavator.hub :as hub]
            [feedxcavator.db :as db]
            [compojure.handler :as handler]
            [appengine-magic.core :as ae]
            [ring.middleware.multipart-params.byte-array :as ring-byte-array])
  (:use compojure.core
        [ring.util.mime-type :only [ext-mime-type]]))

(def custom-code-compiled (atom false))

(defn deliver-feed-route [feed-id]
  (let [feed-settings (when feed-id (db/query-feed feed-id))]
    (if feed-settings
      (try
        (let [result (excv/perform-excavation feed-settings)]
          (apply api/page-found result))
        (catch Exception e
          (if (api/in-debug-env?)
            (throw e)
            (api/internal-server-error))))
      (api/page-not-found))))

(defn deliver-image-route [id]
  (let [image (db/query-image id)]
    (if image
      (api/page-found (ext-mime-type id) (.getBytes (:data image)))
      (api/page-not-found))))

(defroutes feedxcavator-app-routes
 (GET "/" [] (api/redirect-to "/create"))
 (GET "/create" [] (editor/create-feed-route))
 (GET "/edit" [feed] (editor/edit-feed-route feed))
 (POST "/do-test" request (editor/do-test-route request))
 (POST "/do-create" request (editor/do-create-route request))
 (GET "/deliver" [feed] (deliver-feed-route feed))
 (ANY "/hub" request (hub/post-action request))
 (GET "/publish" [feed] (hub/publish-notify feed))
 (GET "/image" [id] (deliver-image-route id))
 (GET "/delete" [feed] (manager/delete-route feed))
 (GET "/double" [feed] (manager/duplicate-route feed))
 (GET "/manage" [] (manager/manage-route))
 (GET "/check-tasks" [] (custom/check-tasks-route))
 (ANY "/task" request (custom/custom-task-route request))
 (ANY "/run/:id" [id] (custom/run-task id))
 (ANY "/external-fetching" [] (custom/external-fetching-route))
 (GET "/custom" [] (custom/custom-code-route))
 (POST "/retreive-custom" request (custom/retreive-custom-code-route request))
 (POST "/save-custom" request (custom/save-custom-code-route request))
 (POST "/store-external-data" [feed-id data] (custom/store-external-data feed-id data))
 (POST "/store-encoded-external-data" [feed-id data] (custom/store-encoded-external-data feed-id data))
 (GET "/report-external-errors" [date] (custom/report-external-errors date))
 (GET "/clear-realtime-history" [] (custom/clear-realtime-history))
 (ANY "/service-task-front" [] (custom/service-task-front))
 (ANY "/service-task" [] (custom/service-task))
 (ANY "/clear-data" [] (custom/clear-data))
 (GET "/robots.txt" [] (api/text-page "User-agent: *"))
 (GET "/proxify*" [url referer cookie] (api/proxify url referer cookie))
 (GET "/akiba-search" [keywords] ((ns-resolve (symbol api/+custom-ns+) 'akiba-search) keywords))
 (GET "/admin" [] (admin/admin-route))
 (POST "/admin" request (admin/admin-store-settings-route request))
 (GET "/backup" [] (admin/backup-database-route))
 (POST "/restore" request (admin/restore-database-route request))
 (ANY "*" [] (api/page-not-found)))

(defn context-binder [handler]
  (fn [req]
    (let [server-name (:server-name req)
          worker-inst? (.startsWith server-name api/+worker-url-prefix+)]
      (binding [api/*servlet-context* (:servlet-context req)
                api/*remote-addr* (:remote-addr req)
                api/*worker-instance* worker-inst?
                api/*app-host* (str "https://"
                                    (if worker-inst?
                                        (.substring server-name (inc (.indexOf server-name ".")))
                                        server-name)
                                    (let [port (:server-port req)]
                                      (when (and port (not= port 80))
                                        (str ":" port))))]
        (when (not @custom-code-compiled)
          (try
              (api/compile-custom-code (db/query-custom-code))
              (reset! custom-code-compiled true)
            (catch Exception e (println (.getStackTrace e)))))

        (handler req)))))

(def feedxcavator-app-handler (handler/site
                                (context-binder feedxcavator-app-routes)
                                {:multipart {:store (ring-byte-array/byte-array-store)}}))

(ae/def-appengine-app feedxcavator-app #'feedxcavator-app-handler)