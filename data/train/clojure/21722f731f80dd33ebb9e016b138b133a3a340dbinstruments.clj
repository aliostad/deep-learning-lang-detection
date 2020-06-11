(ns experiment.models.instruments
  (:use experiment.infra.models
        experiment.models.samples
        clojure.math.numeric-tower)
  (:require [clj-time.core :as time]
            [clojure.tools.logging :as log]
            [experiment.models.user :as user]
            [experiment.infra.services :as services]
            [experiment.libs.datetime :as dt]
            [experiment.libs.zeo :as zeo]
            [experiment.libs.withings :as wi]
            [experiment.libs.strava :as strava]
            [experiment.libs.twitter :as twitter]
            [experiment.libs.fitbit :as fit]
            [experiment.libs.rescuetime :as rt]))

;;
;; Big ol file of instruments
;;
;; Connect 3rd party libraries to a mongo log and sql-based sample
;; set and provide an api to query instruments
;;

(def do-refresh-p false)

(defmacro safe-body [& body]
  `(try
     (do ~@body)
     (catch java.lang.Throwable error#
      (log/spy error#)
      nil)))

(defn get-instruments []
  (fetch-models :instrument))

(defn get-instrument [ref]
  (or (fetch-model "instrument" {:_id ref})
      (fetch-model "instrument" {:src ref})
      (fetch-model "instrument" {:name ref})))

;; Instrument Protocol
;; - last-update-received
;; - time-series (start, end, filter?)
;; - number-of-missed-records (start, end)
;; - refresh (pull from upstream server service)
;; - recompute (update time series DB, any derived measures)
;; - update (add new data - for manual instruments)
;; - reset (delete all data and fetch up to 1 month back)

(def ih (make-hierarchy))

(defmulti configured? (fn [i u] (keyword (:src i))) :hierarchy #'ih)
(defmulti last-update (fn [i u] (keyword (:src i))) :hierarchy #'ih)
(defmulti refresh (fn [i u & args] (keyword (:src i))) :hierarchy #'ih)
(defmulti reset (fn [i u] (keyword (:src i))) :hierarchy #'ih)
(defmulti time-series (fn [i u & args] (keyword (:src i))) :hierarchy #'ih)
(defmulti update (fn [i u d] (keyword (:src i))) :hierarchy #'ih)

;; Utils

(defn- sample-interval [inst]
  (if-let [mins (get-in inst [:sampling :period])]
    (time/minutes mins)
    (time/days 1)))

(defn- sample->pair [sample]
  [(:ts sample) (:v sample)])

(defn- stale?
  "Data hasn't been feched, or hasn't been updated after
   a certain time ago, 1 hour by default"
  [inst user]
  (let [lu (last-update inst user)]
    (or (not lu)
        (time/after?
         (time/minus (dt/now) (sample-interval inst))
         lu))))

(defn min-plot [inst]
  (when-let [min (:min-domain inst)] min))

(defn max-plot [inst]
  (when-let [max (:max-domain inst)] max))

(defn ordinal-values [inst]
  (when-let [domain (:domain inst)] domain))

;; Defaults

(defmethod last-update :default [instrument user]
  (last-updated-time user instrument))

(defmethod time-series :default [inst user & [start end convert?]]
  (when do-refresh-p
    (safe-body
     (refresh inst user)))
  (doall
   (get-samples user inst
                :start (or start (dt/a-month-ago))
                :end (or end (dt/now)))))

(defmethod refresh :default [inst user & [force?]]
  (log/warnf "Can't refresh object type %s" (:type inst)))

(defmethod reset :default [inst user]
  (rem-samples user inst))

(defmethod update :default [inst user data]
  (cond (map? data)
        (add-samples user inst [data])
        (sequential? data)
        (add-samples user inst data)))
        

;; ------------------------------------
;; Rescuetime-based Instruments
;; ------------------------------------

(defmethod configured? :rt [inst user]
  (and (services/get user :rt :apikey)
       (services/get user :rt :user)))

;; Social Media Usage on Rescuetime (value in seconds)

(defmacro rt-update [inst user force? [var] & body]
  `(let [i# ~inst
         u# ~user]
     (when (or ~force? (stale? i# u#))
       (rt/with-key (services/get u# :rt :apikey)
         (let [~var (or (last-update i# u#) ~force? (dt/a-month-ago))]
           ~@body))
       true)))

(defn seconds-to-hours [seconds]
  (assert (number? seconds))
  (/ (round (* (/ seconds 3600) 100)) 100.0))

(defn- socmed->series [[dt time people cat]]
  {:ts dt :v (seconds-to-hours time) :secs time})

(alter-var-root #'ih derive :rt-socmed-usage :rt)
(defmethod refresh :rt-socmed-usage
  [inst user & [force?]]
  (rt-update inst user force? [start]
     (let [data (rt/social-media "day" start (dt/now))]
       (update inst user (map socmed->series (:rows data))))))

(defn- efficiency->total [[dt total people eff]]
  {:ts dt :v (seconds-to-hours total) :secs total})

(defn- efficiency->eff [[dt total people eff]]
  {:ts dt :v eff})

(alter-var-root #'ih derive :rt-efficiency :rt)
(defmethod refresh :rt-efficiency
  [inst user & [force?]]
  (rt-update inst user force? [start]
     (let [data (rt/efficiency "day" start (dt/now))]
       (update inst user (map efficiency->eff (:rows data)))
       (update (get-instrument "rt-total") user
               (map efficiency->total (:rows data))))))

(alter-var-root #'ih derive :rt-total :rt)
(defmethod refresh :rt-total
  [inst user & [force?]]
  (refresh (get-instrument "rt-efficiency") user force?))

(defmacro ensure-instrument [[svc type] & body]
  (assert (keyword type))
  `(when (not (get-instrument ~type))
     (create-model!
      (merge
       {:type :instrument
        :src ~type
        :svc ~svc
        :comments []}
       ~@body))))

(defn ensure-rt-instruments []
  (ensure-instrument [:rescuetime :rt-socmed-usage]
    {:variable "Social Media Usage"
     :nicknames ["social media" "usage"]
     :sampling {:period (* 60 12) ;; 12 hours
                :chunksize :month}
     :description "Your social media usage as measured by rescuetime"})
  (ensure-instrument [:rescuetime :rt-efficiency]
    {:variable "Computer Work Efficiency"
     :nicknames ["online efficiency" "work efficiency"]
     :sampling {:period (* 60 12) ;; 12 hours
                :chunksize :month}
     :description "Your computer-based work efficiency as measured by rescuetime"})
  (ensure-instrument [:rescuetime :rt-total]
    {:variable "Total time on computers"
     :nicknames ["computer time"]
     :sampling {:period (* 60 12) ;; 12 hours
                :chunksize :month}
     :description "Total time on a rescutime enabled computer"})
  true)
          
;; ------------------------------------------
;; Withings Instruments (scale only)
;; ------------------------------------------

(defmethod configured? :withings [inst user]
  (and (wi/get-access-token user)
       (wi/get-access-secret user)
       (wi/get-userid user)))

(defn wi-inst-by-type [type]
  (fetch-model :instrument {:src-type type}))

(defn wi-sample [sample]
  (let [{:keys [date type value]} sample]
    (if date
      {:ts (dt/from-epoch date) :v value}
      (println sample))))

(defn add-wi-group [user [type samples]]
  (update (wi-inst-by-type type) user 
          (keep wi-sample samples)))

(defmethod refresh :withings
  [inst user & [force?]]
  (when (or force? (stale? inst user))
    (doall
     (map (partial add-wi-group user)
          (group-by
           :type
           (second
            (if force?
              (wi/user-measures user)
              (wi/user-measures user (or (last-update inst user) (time/epoch))))))))
    true))

(def wi-instruments
  [:wi-weight :wi-height :wi-lbm :wi-fat-ratio :wi-fat-mass])
            
(dorun
  (map (fn [iname]
         (alter-var-root #'ih derive iname :withings))
       wi-instruments))
            
(defn ensure-wi-instruments []
  (ensure-instrument [:withings :wi-weight]
    {:variable "Weight"
     :src-type :weight
     :nicknames ["withing weight" "scale weight"]
     :description "Weight as measured by the withings scale"})
  (ensure-instrument [:withings :wi-height]
    {:variable "Height"
     :src-type :height
     :nicknames ["height"]
     :description ""})
  (ensure-instrument [:withings :wi-lbm]
    {:variable "LBM"
     :src-type :lbm
     :nicknames ["lean body mass" "lbm"]
     :description "Lean Body Mass according to Withings"})
  (ensure-instrument [:withings :wi-fat-ratio]
    {:variable "Fat Ratio"
     :src-type :fat-ratio
     :nicknames ["fat %" "fat ratio"]
     :description ""})
  (ensure-instrument [:withings :wi-fat-mass]
    {:variable "Fat Mass"
     :src-type :fat-mass
     :nicknames ["fat mass" "fat"]
     :description "Fat Mass according to Withings Scale"})
  true)

;; ------------------------------------------
;; Zeo Instruments
;; ------------------------------------------

;;(defmethod configured? :zeo [inst user]
;;  (zeo/

;; ------------------------------------------
;; FitBit-derived Instruments
;; ------------------------------------------

(def fitbit-fake-inst
  {:_id "FITBIT" :type "instrument" :sampling {:chunksize :week}})

(defmethod configured? :fit [inst user]
  (fit/get-user-id user))

(defmethod last-update :fit [instrument user]
  (last-updated-time user fitbit-fake-inst))

(defn add-fit-sample [user date]
  (let [data (fit/summary user date)
        summary (:summary data)]
    (if (and data (> (:steps summary) 0))
      (do (update fitbit-fake-inst user
                  [(merge {:ts date
                           :v (:activeScore summary)}
                          summary)])
          true)
      false)))
    

(defn- days-ago-to-date [days]
  (time/minus (dt/now) (time/days days)))

(defn add-fit-samples [inst user]
  (let [days (time/in-days
              (time/interval
               (or (last-update inst user) (dt/a-month-ago))
               (time/now)))]
    (doall
     (map (partial add-fit-sample user)
          (map days-ago-to-date (range (dec days)))))))


(alter-var-root #'ih derive :fit-steps :fit)
(defmethod refresh :fit [inst user & [force?]]
  (when (or force? (stale? inst user))
    (add-fit-samples inst user)))
    
(defmethod reset :fit [inst user]
  (rem-samples user fitbit-fake-inst))

(defmethod time-series :fit-steps [inst user & [start end convert?]]
  (get-samples user fitbit-fake-inst
               :start (or start (dt/a-month-ago))
               :end (or end (dt/now))))
    
(defn ensure-fit-instruments []
  (ensure-instrument [:fitbit :fit-steps]
    {:variable "Steps Taken"
     :src-type :steps
     :sampling {:period (* 60 12) ;; 12 hours
                :chunksize :week}
     :nicknames ["steps" "walking" "steps taken" "number of steps"]
     :description "Number of steps in a day according to fitbit"}))


;; Handle Fitbit subscription notifications

(defonce fitbit (agent [0 0]))

(defn fetch-fitbit-sample [[success fail] user date]
  (try
    (do (add-fit-sample user date)
        [(inc success) fail])
    (catch java.lang.Throwable e
      (clojure.tools.logging/error e "Fitbit fetch error")
      [success (inc fail)])))

(defn fitbit-handler-fn [updates]
  (for [update updates]
    (let [{:keys [collectionType date ownerId subscriptionId]} update]
      (when-let [user (and (= collectionType "activities") (fit/id->user ownerId))]
        (send fitbit fetch-fitbit-sample user (dt/from-iso-8601 date))))))

(fit/set-notification-handler 'fitbit-handler-fn)


;; Default set of manual instruments

(comment
  {:type "instrument"
   :description "Manual assessment of sleep duration."
   :variable "Sleep Duration"
   :service "Manual"
   :src "manual"
   :event {:etype "sms"
           :message "How many hours (approximately) did you sleep last night?"
           :sms-value-type "int"
           :sms-prefix "sl"}
   :channels {:sms {:type :channel
                    :channel :sms
                    :prompt ""}
              :email {:type :channel
                      :channel :email
                      :prompt ""}}})
        

;; ------------------------------------------
;; Bootstrapping
;; ------------------------------------------

(defn ensure-instruments []
  (ensure-rt-instruments)
  (ensure-wi-instruments)
  (ensure-fit-instruments)
;;  (ensure-zeo-instruments)
  (ensure-manual-instruments))
