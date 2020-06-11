(ns hivewing-web.paths
  (:require [ring.util.codec :as ring-codec]
            [ring.util.request :as ring-request]
            [lib.paths :as lib]
            [environ.core :refer [env]]
            ))

(defn api-docs-path []
  (str (env :hivewing-api-host) "/index.html"))

(lib/defpath logout-path [] "logout")
(lib/defpath login-path [] "login")
(lib/defpath apiary-path [] "apiary")
(lib/defpath apiary-manage-path [] (apiary-path) "manage")
(lib/defpath worker-path [hive-uuid worker-uuid] "hives" hive-uuid "workers" worker-uuid)
(lib/defpath worker-status-path [hu wu] (worker-path hu wu))
(lib/defpath worker-manage-path [hu wu] (worker-path hu wu) "manage")
(lib/defpath worker-delete-path [hu wu] (worker-path hu wu) "delete-worker")
(lib/defpath worker-config-path [hu wu] (worker-path hu wu) "config")
(lib/defpath worker-config-update-path [hu wu] (worker-config-path hu wu) "update")
(lib/defpath worker-config-delete-path [hu wu] (worker-config-path hu wu) "delete")

(lib/defpath worker-data-path [hu wu] (worker-path hu wu) "data")
(lib/defpath worker-data-value-path [hu wu dn] (worker-path hu wu) "data" dn)
(lib/defpath worker-logs-path [hu wu] (worker-path hu wu) "logs")
(lib/defpath worker-logs-delta-path [hu wu] (worker-path hu wu) "logs" "delta")
(lib/defpath worker-events-path [hu wu] (worker-path hu wu) "events")


(lib/defpath hive-path [hive-uuid] "hives" hive-uuid )
(lib/defpath hive-manage-path [hu] (hive-path hu) "manage")
(lib/defpath hive-data-path [hu] (hive-path hu) "data")
(lib/defpath hive-data-value-path [hu dn] (hive-path hu) "data" dn)
(lib/defpath hive-processing-path [hu] (hive-path hu) "processing")
(lib/defpath hive-processing-new-choose-stage-path [hu] (hive-path hu) "processing" "new-stage")
(lib/defpath hive-processing-new-stage-path [hu stgnm] (hive-path hu) "processing" "stage" stgnm "new")
(lib/defpath hive-processing-create-stage-path [hu stgnm] (hive-path hu) "processing" "stage" stgnm "create")
(lib/defpath hive-processing-delete-stage-path [hu stgnm] (hive-path hu) "processing" "stage" stgnm "delete")

(lib/defpath beekeeper-profile-path [] "beekeeper" "profile")
(lib/defpath beekeeper-profile-change-password-path [] "beekeeper" "profile" "change-password")
(lib/defpath beekeeper-public-keys-path [] "beekeeper" "public-keys")
(lib/defpath beekeeper-public-key-delete-path [] "beekeeper" "public-keys" "delete")
