(ns hivewing-web.routes
    (:require [compojure.core :refer :all]
              [hivewing-web.paths :as paths]
              [hivewing-web.home-controller :as home]
              [hivewing-web.apiary-controller :as apiary]
              [hivewing-web.system-controller :as system]
              [hivewing-web.hive-controller :as hive]
              [hivewing-web.worker-controller :as worker]
              [hivewing-web.beekeeper-controller :as beekeeper]
              [hivewing-web.login-controller :as login]
              [lib.routes :as lib]))

(defroutes app-routes
  "Route for Hivewing-Web!"
  ;; Root Request
  (lib/hw-route GET "/" home/index)
  (lib/hw-route GET  (paths/login-path) login/login :post-to "/login")

  (lib/hw-route POST (paths/login-path)  login/do-login)
  (lib/hw-route GET  (paths/logout-path)  login/logout)
  (lib/hw-route GET  (paths/apiary-path)  apiary/status)
  (lib/hw-route GET  (paths/apiary-manage-path)  apiary/manage)
  (lib/hw-route GET  "/apiary/join"  apiary/join :post-to "/apiary/join")
  (lib/hw-route POST "/apiary/join"  apiary/do-join)

  (lib/hw-route GET (paths/hive-path ":hive-uuid") hive/status)
  (lib/hw-route GET (paths/hive-manage-path ":hive-uuid") hive/manage)
  (lib/hw-route GET (paths/hive-processing-path ":hive-uuid") hive/processing)
  (lib/hw-route GET (paths/hive-processing-new-choose-stage-path ":hive-uuid" ) hive/processing-new-choose-stage)
  (lib/hw-route GET (paths/hive-processing-new-stage-path ":hive-uuid" ":stage-name") hive/processing-new-stage)
  (lib/hw-route POST (paths/hive-processing-create-stage-path ":hive-uuid" ":stage-name") hive/processing-create-stage)
  (lib/hw-route POST (paths/hive-processing-delete-stage-path ":hive-uuid" ":stage-uuid") hive/processing-delete-stage)
  (lib/hw-route POST (paths/hive-manage-path ":hive-uuid") hive/update-manage)
  (lib/hw-route GET (paths/hive-data-path ":hive-uuid") hive/data)
  (lib/hw-route GET (paths/hive-data-value-path ":hive-uuid" ":data-name") hive/show-data-values)

  (lib/hw-route GET  (paths/worker-path ":hive-uuid" ":worker-uuid") worker/status)
  (lib/hw-route POST (paths/worker-delete-path ":hive-uuid" ":worker-uuid") worker/delete-worker)
  (lib/hw-route GET  (paths/worker-manage-path ":hive-uuid" ":worker-uuid")  worker/manage)
  (lib/hw-route POST (paths/worker-manage-path ":hive-uuid" ":worker-uuid")  worker/update-manage)
  (lib/hw-route POST (paths/worker-config-update-path ":hive-uuid" ":worker-uuid")  worker/update-config)
  (lib/hw-route POST (paths/worker-config-delete-path ":hive-uuid" ":worker-uuid")  worker/delete-config)
  (lib/hw-route POST (paths/worker-config-path ":hive-uuid" ":worker-uuid")  worker/create-config)
  (lib/hw-route GET  (paths/worker-config-path ":hive-uuid" ":worker-uuid")  worker/config)

  (lib/hw-route GET (paths/worker-data-path ":hive-uuid" ":worker-uuid") worker/data)
  (lib/hw-route GET (paths/worker-data-value-path ":hive-uuid" ":worker-uuid" ":data-name") worker/show-data-values)
  (lib/hw-route GET (paths/worker-logs-delta-path ":hive-uuid" ":worker-uuid") worker/logs-delta)
  (lib/hw-route GET (paths/worker-logs-path ":hive-uuid" ":worker-uuid") worker/logs)
  (lib/hw-route GET (paths/worker-events-path ":hive-uuid" ":worker-uuid") worker/events)
  (lib/hw-route POST (paths/worker-events-path ":hive-uuid" ":worker-uuid") worker/send-event)

  (lib/hw-route GET (paths/beekeeper-profile-path) beekeeper/profile)
  (lib/hw-route POST (paths/beekeeper-profile-path) beekeeper/profile-update)
  (lib/hw-route POST (paths/beekeeper-profile-change-password-path) beekeeper/change-password)
  (lib/hw-route GET (paths/beekeeper-public-keys-path) beekeeper/public-keys)
  (lib/hw-route POST (paths/beekeeper-public-keys-path) beekeeper/public-key-create)
  (lib/hw-route POST (paths/beekeeper-public-key-delete-path) beekeeper/public-key-delete)

  (ANY "*" {:as req} (lib/log-response (system/not-found (lib/log-request req))))
  )
