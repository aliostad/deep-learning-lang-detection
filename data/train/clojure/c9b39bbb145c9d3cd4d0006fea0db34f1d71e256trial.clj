(ns experiment.models.trial
  (:use
   experiment.infra.models
   experiment.models.core
   experiment.models.user)
  (:require
   [clj-time.core :as time]
   [experiment.infra.session :as session]
   [experiment.libs.datetime :as dt]
   [experiment.models.schedule :as schedule]))

;; ===========================================================
;; TRIAL
;;  refs User
;;  refs Experiment
;;  has outcome #[notstart, abandon, success, fail, uncertain]
;;  log [action ...] #[start, pause, unpause, end]
;;  schedule []
;;  

(defmethod db-reference-params :trial [model]
  [:experiment :user])

(defmethod public-keys :trial [model]
  [:user :experiment
   :schedule :status :status_str
   :donep :pausedp :end_str :reminders :start :start_str :stats])

(defmethod import-keys :trial [model]
  [:user :experiment :schedule :reminders :status :start])

(defn human-status [trial]
  ({:active "Active"
    :paused "Paused"
    :abandoned "Abandoned"
    :completed "Completed"
    nil "Unknown"}
   (keyword (:status trial))))

(defn trial-done? [trial]
  (when (#{"abandoned" "completed"} (:status trial)) true))

(defn trial-paused? [trial]
  (if (#{"paused"} (:status trial)) true false))

(defmethod server->client-hook :trial [trial]
  (assoc trial
    :status_str (human-status trial)
    :stats {:elapsed 21
            :remaining 7
            :intervals 1}
    :start (dt/as-iso (:start trial))
    :start_str (dt/as-short-date (:start trial))
    :donep (trial-done? trial)
    :pausedp (trial-paused? trial)
    :end_str (when-let [end (:end trial)] (dt/as-short-string (dt/from-date end)))))

(defmethod client->server-hook :trial [trial]
  (assoc trial
    :start (dt/from-iso (:start trial) time/utc)))


(defn lookup-trial
  "Get trial from the user or session user if model is a string submodel id"
  [id]
  (get-trial (session/current-user) (keyword id)))

(defn trial-user [trial]
  (resolve-dbref (:user trial)))

(defn trial-experiment [trial]
  (resolve-dbref (:experiment trial)))

(defn trial-outcome
  "Trial -> Instrument (outcome instrument for trial)"
  [trial]
  (resolve-dbref (first (:outcome (trial-experiment trial)))))

(defn trial-trackers [trial]
  (let [instruments (instruments (trial-experiment trial))
        in-instruments? (fn [elt] (some #(= elt %) instruments))]
    (filter (comp in-instruments? :instrument)
            (trackers (trial-user trial)))))

(defn trial-schedule [trial]
  (let [exp (trial-experiment trial)]
    (merge (:schedule exp)
           (select-keys trial [:experiment :start]))))

(defn trial-periods
  ([trial]
     (schedule/periods
      (trial-schedule trial)))
  ([trial interval]
     (schedule/periods-overlapping
      nil interval (trial-periods trial))))

(defn baseline-period? [period] (= (:label period) "base"))
(defn treatment-period? [period] (not (baseline-period? period)))

(defn treatment-periods 
  ([periods]
     (filter treatment-period? periods))
  ([periods interval]
     (treatment-periods 
      (schedule/periods-overlapping
       nil interval periods))))

(defn baseline-periods 
  ([periods]
     (filter baseline-period? periods))
  ([periods interval]
     (baseline-periods 
      (schedule/periods-overlapping
       nil interval periods))))

(defn reminder-events [trial interval]
  (let [refs (select-keys trial [:user :experiment])]
    (map #(merge % refs)
         (schedule/events (trial-schedule trial) interval))))
  
(defn all-reminder-events [user interval]
  (mapcat #(reminder-events % interval) (trials user)))


