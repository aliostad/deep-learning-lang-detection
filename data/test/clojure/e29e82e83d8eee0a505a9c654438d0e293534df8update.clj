; Copyright © 2013 - 2016 Dr. Thomas Schank <Thomas.Schank@AlgoCon.ch>
; Licensed under the terms of the GNU Affero General Public License v3.
; See the "LICENSE.txt" file provided with this software.

(ns cider-ci.server.repository.web.projects.update
  (:refer-clojure :exclude [str keyword])
  (:require [cider-ci.utils.core :refer [keyword str]])

  (:require

    [clojure.java.jdbc :as jdbc]
    [cider-ci.utils.rdbms :as rdbms]
    [schema.core :as schema]
    [cider-ci.utils.duration :as duration]
    [cider-ci.server.repository.state.repositories :as state.repositories]
    [logbug.debug :as debug]
    [logbug.catcher :as catcher]
    [clj-logging-config.log4j :as logging-config]
    [clojure.tools.logging :as logging]
    ))


(def DurationOrNull (schema/maybe
                      (schema/both
                        String
                        (schema/pred duration/valid? 'duration))))

(def NotBlank
  (schema/both
    String
    (schema/pred (complement clojure.string/blank?) 's)))

(def NotBlankOrNull
  (schema/maybe NotBlank))

(def schema
  {(schema/optional-key :branch_trigger_exclude_match) String
   (schema/optional-key :branch_trigger_include_match) String
   (schema/optional-key :branch_trigger_max_commit_age) DurationOrNull
   (schema/optional-key :cron_trigger_enabled) Boolean
   (schema/optional-key :git_url) NotBlank
   (schema/optional-key :manage_remote_push_hooks) Boolean
   (schema/optional-key :name) NotBlank
   (schema/optional-key :public_view_permission) Boolean
   (schema/optional-key :remote_api_endpoint) NotBlankOrNull
   (schema/optional-key :remote_api_name) NotBlankOrNull
   (schema/optional-key :remote_api_namespace) NotBlankOrNull
   (schema/optional-key :remote_api_token) NotBlankOrNull
   (schema/optional-key :remote_api_token_bearer) NotBlankOrNull
   (schema/optional-key :remote_api_type) (schema/maybe (schema/enum "github" "gitlab"))
   (schema/optional-key :remote_fetch_interval) DurationOrNull
   (schema/optional-key :send_status_notifications) Boolean
   (schema/optional-key :update_notification_token) NotBlank })

(defn- check [params]
  (schema/check schema params))

(defn- update-project! [id params]
  (or (= 1 (first (jdbc/update!
                    (rdbms/get-ds) :repositories
                    params ["id = ?" id])))
      (throw (ex-info "Persisting the project update failed!" {}))))

(defn update-project [request]
  (let [params (-> request :body clojure.walk/keywordize-keys (dissoc :id))]
    (if-not (-> request :authenticated-entity :scope_admin_write)
      {:status 403 :body  "Only admins can update projects!"}
      (if-let [invalid (check params)]
        {:status 422 :body (str  "The request parameters are not valid: " invalid)}
        (do (update-project! (-> request :route-params :id) params)
            (state.repositories/update-repositories)
            {:status 200
             :body {:message "updated"}})))))

;### Debug ####################################################################
;(logging-config/set-logger! :level :debug)
;(logging-config/set-logger! :level :info)
;(debug/debug-ns *ns*)
