(ns logging-dashboard.components.log_dashboard.header.realtime_stop_start
  (:require [logging-dashboard.dispatcher     :as dispatcher]
            [cljs-flux.dispatcher             :refer [dispatch]]))

(defn realtime-stop-start
  [settings]
  (let [on-click #(do (.preventDefault %)
                      (if (= (:streaming-status @settings) "started") 
                        (dispatch dispatcher/stop-streaming nil)
                        (dispatch dispatcher/start-streaming nil)))]
    (fn []
      [:a.btn.btn-default.btn-sm.pull-right.log-table-button 
       {:href "#" :on-click on-click :class (if (= (:streaming-status @settings) "started") "btn-danger" "btn-warning")}
       [:span (if (= (:streaming-status @settings) "started") "Streaming" "Paused")]])))
