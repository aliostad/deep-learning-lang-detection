(ns fhofherr.simple.core.job-fn
  "Create and manage Simple CI job functions.

  A job function is the central element of a Simple CI job. In essence it is a
  function of that takes a [[job-execution-context]], manipulates it, and
  returns a modified version of it.

  Job functions are created by joining multiple job step functions using
  the [[make-job-fn]] function. This is the only way to create a job function."
  (:require [clojure.tools.logging :as log]
            [fhofherr.simple.core [job-execution-context :as ex-ctx]]))

(defn ^:dynamic *log-step-execution*
  "Log the execution of a job step. The deault implementation writes an info
  level message to Simple CI's log file. The return value of this function is
  ignored."
  [step-desc ctx]
  (if (ex-ctx/failed? ctx)
    (log/info (format "Step %s FAILED!" step-desc))
    (log/info (format "Step %s completed successfully." step-desc))))

(defn job-step-fn?
  "Test if `obj` is a job step function."
  [obj]
  (boolean (::job-step-fn? (meta obj))))

(defn job-step-description
  "Obtain the description of a job step function."
  [obj]
  {:pre [(job-step-fn? obj)]}
  (::job-step-description (meta obj)))

(defn make-job-step-fn
  "Create a job step function."
  [description f]
  {:pre [(fn? f)]}
  (letfn [(step-fn [ctx]
            {:pre [(ex-ctx/job-execution-context? ctx)]}
            (try
              (let [new-ctx (f ctx)]
                (*log-step-execution* description new-ctx)
                new-ctx)
              (catch Throwable t
                (let [new-ctx (ex-ctx/mark-failed ctx)
                      msg (format "Exception while executing step '%s'."
                                  description)]
                  (log/warn t msg)
                  (*log-step-execution* description new-ctx)
                  new-ctx))))]
    (with-meta step-fn {::job-step-fn? true
                        ::job-step-description description})))

(defn job-fn?
  "Check if the given object is a Simple CI job."
  [obj]
  (boolean (::job-fn? (meta obj))))

(defn- apply-step
  [f ignore-failure? ctx]
  (if (and f
           (or ignore-failure? (not (ex-ctx/failed? ctx))))
    (f ctx)
    ctx))

(defn make-job-fn
  "Combine the given job steps to a job function. The job steps are
  passed as a map to `make-job-fn` using the following keys:

  * `:test`: the actual test to execute.

  * `:before`: set up code to execute before the `:test`. If `:before` fails
    `:test` and `:after` will not be executed.

  * `:after`: tear down code to execute after the `:test`. The `:after`
     steps will be executed even if `:before` or `:test` fail.

  All of those keys are optional. If all keys are missing the job does nothing.

  The job steps passed to `make-job-fn` have to satisfy the [[job-step-fn?]]
  predicate.

  See [[make-job-step-fn]] for details about job steps."
  [{:keys [test before after]}]
  (when (some #(and ((complement nil?) %)
                    ((complement job-step-fn?) %))
              [test before after])
    (throw (IllegalArgumentException.
            "The values for :test, :before, and :after must be job step functions")))
  (letfn [(job [ctx]
            (io!
             (->> ctx
                  (apply-step before false)
                  (apply-step test false)
                  (apply-step after true))))]
    (vary-meta job assoc ::job-fn? true)))
