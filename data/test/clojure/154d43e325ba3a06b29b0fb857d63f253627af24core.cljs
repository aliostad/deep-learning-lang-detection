(ns redux-demo.core
  (:require [reagent.core :as reagent]))

(defn connect [{:keys [state->props dispatch->props]} component]
  (fn [{:keys [::state ::reducer]}]
    (let [dispatch (fn dispatch [event-or-fn]
                     (if (map? event-or-fn)
                       (swap! state reducer event-or-fn))
                     (event-or-fn dispatch state))
          props (merge
                 (when state->props
                   (state->props @state))
                 (when dispatch->props
                   (dispatch->props dispatch)))]
      [component props])))

(defn combine-reducers [reducer-map]
  (fn [state event]
    (->> reducer-map
         (map (fn [[k reducer]]
                [k (reducer (get state k)
                            event)]))
         (into {}))))

(defn create-store [reducer]
  {::state (reagent/atom {})
   ::reducer reducer})
