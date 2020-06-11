(ns experiment.models.trackers
  (:use experiment.infra.models
        experiment.models.user)
  (:require [clj-time.core :as time]
            [incanter.stats]
            [clojure.tools.logging :as log]
            [experiment.libs.datetime :as dt]
            [experiment.libs.sms :as sms]
            [experiment.models.samples :as samples]
            [experiment.models.schedule :as schedule]
            [experiment.models.events :as event]
            [experiment.models.instruments :as inst]))

;;
;; Instrument Trackers
;; ------------------------------
;;
;; Trackers are standalone specifications of an instrument and a
;; schedule for updates in the case of manual interactions like SMS
;; These are embedded in a collection.
;;

(defn tracker-name [tracker]
  (let [inst (resolve-dbref (:instrument tracker))]
    (str (:variable inst) " -- " (:service inst))))

;; Trackers with schedules can use the schedule event interface to
;; generate future events over some time interval (clj-time)

(defn tracker-events [tracker interval]
  (when-let [schedule (:schedule tracker)]
    (when (:stype schedule)
      (let [refs (select-keys tracker [:user :instrument])]
        (map #(merge % refs) (schedule/events schedule interval))))))

(defn all-tracker-events [user interval]
  (mapcat #(tracker-events % interval) (trackers user)))

(defn get-tracker [user variable & [service]]
  (when-let [inst (fetch-model :instrument {:variable variable :service service})]
    (let [ref (as-dbref inst)]
      (first (filter #(= (:instrument %) ref) (trackers user))))))
    

;; Service-based Trackers
;; -------------------------------
;; Download for service-based trackers are done automatically, no
;; explicit event generation is provided at present.

(defmacro with-tracker [[tracker user inst sched] & body]
  `(let [tracker# ~tracker
         ~user (resolve-dbref (:user tracker#))
         ~inst (resolve-dbref (:instrument tracker#))
         ~sched (:schedule tracker#)]
     ~@body))

(defn date-updated [tracker]
  (with-tracker [tracker u i s]
    (inst/last-update i u)))

(defn update [tracker & [interval]]
  (with-tracker [tracker u i s]
    (dt/with-interval [interval start end]
      (inst/refresh i u start end))))

(defn time-series [tracker & [interval]]
  (with-tracker [tracker u i s]
    (dt/with-interval [interval start end]
      (inst/time-series i u start end))))

(defn reset [tracker & [yes-im-sure]]
  (with-tracker [tracker u i s]
    (inst/reset i u)))

(defn submit-data [tracker samples]
  (with-tracker [tracker u i s]
    (let [samples (if (map? samples) (vector samples) samples)]
      (assert (samples/valid-samples? samples))
      (inst/update i u samples))))

;; SMS-based Tracker Protocol
;; -------------------------------
;;
;; We allow the web to satisfy a future or past (ignored) SMS event
;; as a hack to support manual tracking via a web interface
;;

;; ## Fire an SMS Event

(defn sms-prefix-message [event]
  (if-let [prefix (:sms-prefix event)]
    (str (:message event) " (prefix your answer with \"" prefix "\"")
    (:message event)))

(defmethod event/fire-event :sms [event]
  (log/spy ["Sending SMS for " event])
  (let [number (get-pref (event/event-user event) :cell)
        message (sms-prefix-message event)]
    (println number message)
    (sms/send-sms number message)
    (let [status (if (event/requires-reply? event) "active" "done")]
      (event/set-status event status))))

;; ## Complete SMS Events on SMS reply

(defn complete-event-with-sample [user sample]
  (let [{:keys [event ts v]} sample
        {:keys [instrument]} event
        inst (resolve-dbref instrument)]
    (samples/add-samples user inst (list (dissoc sample :event)))
    (event/complete event ts v)
    (fetch-model :event {:_id (:_id event)})))
    
(defn cancel-event [user sample]
  (let [{:keys [event ts]} sample]
    (event/cancel event ts)))

(defn associate-message-with-events [user events ts text]
  (println (map :instrument events))
  (let [samples (keep (partial sms/parse-sms text ts) events)]
    (cond (empty? samples)
          (do (log/info
               (str "Failed to parse response from " (:username user)
                    ": '" text "'"))
              nil)
          (= (count samples) 1)
          (complete-event-with-sample user (first samples))
          true
          (do (log/warn "Multiple matching samples for " (:username user)
                        ": '" text "' -- removing old and associating with latest")
              (doall (map (partial cancel-event user) (butlast samples)))
              (complete-event-with-sample user (last samples))))))
  
(defn associate-message-with-user [user ts text]
  "Associate with any event that could have sent an SMS recently to
   this user and expects a response."
  (let [events (event/get-events
                :user user
                :type "sms"
                :status "active"
                :wait true
                :end (dt/now))]
    (associate-message-with-events user events ts text)))

(defn associate-message-with-tracker [user ts text]
  ;; TODO: Lookup trackers that can parse unsolicited sms messages?
  (:trackers user)
  false)
                                     
(defn- user-for-cell-number [num]
  (fetch-model :user {:preferences.cell num}))

(defn sms-reply-handler
  "Main handler for SMS replies from our texting service.
   Given a number and message, parse it, associate it with
   an event and submit the resulting data as a sample if
   appropriate.  (TODO) Send failure messages if no parser
   matches or on a failure to parse"
  [ts number text]
  (if-let [user (user-for-cell-number number)]
    (do (log/infof "SMS Response from %s: '%s'" (:username user) text)
        (or (associate-message-with-user user ts text)
            (associate-message-with-tracker user ts text)))
    (log/errorf "Unable to resolve phone number %s to a user" number)))

;; Example
;; -------------------

(comment
  (defn make-tracker [user instrument params]
    {:type "tracker"
     :user (as-dbref user)
     :instrument (as-dbref instrument)
     :schedule {:type "schedule"
                :stype "daily"
                :times [{:hour 10 :min 0} {:hour 21 :min 0}]
                :jitter 5
                :wait true
                :event {:type "event"
                        :etype "sms"
                        :message "What is your energy today? Reply 'e [0-10]' where 0 is lowest and 10 is manic"
                        :sms-prefix "e"
                        :sms-value-type "int"}}}))

;; Synthesizing data
;; ----------------------

(defn sample-from-normal [mean sd]
  (fn []
    (int (incanter.stats/sample-normal 1 :mean mean :sd sd))))

(defn create-integer-samples [tracker interval generator]
  (submit-data
   tracker
   (map
    (fn [day]
      {:ts day :v (generator)})
    (schedule/interval->days interval))))

(comment
  (let [periods
        (schedule/periodic-record-intervals
         {:start (dt/from-iso "2012-05-01T12:00:00.000Z")
          :periods [["base" 14] ["treat" 21] ["base" 14]]})
        periods (map :interval (:periods periods))
        tracker 
        (get-tracker (fetch-model :user {:username "eslick"})
                     "Positivity" "Manual")]
    (create-integer-samples tracker (first periods)
                            (sample-from-normal 3 0.5))
    (create-integer-samples tracker (second periods)
                            (sample-from-normal 4 0.8))
    (create-integer-samples tracker (nth periods 2)
                            (sample-from-normal 3 0.6))))
   
     
