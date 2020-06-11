(ns ymizushi-info.manage
  (:require
    [ymizushi-info.config :as config]
    [clojure.java.jdbc :as sql]))

(defn create-admin-users []
  (sql/create-table :admin_users
    [:id :serial "PRIMARY KEY"]
    [:name :varchar "NOT NULL"]
    [:mail_address :varchar "NOT NULL"]
    [:password :varchar "NOT NULL"]
    [:updated_at :timestamp "NOT NULL" "DEFAULT CURRENT_TIMESTAMP"]
    [:created_at :timestamp "NOT NULL" "DEFAULT CURRENT_TIMESTAMP"]))

(defn create-comments []
  (sql/create-table :comments
    [:id :serial "PRIMARY KEY"]
    [:blog_id :int "NOT NULL"]
    [:author :varchar "NOT NULL"]
    [:description :varchar "NOT NULL"]
    [:updated_at :timestamp "NOT NULL" "DEFAULT CURRENT_TIMESTAMP"]
    [:created_at :timestamp "NOT NULL" "DEFAULT CURRENT_TIMESTAMP"]))

(defn create-tags []
  (sql/create-table :tags
    [:id :serial "PRIMARY KEY"]
    [:name :varchar "NOT NULL"] ;index張る
    [:blog_id :varchar "NOT NULL"]
    [:updated_at :timestamp "NOT NULL" "DEFAULT CURRENT_TIMESTAMP"]
    [:created_at :timestamp "NOT NULL" "DEFAULT CURRENT_TIMESTAMP"]))

(defn create-blogs []
  (sql/create-table :blogs
    [:id :serial "PRIMARY KEY"]
    [:title :varchar "NOT NULL"]
    [:description :varchar "NOT NULL"]
    [:updated_at :timestamp "NOT NULL" "DEFAULT CURRENT_TIMESTAMP"]
    [:created_at :timestamp "NOT NULL" "DEFAULT CURRENT_TIMESTAMP"]))

(defn create-db []
  (create-admin-users)
  (create-comments)
  (create-tags)
  (create-blogs))

(defn drop-db []
  (sql/drop-table :admin_users)
  (sql/drop-table :comments)
  (sql/drop-table :tags)
  (sql/drop-table :blogs))

(defn init-db []
  (sql/with-connection
    config/db-url
    (drop-db)))

(defn setup-db []
  (sql/with-connection
    config/db-url
    (create-db)))

(defn -main []
  (setup-db))
