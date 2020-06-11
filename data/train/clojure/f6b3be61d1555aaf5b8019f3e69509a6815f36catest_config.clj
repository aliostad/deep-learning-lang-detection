(ns slipstream.ui.test-config
  "Manage a test config file and retrieve values from it.
  Conceived to maintain basic config for dev and prod.
  The file test_config.edn is intended to be ignored by git."
  (:require [clojure.edn :as edn]))

(def ^:private ^:const filename "clj/test/slipstream/ui/test_config.edn")

(def ^:private ^:const param-set :dev) ;; or :prod

(defn- available?
  [f]
  (-> f clojure.java.io/as-file .exists))

(defn- config-map
  [f]
  (when (available? f)
    (-> f
        slurp
        edn/read-string)))

(defn value
  ([param]
   (value param nil))
  ([param not-found]
   (get-in (config-map filename) [param-set param] not-found)))
