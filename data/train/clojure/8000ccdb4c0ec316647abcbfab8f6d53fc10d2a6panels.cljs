(ns re-frame-examples.phonecat.panels
    (:require [reagent.core :as r]
              [re-frame.core :as rf]
              [re-frame-examples.phonecat.subs]
              [re-frame-examples.phonecat.handlers]
              [re-frame-examples.phonecat.views.phone-list :refer [home-page]]
              [re-frame-examples.phonecat.views.phone-details :refer [phone-page]]))

(defn phonecat-panel []
  (rf/dispatch [:initialize-phonecat-state])
  (rf/dispatch [:load-phones])
  (home-page))

(defn phonecat-details-panel [phone-id]
  (rf/dispatch [:load-phone-detail phone-id])
  (phone-page phone-id))
