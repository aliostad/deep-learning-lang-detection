(ns artgeekdundee-re.core
  (:require [reagent.core :as reagent]
            [re-frame.core :as rf]
            [artgeekdundee-re.events]
            [artgeekdundee-re.effects]
            [artgeekdundee-re.subs]
            [artgeekdundee-re.views.app :as app])
  (:require-macros [cljs.core.async.macros :refer [go]]))

(enable-console-print!)

(defn main
  "Pre-fetches external data and launches app"
  []
  (rf/dispatch-sync [:init])
  (rf/dispatch [:fetch-config])
  (rf/dispatch [:fetch-exhibitions])
  (reagent/render [app/container]
                  (.getElementById js/document "app")))

(main)