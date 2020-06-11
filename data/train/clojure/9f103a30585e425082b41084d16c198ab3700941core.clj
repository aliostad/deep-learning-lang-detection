(ns unicron.core
  "Main application loop; load config, manage scheduler state"
  {:author "Matt Halverson", :date "Wed Aug 27 13:58:01 PDT 2014"}
  (:require [unicron.feed :as f]
            [unicron.scheduler :as s]
            [unicron.config :as cfg]))

;; # Cfg

(defn- feeds-cfg []
  (cfg/read-feeds-cfg))

(defn- create-history []
  (cfg/make-history-from-cfg))

;; # App lifecycle

(defn create-instance [& {:keys [history feeds-sexps]}]
  (let [h (or history
              (create-history))
        env {:history h}
        fc (or feeds-sexps (feeds-cfg))
        parsed-feeds (map #(f/interp-feed % env) fc)]
    {:history h
     :parsed-feeds parsed-feeds}))

(defn start [app]
  (s/init-scheduler!)
  (s/start-scheduler!)
  (let [parsed-feeds (:parsed-feeds app)]
    (s/schedule-jobs parsed-feeds)))

(defn stop [app]
  (s/pause-scheduler!)
  (s/clear-scheduler!)
  (s/shutdown-scheduler!))

(defn reload-cfg [existing-app]
  (stop existing-app)
  (let [new-app (create-instance)]
    (start new-app)
    new-app))

;; # Main

(defn -main [& args]
  (let [app (create-instance)]
    (start app)))
