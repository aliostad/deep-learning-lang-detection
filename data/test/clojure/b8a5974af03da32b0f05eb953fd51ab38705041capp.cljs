(ns simulator-app.components.app
    (:require [simulator-app.store.core :refer [dispatch]]
              [simulator-app.actions.click :refer [click-update click-reset!]]))

(defn app [{:keys [name description method path] :as data}]
    [:li.app
     [:div.app-info
      [:div name]
      [:div description]]
     [:div.app-path (str (.toUpperCase method) ": " path)]
     [:div.app-actions
      [:button.update {:on-click #(dispatch (click-update data))} "Update"]
      [:button.reset {:on-click #(dispatch (click-reset! data))} "Reset"]]])
