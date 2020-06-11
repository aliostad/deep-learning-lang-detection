(ns neptune.ajax
  (:require [ajax.core :as ajax]
            [re-frame.core :refer [dispatch]]))

(defn default-headers [request]
  (-> request
      (update :uri #(str js/context %))
      (update
        :headers
        #(merge
          %
          {"Accept" "application/transit+json"
           "x-csrf-token" js/csrfToken}))))

(defn load-interceptors! []
  (reset! ajax/default-error-handler (fn [response] (dispatch [:messaging/set-errors response])))
  (reset! ajax/default-handler (fn [_] (dispatch [:messaging/set-successes "Success!"])))
  (swap! ajax/default-interceptors
         conj
         (ajax/to-interceptor {:name "default headers"
                               :request default-headers})))


