(ns experiment.models.harness
  (:use experiment.infra.models
	experiment.models.core
	experiment.models.user
	clj-time.core)
  (:require
   [experiment.infra.session :as session]
   [experiment.infra.auth :as auth]
   [somnium.congomongo :as mongo]
   [clj-time.coerce :as coerce]))
	

(def model-types
  [:symptom
   :instrument
   :treatment
   :trial])

(defn create-user []
  (create-model!
   (auth/set-user-password
    {:type :user
     :username "eslick"
     :salt "foobar"
     :name "Ian Eslick"
     :bio "Entrepreneur, site developer"
     :city "San Francisco"
     :state "California"
     :country "USA"
     ;; Tracking info
     :experiments 1} "apple")))

(defn clear-models []
  (map mongo/drop-coll! model-types))

(defn clear-all-models []
  (map mongo/drop-coll! (concat model-types [:user])))

(defn create-models []
;;  (create-user)
  (dorun
   (map create-model!
	[{:type :instrument
	  :variable "Sleep duration"
	  :nicknames ["Amount of sleep" "sleep"]
	  :src :zeo
	  :comments []
	  :description "Nightly sleep duration as measured by the Zeo"}
	 {:type :instrument
	  :variable "Sleep quality"
	  :nicknames ["ZQ" "sleep"]
	  :src :zeo
	  :comments []
	  :description "Tracks sleep quality as a function of total sleep, amount of deep sleep and REM sleep and nightly wakenings to estimate the overall quality of sleep"}
	 {:type :instrument
	  :variable "Nighly wakings"
	  :nicknames ["Wakings" "times getting up at night" "nightime waking"]
	  :src :zeo
	  :comments []
	  :description "The Zeo can track the number of nightly wakenings"}
	 {:type :instrument
	  :variable "Adherence"
	  :nicknames ["taking treatment" "adherence" "compliance"]
	  :src :manual
	  :comments []
	  :description "A simple estimate of how well you stuck to a treatment."}
	 {:type :instrument
	  :variable "Fatigue"
	  :nicknames ["Simple fatigue" "single question" "fatigue" "tiredness"]
	  :src :manual
	  :comments []
	  :questions [{:prompt "Rate your physical fatigue from 0 - none to 7 - debilitating"
		       :type :integer
		       :validator ["integer-range" 0 7]}
		      {:prompt "Rate your mental fatigue from 0 - none to 7 - debilitating"
		       :type :integer
		       :validator ["integer-range" 0 7]}]}
	 {:type :treatment
	  :name "No fructose, low-sugar diet"
	  :tags ["psoriasis" "auto-immune" "inflammation" "GI" "fructose malabsorbtion"]
	  :editors ["eslick"]
	  :description "Minimize foods containing fructose and sugar in general; no processed sugar.  Avoid fructans."
	  :dynamics {:initial-onset ["weeks" 3]
		     :repeat-onset ["days" 3]
		     :offset ["days" 3]}
	  :help [{:text "Apples and pears have lots of fructose and sorbitol."}
		 {:url "http://foo.bar"}]
	  :reminder "Reminder: no sugar today!"
	  :votes [2 1]
	  :warnings []
	  :comments [{:user "eslick"
		      :content "This has worked wonders for me, but you have to stick to it for 2-3 weeks to really see the effect.  The diet is tough because lots of food like eggplant and tomatoes have fructose.  Makes sense if you might have fructose malabsorbtion."
		      :votes [1 0]}]}
	 {:type :treatment
	  :editors ["eslick"]
	  :name "Slippery Elm Treatment"
	  :description
	  "5 Slippery Elm caps emptied into water, allowed to sit 5 mins then consumed.  Gluten limited.  Avoiding processed foods.  Limiting fats except flax, fish, and primrose oil.  Blue berries mixed with 2% cottage cheese every morning and flax seed oil directly behind it.  Taking a probiotic suppliment. Soaking in salt water 1-2 times a week. Left salt on my body 12 hours."
	  :dynamics {:initial-onset ["weeks" 3]
		     :repeat-onset ["days" 3]
		     :offset ["days" 3]}
	  :votes [2 1]
	  :warnings []
	  :comments []}]))

  (dorun
   (map create-model! 
	[{:type :experiment
	  :editors ["eslick"]
	  :title "Does diet rapidly improve fatigue if I control for sleep?"
	  :outcome [(as-dbref (fetch-model :instrument {:variable "Fatigue" :src :manual}))]
	  :instruments [(as-dbref (fetch-model :instrument {:variable "Sleep quality" :src :zeo}))
			(as-dbref (fetch-model :instrument {:variable "Adherence" :src :manual}))
			(as-dbref (fetch-model :instrument {:variable "Psoriasis activity" :src :manual}))]
	  :measurements [{:type :schedule
			  :interval-unit "day"
			  :interval 1}]
	  :treatment {:type :schedule
		      :interval-unit "days"
		      :schedule [:off 14 :on 21 :off 7 :on 7 :off 7]}}]))

   (dorun
    (map create-model!
	 [{:type :trial
	   :user "eslick"
	   :experiment (mongo/db-ref :experiment (:_id (fetch-model :experiment {:title "Does diet rapidly improve fatigue if I control for sleep?"})))
	   :sms? true
	   :active? true
	   :start "date"
	   :end "date"}]))
	   
   )
;;   (let [user (fetch-model :user {:username "eslick"})]
;;     ))
;;    (create-model! (assoc user  

(defn create-dataset []
  (let [user (as-dbref (fetch-model :user {:username "eslick"}))
	instrument (as-dbref (fetch-model :instrument {:variable "Fatigue" :src :manual}))
	now (now)
	data (reverse
	      (map (fn [offset value]
		     [(coerce/to-long (minus now (days offset))) value])
		   (range 0 10) (repeatedly (partial rand-int 7))))
	start (first (first data))
	end (first (last data))]
    (map create-model!
	 [{:type "event"
	   :user user
	   :instrument instrument
	   :start start
	   :end end
	   :data data}])))
	 

(defn create-articles []
  (map #(create-model! :article (assoc %1 :type :article))
       {:name :terms
	:title "Terms of Use"
	:body "TBD"}
       {:name :privacy
	:title "Privacy Policy"
	:body "TBD"}
       {:type :article
	:title "About this site"
	:body "TBD"}))
	
		     
			
		    
	 
	 
		       
	 
       
	 
	
	 
       
   

