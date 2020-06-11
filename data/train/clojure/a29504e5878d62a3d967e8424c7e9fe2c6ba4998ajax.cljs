(ns mtgcollection.ajax
  (:require [ajax.core :as ajax]
            [re-frame.core :as rf :refer [reg-fx]]))

(defn response-handler [event-v]
  (fn [res]
    (rf/dispatch (conj event-v res))))

(defn add-response-handlers [req]
  (let [{:keys [dispatch dispatch-error]
         :or {dispatch [:ajax/ok]
              dispatch-error [:ajax/failed]}} req]
    (-> (cond-> req
          dispatch (assoc :handler (response-handler dispatch))
          dispatch-error (assoc :error-handler (response-handler dispatch-error)))
        (dissoc req :dispatch :dispatch-error))))

(defn add-auth-header [req]
  (if-let [token (-> re-frame.db/app-db deref :user :token)]
    (assoc-in req [:headers "Authorization"] (str "Token " token))
    req))

(reg-fx :ajax (fn [[method uri request]]
                (let [verb (name method)]
                  (ajax/easy-ajax-request uri verb (-> request
                                                       add-response-handlers
                                                       add-auth-header)))))
