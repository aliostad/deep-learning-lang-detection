(ns ataru.virkailija.virkailija-ajax
  (:require [re-frame.core :refer [dispatch]]
            [cljs.core.match :refer-macros [match]]
            [ataru.cljs-util :as util]
            [ataru.virkailija.temporal :as temporal]
            [ajax.core :refer [GET POST PUT DELETE]]
            [taoensso.timbre :refer-macros [spy debug]]))

(defn dispatch-flasher-error-msg
  [method response]
  (let [response-error-msg (-> response :response :error)
        error-type (if (and (= 400 (:status response))
                            (not-empty response-error-msg))
                     :user-feedback-error
                     :server-error)
        message (case error-type
                  :user-feedback-error response-error-msg
                  :server-error (str "Virhe "
                                     (case method
                                       :get "haettaessa."
                                       :post "tallennettaessa."
                                       :put "tallennettaessa."
                                       :delete "poistettaessa.")))]
    (dispatch [:flasher {:loading? false
                         :message  message
                         :error-type error-type
                         :detail   response}])
    response))

(defn- redirect [url]
  (set! (.. js/window -location -href) url))

(defn http [method path handler-or-dispatch & {:keys [override-args handler-args]}]
  (let [f (case method
            :get    GET
            :post   POST
            :put    PUT
            :delete DELETE)
        error-handler (comp
                        (or (:error-handler override-args) identity)
                        (partial dispatch-flasher-error-msg method))]
    (dispatch [:flasher {:loading? true
                         :message  (match method
                                     (:or :post :put) "Tietoja tallennetaan"
                                     :delete "Tietoja poistetaan"
                                     :else nil)}])
    (f path
       (merge {:response-format :json
               :format          :json
               :keywords?       true
               :error-handler   (fn [request]
                                  (match request
                                    {:status 401
                                     :response {:redirect url}}
                                    (redirect url)

                                    :else
                                    (error-handler request)))
               :handler         (comp (fn [response]
                                        (dispatch [:flasher {:loading? false
                                                             :message
                                                             (match method
                                                               (:or :post :put) "Kaikki muutokset tallennettu"
                                                               :delete "Tiedot poistettu"
                                                               :else nil)}])
                                        (match [handler-or-dispatch]
                                               [(dispatch-keyword :guard keyword?)] (dispatch [dispatch-keyword response handler-args])
                                               [nil] nil
                                               :else (dispatch [:state-update (fn [db] (handler-or-dispatch db response handler-args))])))
                                      temporal/parse-times)}
              (when (util/include-csrf-header? method)
                (when-let [csrf-token (util/csrf-token)]
                  {:headers {"CSRF" csrf-token}}))
              override-args))))

(defn post [path params handler-or-dispatch & {:keys [override-args handler-args]}]
  (http :post path handler-or-dispatch
        :override-args (merge override-args {:params params})
        :handler-args handler-args))
