(ns sculpture.admin.state.fx.dispatch-debounce
  (:require
    [re-frame.router :as router]
    [re-frame.core :refer [reg-fx]]
    [re-frame.loggers :refer [console]]))

(def debounced-events (atom {}))

(defn cancel-timeout [id]
  (js/clearTimeout (:timeout (@debounced-events id)))
  (swap! debounced-events dissoc id))

(defn dispatch-debounce-fx [dispatches]
  (let [dispatches (if (sequential? dispatches) dispatches [dispatches])]
    (doseq [{:keys [id action dispatch timeout]
             :or   {action :dispatch}}
            dispatches]
      (case action
        :dispatch (do
                    (cancel-timeout id)
                    (swap! debounced-events assoc id
                           {:timeout  (js/setTimeout (fn []
                                                       (swap! debounced-events dissoc id)
                                                       (router/dispatch dispatch))
                                                     timeout)
                            :dispatch dispatch}))
        :cancel (cancel-timeout id)
        :flush (let [ev (get-in @debounced-events [id :dispatch])]
                 (cancel-timeout id)
                 (router/dispatch ev))
        (console :warn "re-frame: ignoring bad :dispatch-debounce action:" action "id:" id)))))
