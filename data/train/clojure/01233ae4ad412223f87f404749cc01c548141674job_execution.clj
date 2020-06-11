(ns fhofherr.simple.core.job-execution
  "Create and manage job executions.

  Job executions represent a single execution of a Simple CI job. A job
  execution owns a [[job-descriptor]]. During its lifetime a job execution
  transitions through the following states:

  * *created*: the job execution has just been created.
  * *queued*: the job execution has been queued for execution. It has not been
    executed yet.
  * *executing*: the job execution is currently executing.
  * *finished*: the job execution is finished executing."
  (:require [fhofherr.simple.core [status-model :as sm]
             [job-execution-context :as ex-ctx]]))

(def ^:private possible-state-transitions {::created #{::queued}
                                           ::queued #{::executing}
                                           ::executing #{::finished}})

(def ^:private available-states (-> possible-state-transitions
                                    (keys)
                                    (set)))

(defrecord ^{:no-doc true} JobExecution [state context]

  sm/Stateful
  (current-state [^JobExecution this] (:state this))

  (state-valid? [^JobExecution this s] (contains? available-states s))

  (force-state [^JobExecution this s]
    {:pre [(sm/state-valid? this s)]}
    (assoc this :state s))

  (transition-possible? [^JobExecution this s]
    {:pre [(sm/state-valid? this s)]}
    (as-> this $
          (sm/current-state $)
          (get possible-state-transitions $)
          (contains? $ s))))

(alter-meta! #'->JobExecution assoc :no-doc true)
(alter-meta! #'map->JobExecution assoc :no-doc true)

(defn job-execution?
  "Check if `obj` is a job execution"
  [obj]
  (instance? JobExecution obj))

(defn make-job-execution
  "Create a new job execution and make it owner of the job execution
  context `ctx`."
  [ctx]
  (map->JobExecution {:context ctx
                      :state ::created}))
(defn created?
  "Check if `job-exec`s state is *created*."
  [^JobExecution job-exec]
  (= ::created (sm/current-state job-exec)))

(defn mark-queued
  "Mark `job-exec` as *queued*."
  [^JobExecution job-exec]
  (sm/transition-to-state job-exec ::queued))

(defn queued?
  "Check if `job-exec`s state is *queued*."
  [^JobExecution job-exec]
  (= ::queued (sm/current-state job-exec)))

(defn update-context
  "Apply the function `f` job the job execuction `job-exec`'s job execution
  context. Replace the old context with the new one returned by `f`."
  [^JobExecution job-exec f & args]
  (letfn [(apply-f [ctx]
            {:post [(ex-ctx/job-execution-context? %)]}
            (apply f ctx args))]
    (update-in job-exec [:context] apply-f)))

(defn mark-executing
  "Mark `job-exec` as *executing*."
  [^JobExecution job-exec]
  (as-> job-exec $
        (update-context $ ex-ctx/mark-executing)
        (sm/transition-to-state $ ::executing)))

(defn executing?
  "Check if `job-exec`s state is *executing*."
  [^JobExecution job-exec]
  (= ::executing (sm/current-state job-exec)))

(defn mark-finished
  "Mark `job-exec` as *finished*."
  [^JobExecution job-exec]
  (letfn [(update-ctx [ctx] (if (ex-ctx/failed? ctx)
                              ctx
                              (ex-ctx/mark-successful ctx)))]
    (as-> job-exec $
          (update-context $ update-ctx)
          (sm/transition-to-state $ ::finished))))

(defn finished?
  "Check if `job-exec`s state is *finished*."
  [^JobExecution job-exec]
  (= ::finished (sm/current-state job-exec)))
