(ns playground.state-manage
  (:require [clj-time.core :as time]))

(def valid-states #{:created :dispatching :accepted :finished :failed})

(def state-transfer-map {:created #{:dispatching :failed}
                         :dispatching #{:dispatching :failed :accepted}
                         :accepted #{:finished :failed}
                         :finished #{}
                         :failed #{}})

(defn valid-state-transfer? [src-state dest-state]
  (contains? (get state-transfer-map src-state #{}) dest-state))


;; (.unbindRoot #'change-state)
;; (remove-all-methods change-state)
;; (
 ;; remove-method change-state :dispatching)

(defn dispatch-fn [job state & {:keys [taxi reason] :or [nil nil]}]
  (if (valid-state-transfer? (:state @job) state)
    (do
      (swap! job assoc :state state :update-time (time/now))
      state)
    :unsupport))


(defmulti change-state #'dispatch-fn)

(defmethod change-state :failed [job state & {:keys [taxi reason] :or [nil nil]}]
  {:pre [(not (nil? reason))]}
  (swap! job assoc :reason reason))

(defmethod change-state :accepted [job state & {:keys [taxi reason] :or [nil nil]}]
  {:pre [(not (nil? taxi))]}
  (swap! job assoc :taxi taxi))

(defmethod change-state :unsupport [job state & {:keys [taxi reason] :or [nil nil]}]
  (throw (Exception. (format "State transfer from %s to %s not supported." (:state @job) state))))

(defmethod change-state :default [job state & {:keys [taxi reason] :or [nil nil]}])

:state-manage
