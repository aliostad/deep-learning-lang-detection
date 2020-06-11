; Copyright © 2013 - 2016 Dr. Thomas Schank <Thomas.Schank@AlgoCon.ch>
; Licensed under the terms of the GNU Affero General Public License v3.
; See the "LICENSE.txt" file provided with this software.

(ns cider-ci.repository.push-hooks.core
  (:refer-clojure :exclude [str keyword])
  (:require [cider-ci.utils.core :refer [keyword str]])
  (:require
    [cider-ci.repository.push-hooks.github :as github]
    [cider-ci.repository.push-hooks.shared :refer [db-get-push-hook db-update-push-hook]]
    [cider-ci.repository.remote :refer [api-access? api-type]]
    ;[cider-ci.repository.shared :refer :all]
    [cider-ci.repository.state :as state]
    [cider-ci.utils.daemon :refer [defdaemon]]
    [cider-ci.utils.rdbms :as rdbms]
    [cider-ci.utils.row-events :as row-events]
    [clj-time.core :as time]
    [clojure.java.jdbc :as jdbc])
  (:require
    [clj-logging-config.log4j :as logging-config]
    [clojure.tools.logging :as logging]
    [logbug.catcher :as catcher :refer [snatch]]
    [logbug.debug :as debug :refer [I> I>> identity-with-logging]]
    [logbug.thrown :as thrown]
    ))

(defn catch-setup-and-check-error [e]
  (fn [state]
    (assoc state
           :state "error"
           :hook nil
           :last_error (str e)
           :last_error_at (time/now))))

(defn dispatch-setup-and-check [repository]
  (snatch
    {:return-fn catch-setup-and-check-error}
    (condp = (api-type repository)
      "github" (do (db-update-push-hook
                     (:id repository) #(assoc % :state "checking"))
                   (let [hook (github/setup-and-check-pushhook repository)]
                     #(merge % hook)))
      #(assoc % {:state "unavailable"}))))

(defn set-up-and-check [repository]
  (let [update-fn (cond (-> repository :manage_remote_push_hooks
                            not) #(assoc % :state "disabled")
                        (-> repository api-access?
                            not) #(assoc % :state "unaccessible")
                        :else (dispatch-setup-and-check repository))]
    (db-update-push-hook (:id repository) update-fn)))

;(set-up-and-check (first (map second (:repositories (state/get-db)))))

(defn set-up-and-check-all []
  (doseq [repository (map second (:repositories (state/get-db)))]
    (set-up-and-check repository)))


;### Listen to job updates ####################################################

(defn wait-for [wait-fn]
  (let [wait-until (time/plus (time/now) (time/seconds 3))]
    (loop [waited-for (wait-fn)]
      (if (not (nil? waited-for))
        waited-for
        (when (time/before? (time/now) wait-until)
          (recur (do (Thread/sleep 50) (wait-fn))))))))

(defn evaluate-repository-event [repository-id]
  (when-let [repository
             (wait-for #(-> (state/get-db) :repositories
                            (get (keyword repository-id))))]
    (set-up-and-check repository)))


(def last-processed-repository-event (atom nil))

(defdaemon "process-repository-events" 1
  (row-events/process "repository_events" last-processed-repository-event
                      (fn [row] (evaluate-repository-event (:repository_id row)))))


;### Listen to job updates ####################################################

(defn initialize []
  (future (set-up-and-check-all))
  (start-process-repository-events))


;#### debug ###################################################################
;(logging-config/set-logger! :level :debug)
;(logging-config/set-logger! :level :info)
;(debug/debug-ns *ns*)
