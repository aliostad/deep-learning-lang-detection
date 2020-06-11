(ns re-native.navigation-fx
  (:require [reagent.core :as r]
            [re-native.navigation :as nav]
            [re-frame.core :as re]))

(defonce drawer-navigator-instance-ratom (r/atom nil))
(defonce stack-navigator-instance-ratom (r/atom nil))

(re/reg-fx
  :nav-drawer-dispatch
  (fn nav-drawer-dispatch-fx [{:keys [action]}]
    (if @drawer-navigator-instance-ratom
     (.dispatch @drawer-navigator-instance-ratom (clj->js action)))))

(re/reg-fx
  :nav-stack-dispatch
  (fn nav-stack-dispatch-fx [{:keys [action]}]
    (if @stack-navigator-instance-ratom
     (.dispatch @stack-navigator-instance-ratom (clj->js action)))))
