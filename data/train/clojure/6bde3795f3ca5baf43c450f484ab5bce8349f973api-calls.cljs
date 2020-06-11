(ns gemtoes.api-calls
  (:require [ajax.core :as ajax :refer [GET POST PUT DELETE]]
            [re-frame.core :as re-frame :refer [dispatch]]))

;;admin API GET calls
;; makers
(defn get-makers []
  (GET "/api/makers"
       {:response-format :json
        :keywords? true
        :handler #(dispatch [:update-makers (get-in % [:result])])}))

(defn put-maker [maker]
  (PUT (str "/api/makers/" (:id maker))
        {:format :json
         :keywords? true
         :handler #(dispatch [:get-makers])
         :params maker}))

(defn delete-maker [id]
  (DELETE (str "/api/makers" (:id maker))
          {:format :json
           :keywords true
           :handler #(dispatch [:get-makers])}))

;; gmtos
(defn get-gmtos []
  (GET "/api/gmtos"
       {:response-format :json
        :keywords? true
        :handler #(dispatch [:update-gmtos (get-in % [:result])])}))
