(ns western-music.core
  (:require [western-music.views :refer [wmtm-app]]
            [western-music.handlers]
            [western-music.subscriptions]
            [western-music.edn :as edn]
            [re-frame.core :refer [dispatch dispatch-sync]]
            [reagent.core :as reagent]))

(defn set-map-listeners! []
  (set! (.-onNationFocus (.-listeners js/map))
        #(dispatch [:focus-nation %]))
  (set! (.-onNationClick (.-listeners js/map))
        #(dispatch [:select-nation %]))
  (set! (.-onNationBlur (.-listeners js/map)) identity))

(defn ^:export main
  []
  (edn/register-custom-readers!)
  (reagent/render [wmtm-app] (.getElementById js/document "app")
                  (fn []
                    (set-map-listeners!)
                    (.initialize js/map)
                    (dispatch [:initialize-data])
                    (dispatch [:initialize-player]))))
