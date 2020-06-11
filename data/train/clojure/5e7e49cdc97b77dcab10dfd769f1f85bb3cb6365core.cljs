(ns chatty.core
  (:require [reagent.core :as reagent]
            [re-frame.core :refer [dispatch dispatch-sync]]
            [chatty.views]
            [chatty.handlers]
            [chatty.subs]
            [chatty.server]))

(dispatch-sync [:initialize])
(dispatch-sync [:login "boieaga"])
(dispatch-sync [:login "bonega"])
(dispatch-sync [:login "kawk"])
(dispatch-sync [:login "kawc"])
(dispatch-sync [:add-event {:timestamp 1 :value "bonega" :event-type :disconnect}])

(defn ^export main []
  (js/setInterval #(dispatch [:update-time (.getTime (js/Date.))]) 10000)
  (reagent/render [chatty.views/main-component]
                  (js/document.getElementById "app")))
