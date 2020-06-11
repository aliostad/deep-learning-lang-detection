(ns yimp.shared.main
  (:require [reagent.core :as r :refer [atom]]
            [re-frame.core :refer [subscribe dispatch dispatch-sync]]
            [yimp.events]
            [yimp.shared.screens.login :refer [login]]
            [yimp.shared.screens.edit-student :refer [edit-student]]
            [yimp.shared.screens.edit-incident :refer [edit-incident]]
            [yimp.shared.screens.edit-preference :refer [edit-preference]]
            [yimp.shared.components.navigation :refer [tab-navigator]]
            [clojure.data :as d]
            [yimp.shared.ui :refer [app-registry text scroll image view md-icon-toggle md-button md-switch theme floating-action-button]]
            [yimp.subs]))

(js* "/* @flow */")

(defn start []
  (let [nav-state (subscribe [:nav-screen])
        user      (subscribe [:user])]
    (fn []
      (if (nil? @user)
        [login]
        (case @nav-state
          "student" [edit-student]
          "incident" [edit-incident]
          "preference" [edit-preference]
          [tab-navigator])))))

(defn init []
  (dispatch-sync [:initialize-db])
  (dispatch-sync [:load-teachers])
  (.registerComponent app-registry "yimp" #(r/reactify-component start))
  (dispatch [:load-students])
  (dispatch [:load-classrooms])
  (dispatch [:load-preferences])
  (dispatch [:load-incidents]))
