(ns experiment.models.core
  (:use experiment.infra.models
        experiment.models.user)
  (:require
   [experiment.libs.datetime :as dt]
   [experiment.infra.session :as session]))

;; VARIABLE/SYMPTOM [name ref]
;; -----------------------------------------------------------
;;
;; -  has name
;; -  contains Comments

;; TREATMENT [name ref]
;; -----------------------------------------------------------
;;
;; -  has name
;; -  has tags[]
;; -  has averageRating
;; -  server ratings{user: value}
;; -  contains Comments
;;    - op: tag
;;    - op: comment
;;    - op: rate (send to server, update average)

(defmethod valid-model? :treatment [treat]
  (let [{:keys [tags comments warnings]} treat]
    (and (every? (set (keys treat)) [:name :description])
	 (every? #(or (nil? %1) (sequential? %1)) [comments warnings tags]))))
  
(defmethod server->client-hook :treatment [treat]
  (-> treat
      (markdown-convert :description)
      (owner-as-bool :owner :admins (site-admins))))

(defmethod client->server-hook :treatment [treat]
  (assoc treat
    :owner (as-dbref (session/current-user))))

(defmethod public-keys :treatment [treat]
  [:name :description :description-html :owner
   :help :reminder
   :tags :comments
   :dynamics :votes :warnings])

(defmethod import-keys :treatment [treat]
  [:name :description
   :help :reminder :dynamics
   :tags])

(defmethod index-keys :treatment [treat]
  [:name :description :tags])


;; INSTRUMENT [type ref]
;; -----------------------------------------------------------
;;
;; -  has type = 'instrument'
;; -  has variable
;; -  has service ('device/vendor name')
;; -  has src ('channel name')
;; -  has update-interval [optional] (polling frequency for service/device)
;; -  has min-domain, max-domain (for fixed axis time series)
;; -  has numeric? (determines whether values are numeric)
;; -  contains Comments

(defmethod public-keys :instrument [treat]
  [:variable :description :description-html
   :service :src :tracked :event
   :domain :tags :comments :owner])

(defmethod import-keys :instrument [treat]
  [:variable :description :tags
   :domain :service :src :event])

(defmethod index-keys :instrument [treat]
  [:variable :description :tags :service])

(defn has-tracker-for-inst [user inst]
  (> (count
      (filter #(and (dbref? %) (= (:_id inst) (.getId %)))
              (map :instrument
                   (vals (:trackers user)))))
     0))

(defmethod server->client-hook :instrument [inst]
  (-> inst
      (markdown-convert :description)
      (owner-as-bool :owner :admins (site-admin-refs))
      (assoc :tracked (has-tracker-for-inst (session/current-user) inst))))
      


;; EXPERIMENT
;; -----------------------------------------------------------
;;
;; -  ref Treatment
;; -  ref Instruments[]
;; -  has title
;; -  has instructions
;; -  has tags[]
;; -  submodel Schedule
;; -  submodel Ratings{}
;; -  submodels Comments[]

(defmethod db-reference-params :experiment [model]
  [:treatment :outcome :covariates])

(defmethod index-keys :experiment [treat]
  [:title :instructions :tags])

(defmethod public-keys :experiment [treat]
  [:title :schedule 
   :treatment :outcome :covariates 
   :comments :editors])
   
(defn instruments
  "Returns a list of dbrefs to instruments used in this experiment"
  [experiment]
  (vec (concat (:outcome experiment) (:covariates experiment))))


;; TRACKER
;; -----------------------------------------------------------
;;
;; - refs User
;; - refs Instrument
;; - has state

(defmethod db-reference-params :tracker [model]
  [:user :instrument])

(defmethod public-keys :tracker [model]
  [:user :instrument :schedule :state])

(defmethod import-keys :tracker [model]
  [:user :instrument :schedule :state])


;; JOURNAL (embedded)
;; -----------------------------------------------------------
;;
;; -  date
;; -  date-str
;; -  content
;; -  sharing

(defmethod db-reference-params :journal [model]
  [:user])

(defmethod public-keys :journal [model]
  [:date :date-str :sharing :short :content :annotation])

(defmethod import-keys :journal [treat]
  [:date :sharing :short :content :annotation])

(defmethod server->client-hook :journal [model]
  (assoc model
    :date-str (dt/as-blog-date (:date model))))


;; COMMENT (embedded)
;; -----------------------------------------------------------
;;
;; -  has upVotes
;; -  has downVotes
;; -  has title
;; -  has content

(defmethod public-keys :comment [treat]
  [:date :content])

(defmethod import-keys :comment [treat]
  [:date :content])

(defmethod server->client-hook :comment [model]
  (assoc model
    :date-str (dt/as-blog-date (:date model))))

(defmethod make-annotation :comment [{:keys [text]}]
  (when (> (count text) 5)
    (let [date (dt/now)]
      {:content text
       :username (:username (session/current-user))
       :date (dt/as-utc date)
       :date-str (dt/as-short-string date)})))


;; USER Prefs
;; -------------------------------------------------

(defmethod public-keys :userprefs [prefs]
  (keys prefs))

(defmethod import-keys :userprefs [prefs]
  (keys prefs))