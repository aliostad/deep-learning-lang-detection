(ns haunting-refrain.fx.http
  (:require-macros [cljs.core.async.macros :refer [go]])
  (:require [cljs-http.client :as http]
            [shodan.console :as console]
            [cljs.core.async :refer [<!]]
            [re-frame.core :refer [dispatch reg-fx reg-event-fx reg-sub]]))

(defn http-effect
  "Effect handler for http requests. Note, client code that needs to make requests should use
  (dispatch [:http/request {:url ... :method :post}]) rather than using this effect directly."
  [options]
  (go (let [response (<! (http/request
                           (merge
                             {:with-credentials? false}
                             (select-keys options [:url :method]))))]
        (if (:success response)
          (dispatch [:http/success options (:body response)])
          (dispatch [:http/failure options (:body response) (:status response)])))))

(reg-fx :http http-effect)

(defn- http-request
  "Send an HTTP request and dispatch events based on the response. Options is a map consisting of:
  :url - url to request
  :method - http method to use
  :on-success - name of a dispatch vector to call if the call succeeds.
                This will look like (dispatch [on-success body-of-response])
  :on-failure - name of a dispatch vector to call if the call fails (returns non-200).
                This will look like (dispatch [on-failure body-of-response status-code-of-response]).
  :endpoint - a keyword uniquely identifying the endpoint being called.
  While the HTTP request has been sent but no response has need received, the subscription
  (subscribe [:http/loading? endpoint-name]) will resolve to true."
  [{:keys [db]} [_ {:keys [endpoint] :as options}]]
  {:db   (assoc-in db [:http/loading? endpoint] true)
   :http options})

(reg-event-fx :http/request http-request)

(defn- http-dispatch
  "Convenience method for generating a success/failure vector after HTTP return"
  [on-success body status]
  (into (if (sequential? on-success)
          on-success
          [on-success])
        [body status]))

(defn- http-success
  "Event that fires when an http request comes back with a 200 response. Dispatch an on-success
  event (from the argument map of the original [:http/request] event) with the result body."
  [{:keys [db]} [_ {:keys [endpoint on-success] :as options} body]]
  (merge
    {:db (update-in db [:http/loading?] dissoc endpoint)}
    (when on-success
      {:dispatch (http-dispatch on-success body 200)})))

(reg-event-fx :http/success http-success)

(defn- http-failure
  "Event that fires when an http request comes back with a non-200 response. Dispatch an on-failure
  event with the result body and the response status."
  [{:keys [db]} [_ {:keys [endpoint on-failure] :as options} body status]]
  (merge
    {:db (update-in db [:http/requests] dissoc endpoint)}
    (when on-failure
      {:dispatch (http-dispatch on-failure body status)})))

(reg-event-fx :http/failure http-failure)

(reg-sub
  :http/loading?
  (fn [db [_ endpoint]]
    (get-in db [:http/loading? endpoint])))
