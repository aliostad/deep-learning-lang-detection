(ns playground.dispatcher
  (:require [gocatch.subsystems.utils :refer [distance-between ignore-errors]]
            [clojure.set :refer [intersection]])
  (:require [clojure.core.async :as async :refer [go chan <! >! go-loop timeout]])
  (:require [playground.taxis :refer [get-taxis-for-job max-distance]])
  (:require [playground.state-manage :refer [change-state]]))

(def default-dispatch-interval 5000)
(def max-job-waiting-time 500000)

(def dispatches (atom {}))
(def jobs (atom {}))

(defn- get-nearest-taxis-wrapper []
  (fn [job taxis]
    (let [lat (@job :lat) lng (@job :lng)
          distance-to (partial distance-between [lat lng])
          taxis (vals (deref taxis))
          selected (filter (fn [taxi]
                             (> max-distance (distance-to [(@taxi :lat ) (@taxi :lng)])))
                           taxis)]
      (println taxis)
      (println (map deref selected))
      selected)))

(def
  ^{:arglists '([job taxis])}
  nearest-distance-strategy
  "Public access method to get list of taxis near location to specified distance"
  (get-nearest-taxis-wrapper))


(defn- update-taxi-with-job! [job taxi]
  (when (not (@dispatches (:name @taxi)))
    (swap! dispatches assoc (:name @taxi) (atom {})))
  (if (= :dispatching (@job :state))
    (swap! (@dispatches (:name @taxi)) assoc (@job :id) job)))


(defn dispatch! [job taxis strategy]
  (println "dispatch job" (@job :id)
           "\nAvailable taxis: " taxis
           "\nStrategy: " strategy)
  (let [taxis (strategy job taxis)]
    (doseq [taxi taxis]
      (update-taxi-with-job! job taxi))))


;; (def taxis (get-taxis-for-job ""))
;; (do @taxis)
;; (def job (atom {:id 1 :name :Peter :state :created :lat 0 :lng 0}))
;; (def taxis (nearest-distance-strategy job taxis))
;; (dispatch! job taxis nearest-distance-strategy)

(defn valid-job-state? [job]
  (println (contains? #{:created :dispatching} (:state @job)))
  (contains? #{:created :dispatching} (:state @job)))

(defn timeout-dispatch? [dispatch]
  (>= (- (System/currentTimeMillis) (:created-time @dispatch)) max-job-waiting-time))

(defn valid-job-to-dispatch? [job]
  (and
   (not (timeout-dispatch? job))
   (valid-job-state? job)))

(defn delete-dispatch! [dispatch]
  swap! dispatches dissoc (@dispatch :id))

;; (defn dispatch-a-job [job & strategy]
;;   (let [dispatch (create-dispatch! job) 
;;         taxis (get-taxis-for-job job)
;;         strategy (or strategy
;;                      default-strategy)
;;         begin (System/currentTimeMillis)]
;;     (println @dispatch)
;;     (go-loop [job dispatch]
;;       (when (valid-job-to-dispatch? job) 
;;         (println @job)
;;         (println "Start to create a dispatch for " (@job :id))
;;         (dispatch! job taxis strategy)
;;         (<! (timeout default-dispatch-interval))
;;         (println @job)
;;         (recur job)))))

(defn find-strategy-for-job [job]
  nearest-distance-strategy)

(defn dispatch-a-job [job]
  (let [strategy (find-strategy-for-job job)
        taxis (get-taxis-for-job job)]
    (go-loop []
      (println @job)
      (change-state job :dispatching)
      (if (timeout-dispatch? job)
        (change-state job :failed :reason "Dispatching Timedout")
        (if (valid-job-state? job)
          (do
            (dispatch! job taxis strategy)
            (<! (timeout default-dispatch-interval))
            (recur)))
      ;; (when (valid-job-to-dispatch? job) 
      ;;   (println @job)
      ;;   (println "Start to create a dispatch for " (@job :id))
      ;;   (dispatch! job taxis strategy)
      ;;   (<! (timeout default-dispatch-interval))
      ;;   (println @job)
      ;;   (recur job))
      ))))


(defn get-available-jobs-by-taxi [taxi]
  (vals @(@dispatches taxi)))


;; ( dispatch-a-job (playground.job/make-job "1" "Peter" 1 1))

;; (def a [{:id 1} {:id 2 :name "a"}])
;; @dispatches


;; (def job (atom {:id 1 :name "Peter" :lat 0 :lng 0 :state :created :created-time (System/currentTimeMillis)}))
;; (dispatch-a-job job)
