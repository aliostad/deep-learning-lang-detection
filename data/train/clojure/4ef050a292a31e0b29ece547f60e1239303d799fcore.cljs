(ns future-app.android.core
  (:require [reagent.core :as r :refer [atom]]
            [re-frame.core :refer [subscribe dispatch dispatch-sync]]
            [future-app.react-requires :refer [AppRegistry]]
            [future-app.routing :as routing]
            [future-app.events]
            [future-app.subs]
            [devtools.core :as devtools]))

(def app-root routing/app-root)

(defn init []
  (aset js/console "disableYellowBox" true)
  (devtools/install! [:formatters :hints])
  (dispatch-sync [:initialize-db])
  (.registerComponent AppRegistry "FutureApp" #(r/reactify-component routing/app-root)))