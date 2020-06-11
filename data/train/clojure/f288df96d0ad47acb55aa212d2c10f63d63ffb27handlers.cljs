(ns issues.handlers
  (:require [re-frame.core :refer [register-handler dispatch dispatch-sync]]
            [issues.db :as db]
            [issues.model :as model]
            [issues.http :as http]
            [cljs-http.util :refer [json-decode]]))

(register-handler
 :initialize-db
 (fn  [_ _]
   (prn "Debug: initialize")
   db/default-db))

(register-handler
 :get-movies
 (fn [db [_ _]]
   (model/get-movies
    :on-success (fn [result]
                  (dispatch [:loaded-movies (json-decode result)])))
   db))

(register-handler
 :loaded-movies
 (fn [db [_ movies]]
   (assoc db :movies movies)))
