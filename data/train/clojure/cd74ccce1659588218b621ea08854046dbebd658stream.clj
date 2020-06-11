(ns beavis.stream
  (:require [clojure.tools.logging :as log]
            [clojure.string :as str]
            [opsee.middleware.core :refer [report-exception]])
  (:import (java.util.concurrent ForkJoinPool ForkJoinTask)
           (java.sql BatchUpdateException)))

(defprotocol ManagedStage
  "Stream stages extending the ManagedStage protocol can initialize or cleanup any resources
  that they might require."
  (start-stage! [this next]
    "This method starts any connections needed for submitting work into the pipeline.
    Next is an fn that takes a single parameter, a mapified version of a CheckResult.
    Start-producer! is called from the main thread and is expected not to block.")
  (stop-stage! [this]
    "Stop method for any resources this stage may manage. The pipeline guarantees that no
    other calls to submit will be active when stop-stage! gets called."))

(defprotocol StreamStage
  "StreamStages perform transformations on CheckResults. Anything wishing to operate on
  CheckResults should implement StreamStage. StreamStages are then composed together
  via the pipeline function."
  (submit [this work]
    "Submit implements the work that this stream stage is meant to perform. Generally, submit
    should not block and you cannot make predictions about which thread will be calling.
    Submit must also be threadsafe."))

(defn task [work stage counts index total]
  (proxy [ForkJoinTask] []
    (exec []
      (try
        (submit stage work)
        (catch BatchUpdateException ex (do
                                         (log/error ex (str "stage " stage " ate shit."))
                                         (log/error (.getNextException ex))))
        (catch Throwable ex
          (do
            (log/error ex (str "stage " stage " ate shit."))
            (report-exception ex)))
        (finally (when (= index (dec total))
                   (swap! counts dec)))))))

(defn make-callback [^ForkJoinPool pool stage counts next-index total]
  (fn [work]
    (when (= 1 next-index)
      (swap! counts inc))
    (if stage
      (let [t (task work stage counts next-index total)]
        (.execute pool t)))))

(defn- pipeline-callbacks [^ForkJoinPool pool stages counts]
  (let [total (count stages)]
    (loop [index (count stages)
           stage nil
           stages (reverse stages)
           callbacks nil]
      (let [callbacks' (cons
                         [(first stages) (make-callback pool stage counts index total)]
                         callbacks)]
        (if (not-empty stages)
          (recur (- index 1)
                 (first stages)
                 (rest stages)
                 callbacks')
          callbacks)))))

(defn trunc [s n]
  (if (> (count s) n)
    (str (subs s 0 n) "...")
    s))

(defn log-body [body]
  (-> body
      (str/escape {\newline "\\n"})
      (trunc 200)))

(defn event-for-logging [event]
  (cond
    (:responses event) (update event :responses
                               (partial map #(if (get-in % [:response :value :body])
                                              (update-in % [:response :value :body] log-body)
                                              %)))
    (:response event) (update-in event [:response :value :body] log-body)
    :else event))

(defn- wait-for-drain [counts]
  (loop []
    (when (not= 0 @counts)
      (Thread/sleep 1000)
      (recur))))

(defprotocol Pipeline
  (start-pipeline-async! [this])
  (start-pipeline! [this])
  (stop-pipeline! [this]))

(defn startup-task [pipeline]
  (proxy [ForkJoinTask] []
    (exec []
      (try
        (start-pipeline! pipeline)
        (catch Exception ex
          (log/error ex "problem starting pipeline")
          (report-exception ex))))))

(defn pipeline [producer & stages]
  (let [pool (ForkJoinPool.)
        count (atom 0)
        callbacks (pipeline-callbacks pool (cons producer stages) count)]
    (reify Pipeline
      (start-pipeline-async! [this]
        (.execute pool (startup-task this)))
      (start-pipeline! [_]
        (doseq [[stage callback] callbacks]
          (if (satisfies? ManagedStage stage)
            (start-stage! stage callback))))
      (stop-pipeline! [_]
        ;first stop the producer which will wait until it's drained
        (stop-stage! producer)
        (let [idv (map vector (iterate inc 0) stages)]
          (wait-for-drain count)
          (doseq [[index stage] idv]
            (when (satisfies? ManagedStage stage)
              (stop-stage! stage))))
        ;then tell the fjp to stop accepting tasks
        (.shutdown pool)))))