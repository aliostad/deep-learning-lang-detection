(ns mailadmin.ajax
  (:require [ajax.core :as ajax]
            [re-frame.core :refer [dispatch]]))

(defn default-headers [request]
  (-> request
      (update :uri #(str js/context %))
      (update
        :headers
        #(merge
          %
          {"Accept"       "application/transit+json"
           "x-csrf-token" js/csrfToken}))))

(defn load-interceptors! []
  (swap! ajax/default-interceptors
         conj
         (ajax/to-interceptor {:name    "default headers"
                               :request default-headers})))

;; AJAX utility wrappers
(defn fetch-domains []
  (ajax.core/GET
    "/domains"
    {:handler       #(dispatch [:process-domains-response %1])
     :error-handler #(dispatch [:bad-response %1])}))

(defn fetch-forwardings []
  (ajax.core/GET
    "/forwardings"
    {:handler       #(dispatch [:process-forwardings-response %1])
     :error-handler #(dispatch [:bad-response %1])}))

(defn reload-users []
  (ajax.core/GET
    "/users"
    {:handler       #(dispatch [:process-users-response %1])
     :error-handler #(dispatch [:bad-response %1])}))

(defn create-domain! [data]
  (js/console.log "create domain " data)
  (ajax.core/POST
    "/domains"
    {:params        data
     :handler       #(do
                      (dispatch [:set-status %])
                      (dispatch [:fetch-domains]))
     :error-handler #(dispatch [:bad-response %1])}))

(defn update-domain! [data]
  (js/console.log "update domain " data)
  (ajax.core/PUT
    (str "/domains/" (:id data))
    {:params        data
     :handler       #(do
                      (dispatch [:set-status %])
                      (dispatch [:fetch-domains]))
     :error-handler #(dispatch [:bad-response %1])}))

(defn delete-domain! [id]
  (js/console.log "delete domain " id)
  (ajax.core/DELETE
    (str "/domains/" id)
    {:handler       #(do
                      (dispatch [:set-status %])
                      (dispatch [:fetch-domains]))
     :error-handler #(dispatch [:bad-response %1])}))

(defn create-forwarding! [data]
  (js/console.log "create forwarding " data)
  (ajax.core/POST
    "/forwardings"
    {:params        data
     :handler       #(do
                      (dispatch [:set-status %])
                      (dispatch [:fetch-forwardings]))
     :error-handler #(dispatch [:bad-response %1])}))

(defn update-forwarding! [data]
  (js/console.log "update forwarding " data)
  (ajax.core/PUT
    (str "/forwardings/" (:id data))
    {:params        data
     :handler       #(do
                      (dispatch [:set-status %])
                      (dispatch [:fetch-forwardings]))
     :error-handler #(dispatch [:bad-response %1])}))

(defn delete-forwarding! [id]
  (js/console.log "delete forwarding " id)
  (ajax.core/DELETE
    (str "/forwardings/" id)
    {:handler       #(do
                      (dispatch [:set-status %])
                      (dispatch [:fetch-forwardings]))
     :error-handler #(dispatch [:bad-response %1])}))

