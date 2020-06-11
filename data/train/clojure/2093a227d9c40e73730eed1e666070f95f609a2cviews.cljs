(ns neptune.messaging.views
  (:require [re-frame.core :refer [subscribe dispatch]]))

(defn messaging-panel []
  (let [errors (subscribe [:messaging/errors])
        successes (subscribe [:messaging/successes])]
    (fn []
      [:div.container>div.row>div.col-sm-12
       (when @errors
         [:div.alert.alert-danger
          [:button.close
           {:type "button"
            :on-click #(dispatch [:messaging/set-errors nil])}
           [:span "x"]]
          @errors])
       (when @successes
         [:div.alert.alert-success
          [:button.close
           {:type "button"
            :on-click #(dispatch [:messaging/set-successes nil])}
           [:span "x"]]
          @successes])])))