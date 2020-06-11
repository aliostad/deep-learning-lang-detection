(ns experiment.models.events
  (:use experiment.infra.models)
  (:require
   [clojure.tools.logging :as log]
   [noir.response :as resp]
   [clj-time.core :as time]
   [experiment.libs.datetime :as dt]
   [experiment.infra.session :as session]
   [experiment.infra.api :as api]
   [experiment.libs.sms :as sms]
   [experiment.models.user :as user]
   [experiment.models.instruments :as inst]
   ))

;; ## Legacy Hooks (to be removed)
(defn trial-reminders [trial]
  (:reminders trial))

(defn future-reminder? [start reminder]
  (assert (= (type start) java.lang.Long))
  (>= (:date reminder) start))


;; Event Handling
;; --------------------------
;;
;; Events are intended to support actions to be taken (automatically, or via
;; reminders over some channel) and are stores persistently in a database.
;;
;; ## EVENT MODEL
;; 
;; ### Status
;;
;; - pending :: schedule but not fired
;; - active :: fired but not done (e.g. sms sent)
;; - done :: event is fully satisfied
;;
;; ### Required keys
;; 
;; - :type "event"
;; - :etype <event type>
;; - :user (user ref associated with the event)
;; - :inst (instrument ref associated with the event)
;;
;; ### Other keys
;;
;; - :start - target start of event
;; - :wait - whether to remain active waiting for a response
;; - :result - was the event satisfied (e.g. delivered, responded, etc)
;; - :timeout - how long to wait before failing when response is needed

;; Event primitives
;; ----------------------------

(def required-event-keys [:type :etype :user :start])

(defn make-event [type user instrument & {:as options}]
  (merge {:type "event"
          :etype type
          :user (as-dbref user)
          :instrument (when instrument (as-dbref instrument))
          :status "pending"}
         options))
   
(defn make-sms-integer-event [u i message prefix]
  (make-event
   "sms" u i
   :sms-value-type "integer"
   :sms-prefix prefix
   :message message
   :wait true))

(defn make-sms-category-event [u i message prefix]
  (make-event
   "sms" u i
   :sms-value-type "string"
   :sms-prefix prefix
   :message message
   :wait true))

(defn make-sms-reminder-event [u message]                              
  (make-event
   "sms" u nil
   :message message
   :wait false))
  
