(ns plant-care-ui.core
  (:require [cljsjs.material-ui]
            [reagent.core :as reagent]
            [re-frame.core :as re-frame]
            [day8.re-frame.http-fx]
            [day8.re-frame.async-flow-fx]
            [plant-care-ui.config]
            [plant-care-ui.router.core :refer [router]]
            [plant-care-ui.db.events]
            [re-frisk.core :refer [enable-re-frisk!]]))

(defn ^:export main []
  (re-frame/dispatch-sync [:init-db])
  (re-frame/dispatch-sync [:load-tokens])
  (re-frame/dispatch [:get-all-sensors/request])
  (re-frame/dispatch [:get-all-flowers/request])
  (enable-re-frisk!)
  (reagent/render [router]
   (.getElementById js/document "app")))

(main)
