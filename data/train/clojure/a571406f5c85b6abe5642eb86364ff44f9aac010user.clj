(ns user
  (:require [aleph.http :as http]
            [clojure.java.jdbc :as j]
            [clojure.spec.test :as st]
            [clojure.tools.namespace.repl :refer [refresh]]
            [clojure.spec :as s]
            [com.stuartsierra.component :as comp]
            [environ.core :refer [env]]
            [takelist.app :refer [app]]
            [takelist.db :as db])
  (:import [java.util UUID]))

(st/instrument)

(def db
  (:db (comp/start (db/h2 (env :database-uri)))))

(defonce server nil)

(defn init []
  (alter-var-root #'server
                  (fn [_]
                    (http/start-server
                      (app (assoc env :db db))
                      {:port 8080}))))

(defn reload []
  (.close server)
  (refresh :after 'user/init))

(comment
  (init)
  (reload)
  )

(comment
  (j/query db ["select * from tkl_product"])
  (j/query db ["select * from tkl_user"])
  (j/query db ["select * from tkl_order"])
  )