(defn valid-event? [event]
  (and (= (count (select-keys event required-event-keys))
          (count required-event-keys))
       (#{"pending" "active" "done"} (:status event))))

(defn active? [event]
  (or (nil? (:status event))
      (#{"pending" "active"} (:status event))))

(defn success? [event]
  (and (= (:status event) "done")
       (= (:result event) "success")))

(defn fail? [event]
  (and (= (:status event) "done")
       (:wait event)
       (not= (:result event) "success")))

(defn within-24-hours-of?
  "If 't' is up to 24 after or 12 hours before ref"
  [t ref]
  (time/within?
   (time/interval
    (time/minus ref (time/hours 24))
    (time/plus ref (time/hours 12)))
   t))
  
(defn editable? [event]
  (when-let [start (:start event)]
    (and (= (:status event) "active")
         (:wait event)
         (= (:etype event) "sms")
         (within-24-hours-of? (dt/now) start))))

(defn requires-reply? [event]
  (:wait event))

(defmacro modify-if
  ([map key value]
     `(let [themap# ~map]
        (assert (map? themap#))
        (if (contains? themap# ~key)
          (assoc themap# ~key ~value)
          themap#)))
  ([map key new-key value]
     `(let [themap# ~map
            theval# ~value]
        (assert (map? themap#))
        (if (contains? themap# ~key)
          (dissoc
           (if (map? theval#)
             (assoc themap# ~new-key (merge (themap# ~new-key) theval#))
             (assoc themap# ~new-key theval#))
             ~key)
          themap#))))

;; Event Model Protocol
;; ----------------------------

(defmethod public-keys :event [event]
  [:status :start :local-time :instrument :user :message
   :sms-prefix :sms-value-type :result-ts :result-val
   :result-time :success :fail :editable])

(defmethod import-keys :event [event]
  [:status])

;; Only convert instantiated events
(defmethod server->client-hook :event [event]
;;  (if (valid-event? event)
    (let [start (dt/in-session-tz (:start event))
          ltime (dt/wall-time start)
          ts (when-let [res (:result-ts event)]
               (dt/in-session-tz res))
          tstime (dt/wall-time ts)]
      (-> event
          (update-in [:start] (fn [old] (dt/as-iso start)))
          (update-in [:result-ts] (fn [old] (dt/as-iso ts)))
          (assoc :success (success? event))
          (assoc :fail (fail? event))
          (assoc :editable (editable? event))
          (assoc :local-time ltime)
          (assoc :result-time tstime))))
;;    event))
             


;; Event storage and manipulation
;; ----------------------------


(defn- event-query [query]
  (let [user (:user query)
        inst (:instrument query)
        exp (:experiment query)]
    (-> query
        (modify-if :user (as-dbref user))
        (modify-if :instrument (as-dbref inst))
        (modify-if :experiment (as-dbref exp))
        (modify-if :type :etype (:type query))
        (modify-if :start {:$gte (dt/as-date (:start query))})
        (modify-if :end :start {:$lte (dt/as-date (:end query))}))))

(defn get-events 
  "Return the events for the user associated with this incoming message"
  [& {:keys [user status type start end] :as query}]
  (log/spy query)
  (fetch-models :event (event-query query) :sort {:start 1}))

(defn matching-events [event]
  (let [user (:user event)
        start (time/minus (:start event)
                          (time/minutes (* (or (:jitter event) 0) 2)))
        end (time/plus (:start event)
                       (time/minutes (* (or (:jitter event) 0) 2)))]
    (cond (:instrument event)
          (get-events :user user
                      :instrument (:instrument event)
                      :start start
                      :end end)
          (:experiment event)
          (get-events :user user
                      :experiment (:experiment event)
                      :start start
                      :end end))))

(defn event-scheduled? [event]
  (not (empty? (matching-events event))))
  
(defn remove-scheduled
  "Ensure that the list of events do not match
   any scheduled ('active') events"
  [events]
  (assert (every? :start events))
  (let [outer (time/plus (dt/now) (time/hours 30))
        [near far] (split-with #(time/before? (:start %) outer) events)]
    (concat (filter #(not (event-scheduled? %)) near) far)))
    
(defn register-event [event]
  (if (event-scheduled? event)
    (log/info "Found existing events for: " (:message event))
    (create-model!
     (assoc event
       :type "event"
       :status "active"))))

(defn set-status [event status]
  (modify-model! event {:$set {:status status}
                        :$inc {:updates 1}}))


(defn complete [event ts data]
  (modify-model! event {:$set {:status "done"
                               :result "success"
                               :result-ts ts
                               :result-val data}
                        :$inc {:updates 1}}))

(defn cancel [event & [reason]]
  (modify-model! event {:$set {:status "done"
                               :result (or reason "fail")
                               :result-ts (dt/now)}
                        :$inc {:updates 1}}))

(defn event-user [event]
  (assert (and (= (:type event) "event") (:user event)))
  (resolve-dbref (:user event)))
  
(defn event-inst [event]
  (assert (and (= (:type event) "event") (:instrument event)))
  (resolve-dbref (:instrument event)))

(defn event-exp [event]
  (assert (and (= (:type event) "event") (:experiment event)))
  (resolve-dbref (:experiment event)))

(defn link-event [user inst event]
  (-> event
      (assoc :user (as-dbref user))
      (assoc :instrument (as-dbref inst))))


;; Event Action Protocol
;; ---------------------------------------

(defmulti fire-event (comp keyword :etype))

;; By default do nothing
(defmethod fire-event :default [event]
  (log/info "Firing event")
  (log/spy event))

;; Example action event that writes to a log
(defmethod fire-event :log [event]
  (println "Log event firing")
  (log/spy event))

