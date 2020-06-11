;; objectives:
;; maintain an editable list of image sources in DB
;;   feeds (atom, rss, ?)
;;   API LIST endpoints
;;
;; poll those feeds at a slow interval, aggregating images as they're posted
;;   in the case that there are multiple images in an album, grab them all
;; store images in DB
;;
;; expose a management API:
;;   add/remove feeds, change params on feed (ratelimit)
;;   manage existing images -- list, remove
;;   add images directly by url
;;   manually refresh a source
;;   start/stop auto-refresh of a source
;;
;; authenticate requests
;;   will recieve JWT with requests, and verify it with auth service
;;
;; /sources: GET    /          -- list all sources
;;           POST   /          -- add a source {url, name, type, ratelimit}
;;           PATCH  /:id       -- update a source (change url, rename)
;;           DELETE /:id       -- delete a source
;;           POST   /:id/stop  -- stop auto-fetching a source
;;           POST   /:id/start -- (re)start auto-fetching a source
;;           POST   /:id/fetch -- manually trigger a fetch from source
;;
;;
;; /images: GET    /      -- list all images (sort, pagination)
;;          POST   /      -- add an image {url}
;;          DELETE /:id   -- remove an image
;;

;; on startup pull sources from db and load into memory as config
;; each source needs to have start, stop, fetch, ... methods -- protocol or mount/component
;; how is config passed to the source?
;;   global atom? needs to be updated as sources are added/modified
;;   lookup in DB

(ns buyme-aggregation-backend.core
  (:require [environ.core :refer [env]]
            [mount.core :as mount]

            [buyme-aggregation-backend.util.logging :refer [do-logging-config]]
            [buyme-aggregation-backend.conf :refer [config]]
            [buyme-aggregation-backend.routes :refer [webapp]]
            [buyme-aggregation-backend.db]
            [buyme-aggregation-backend.source])

  (:gen-class))



(Thread/setDefaultUncaughtExceptionHandler
  (reify Thread$UncaughtExceptionHandler
    (uncaughtException [_ thread throwable]
      (println "uncaught exception:" (.getMessage throwable))
      (System/exit 1))))

(defn -main []
  (dosync
    (do-logging-config config)
    (mount/start)))

