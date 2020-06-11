(ns title-sketch.private.config
  (:require [title-sketch.private.kvstore :as kv]
            [clojure.data.json :as json]))

(def ^:dynamic *config-ns* "config")
(def ^:dynamic *active-configs* "active-configs")


(defn active-configs
  []
  (-> *config-ns*
      (kv/kv-read *active-configs*)
      (json/read-str)))


(defn- manage-configs
  [config-name action]
  (let [current-configs (active-configs)]
    (case action
      "add" (kv/kv-write *config-ns* *active-configs* (conj current-configs
                                                            config-name))
      "remove" (kv/kv-write *config-ns* *active-configs* (->> current-configs
                                                              (filter #(not (= % config-name)))
                                                              (into []))))))
(defn create-config
  [config-name api-key base-url account-id version]
  (if (not (some #(= % config-name) (active-configs)))
    (do
      (kv/kv-write *config-ns*
                   config-name
                   {:api-key api-key
                    :base-url base-url
                    :account-id account-id
                    :version version})
      (manage-configs config-name "add"))
    (throw (Exception. (str "Config already exists.")))))

(defn get-config
  [config-name]
  (if (some #(= % config-name) (active-configs))
    (read-string (kv/kv-read *config-ns* config-name))
    (throw (Exception. (str "Config does not exist.")))))

(defn delete-config
  [config-name]
  (if (some #(= % config-name) (active-configs))
    (do
      (kv/kv-delete *config-ns* config-name)
      (manage-configs config-name "remove"))
    (throw (Exception. (str "Config does not exist.")))))

(defn update-config
  [config-name update-key new-value]
  (let [current-config (get-config config-name)
        new-config     (assoc current-config update-key new-value)]
    (kv/kv-write *config-ns* config-name new-config)))
