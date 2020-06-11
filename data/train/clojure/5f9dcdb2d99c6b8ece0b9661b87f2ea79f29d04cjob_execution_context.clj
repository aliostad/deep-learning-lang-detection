(ns fhofherr.simple.core.job-execution-context
  "Create and manage job execution contexts.

  A job execution context holds all information relevant to an execution
  of a job. It belongs to exactly one [[job-execution]]. Job execution
  contexts are not shared between job executions. During its lifetime the job
  execution context may transition through the following states:

  * *created*: the job execution context has just been created.
  * *executing*: the job execution that owns the job execution context is
    is currently executing.
  * *successful*: all steps of the job were completed successfuly during the
    job execution to which this context belongs.
  * failed*: at least one job step failed."
  (:require [fhofherr.simple.core.status-model :as sm]))

(def ^:private state-transitions {::created #{::executing}
                                  ::executing #{::failed ::successful}
                                  ::successful #{}
                                  ::failed #{}})

(def ^:private available-states (-> state-transitions
                                    (keys)
                                    (set)))

(defrecord ^{:no-doc true} JobExecutionContext [project-dir state]

  sm/Stateful
  (current-state [^JobExecutionContext this] (:state this))
  (state-valid? [^JobExecutionContext this s] (contains? available-states s))
  (force-state [^JobExecutionContext this s] (assoc this :state s))
  (transition-possible? [this next-state]
    {:pre [(sm/state-valid? this next-state)]}
    (as-> (sm/current-state this) $
          (get state-transitions $)
          (contains? $ next-state))))

(alter-meta! #'->JobExecutionContext assoc :no-doc true)
(alter-meta! #'map->JobExecutionContext assoc :no-doc true)

(defn job-execution-context?
  "Check if the given object `obj` is a job execution context."
  [obj]
  (instance? JobExecutionContext obj))

(defn make-job-execution-context
  "Initial context of a job execution."
  [project-dir]
  (map->JobExecutionContext {:project-dir project-dir
                             :state ::created}))

(defn created?
  "Check if `ex-ctx`s state is *created*."
  [^JobExecutionContext ex-ctx]
  (= ::created (sm/current-state ex-ctx)))

(defn mark-executing
  "Mark `ex-ctx`s as *executing*."
  [^JobExecutionContext ex-ctx]
  (sm/transition-to-state ex-ctx ::executing))

(defn executing?
  "Check if `ex-ctx`s state is *executing*."
  [^JobExecutionContext ex-ctx]
  (= ::executing (sm/current-state ex-ctx)))

(defn mark-successful
  "Mark `ex-ctx`s as *successful*."
  [^JobExecutionContext ex-ctx]
  (sm/transition-to-state ex-ctx ::successful))

(defn successful?
  "Check if `ex-ctx`s state is *successful*."
  [^JobExecutionContext ex-ctx]
  (= ::successful (sm/current-state ex-ctx)))

(defn mark-failed
  "Mark `ex-ctx`s as *failed*."
  [^JobExecutionContext ex-ctx]
  (sm/transition-to-state ex-ctx ::failed))

(defn failed?
  "Check if `ex-ctx`s state is *failed*."
  [^JobExecutionContext ex-ctx]
  (= ::failed (sm/current-state ex-ctx)))
