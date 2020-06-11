(ns eisago.http
  (:require [eisago.api :as api]
            [eisago.config :refer [config]]
            [eisago.web :as web]
            [laeggen.core :as laeggen]
            [laeggen.dispatch :as dispatch]))

(def api-urls
  (dispatch/urls
   [#"^/v1/doc/([^/]+)/?$"
    #"^/v1/doc/([^/]+)/([^/]+)/([^/]+)/?$"]
   #'api/doc-for

   [#"^/v1/meta/([^/]+)/?$"
    #"^/v1/meta/([^/]+)/([^/]+)/([^/]+)/?$"]
   #'api/children-for

   [#"^/v1/([^/]+)/([^/]+)/_search/?$"
    #"^/v1/([^/]+)/_search/?$"
    #"^/v1/_search/?$"]
   #'api/search

   #"^/v1/_projects/?" #'api/all-projects

   #"^/v1/_stats/?$" #'api/stats

   :404 #'api/missing
   :500 #'api/error))

(defn start-api-server []
  (laeggen/start {:port (config :api-port)
                  :urls api-urls}))

(def web-urls
  (dispatch/urls
   #"^/$" #'web/index

   #"^/([^/]+)-([^/]+)/$" #'web/project-view
   #"^/([^/]+)-([^/]+)/([^/]+)/$" #'web/namespace-view
   #"^/([^/]+)-([^/]+)/([^/]+)/([^/]+)/$" #'web/var-view

   #"^/([^/]+)/$" #'web/redirect-project
   #"^/([^/]+)/([^/]+)/$" #'web/redirect-namespace
   #"^/([^/]+)/([^/]+)/([^/]+)/$" #'web/redirect-var))

(defn start-web-server []
  (laeggen/start {:port (config :web-port)
                  :append-slash? true
                  :urls web-urls}))

;; (do (swap! laeggen/routes assoc (config :api-port) (dispatch/merge-urls laeggen.views/default-urls api-urls)) (swap! laeggen/routes assoc (config :web-port) (dispatch/merge-urls laeggen.views/default-urls web-urls)))
