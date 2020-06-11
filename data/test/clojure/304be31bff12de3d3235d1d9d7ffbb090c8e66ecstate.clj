; Copyright © 2013 - 2016 Dr. Thomas Schank <Thomas.Schank@AlgoCon.ch>
; Licensed under the terms of the GNU Affero General Public License v3.
; See the "LICENSE.txt" file provided with this software.

(ns cider-ci.ex.trials.state
  (:require
    [cider-ci.ex.trials.helper :refer :all]
    [cider-ci.utils.config :as config :refer [get-config parse-config-duration-to-seconds]]
    [cider-ci.utils.daemon :as daemon :refer [defdaemon]]
    [clj-logging-config.log4j :as logging-config]
    [clj-time.core :as time]
    [clojure.data.json :as json]
    [clojure.tools.logging :as logging]
    [logbug.catcher :as catcher]
    [logbug.debug :as debug]
    [logbug.thrown :as thrown]
    )
  (:import
    [java.io File]
    ))


;#### keep and manage state of trials #########################################

(defonce ^:private trials-atom
  (atom {}))

;(spit "tmp/trials-atom.json" (json/write-str @trials-atom))

(defn get-trial [id]
  "Returns the entity stored in the trials-atom if it exists or nil otherwise.
  The properties of the trial can be retrived (-> trial :params-atom deref)
  or more conveniently via get-trial-properties."
  (@trials-atom id))

(defn get-trial-properties [id]
  "Returns the current properties of the trial or nil if it is not found.
  Use get-trial to access all attributes."
  (when-let [trial (get-trial id)]
    (-> trial :params-atom deref)))

(defn get-trials-properties []
  "Returns a sequence of the not yet discarded trials of any state.
  Each in the same format as in the get-trial properties."
  (->> @trials-atom
      seq
      (map #(-> % second :params-atom deref))))

(defn create-trial
  "Creates a new trial, stores it in trials under its id and returns the trial"
  [params]
  (let [id (:trial_id params)
        params (assoc params
                      :scripts (->> (:scripts params)
                                    (map (fn [script-prams]
                                           [(:key script-prams) (atom script-prams)]))
                                    (into {}))
                      :started_at (time/now))]
    (swap! trials-atom
           (fn [trials params id]
             (conj trials {id {:params-atom (atom  params)
                               :report-agent (agent [] :error-mode :continue)}}))
           params id)
    (@trials-atom id)))



;### sweep ####################################################################

(defn- trial-retention-duration []
  (or (catcher/snatch {}
        (parse-config-duration-to-seconds :trial_retention_duration))
      (* 60 30)))

(defn- trials-to-be-swept  []
  (->> @trials-atom
       (map second)
       (map :params-atom)
       (map deref)
       (filter :finished_at)
       (filter #(time/before?
                  (:finished_at %)
                  (time/minus (time/now)
                              (time/seconds
                                (trial-retention-duration)))))))

(defn- sweep []
  (doseq [trial (trials-to-be-swept)]
    (swap! trials-atom
           (fn [current trial]
             (dissoc current (:trial_id trial)))
           trial)))

(defdaemon "sweep" 10 (sweep))

(defn initialize []
  (start-sweep))

;### Debug ####################################################################
;(logging-config/set-logger! :level :debug)
;(logging-config/set-logger! :level :info)
;(debug/debug-ns 'cider-ci.auth.http-basic)
;(debug/debug-ns *ns*)

