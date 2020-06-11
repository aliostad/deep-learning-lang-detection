(ns meal.routes
  (:require-macros [secretary.core :refer [defroute]])
  (:require [meal.sync :as sync]
            [meal.util :as util]
            [re-frame.core :refer [dispatch]]
            [secretary.core :as secretary]))

(defroute view-page "/:tab" [tab]
  (dispatch [:view/change tab]))

(defroute index-page "/index/:index" [index]
  (sync/sync! :meals/fetch {:pp util/pp :page (.parseInt js/Number index)} :meals/handler)
  (dispatch [:view/change "index" index]))

(defroute view-meal "/meal/:meal-id" [meal-id]
  (dispatch [:meal/id meal-id])
  (dispatch [:view/change "meal" meal-id]))
