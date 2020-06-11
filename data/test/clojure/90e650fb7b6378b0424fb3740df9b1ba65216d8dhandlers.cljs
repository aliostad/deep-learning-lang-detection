(ns guess.handlers
    (:require [re-frame.core :as re-frame]
              [guess.db :as db]))

(re-frame/reg-event-db
 :initialize-db
 (fn  [_ _]
   db/default-db))

(defn update-guess [db]
	(assoc db :guess (int (/ (+ (:to db) (:from db)) 2))))

(re-frame/reg-event-db
 :less
 (fn  [db _]
   (-> db
   	(assoc :to (:guess db))
   	(update-guess))))

(re-frame/reg-event-db
 :more
 (fn  [db _]
   (-> db
   	(assoc :from (:guess db))
   	(update-guess))))





(comment 
	(re-frame.core/dispatch [:initialize-db])
	(re-frame.core/dispatch-sync [:initialize-db])
	(re-frame.core/dispatch [:less])
	(re-frame.core/dispatch [:more])
	)