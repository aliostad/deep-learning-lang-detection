(ns chalk.routes
    (:require-macros [secretary.core :refer [defroute]])
    (:import goog.History)
    (:require [secretary.core :as secretary]
              [goog.events :as events]
              [goog.history.EventType :as EventType]
              [re-frame.core :as re-frame :refer [dispatch]]))

(defn hook-browser-navigation! []
  (doto (History.)
    (events/listen
     EventType/NAVIGATE
     (fn [event]
       (secretary/dispatch! (.-token event))))
    (.setEnabled true)))

(defn app-routes []
  (secretary/set-config! :prefix "#")
  ;; --------------------
  ;; define routes here
  (defroute "/" []
    (dispatch [:set-active-screen :home-screen]))

  (defroute "/signup" []
    (dispatch [:set-active-screen :signup]))

  (defroute "/signin" []
    (dispatch [:set-active-screen :signin]))

  (defroute "/climbs/add" []
    (dispatch [:set-active-screen :climb-create-screen]))

  (defroute "/countries/:id" [id]
    (dispatch [:update-selections {:id id} :country])
    (dispatch [:set-active-screen :country-view id]))

  (defroute "/countries/:country-id/regions/:id" [country-id id]
    (dispatch [:update-selections {:id id :country country-id} :region])
    (dispatch [:set-active-screen :region-view id]))

  (defroute "/countries/:country-id/regions/:region-id/locations/:id" [country-id region-id id]
    (dispatch [:update-selections {:id id :region region-id :country country-id} :location])
    (dispatch [:set-active-screen :location-view id]))

  (defroute "/countries/:country-id/regions/:region-id/locations/:location-id/sublocations/:id" [country-id region-id location-id id]
    (dispatch [:update-selections {:id id :location location-id :region region-id :country country-id} :sublocation])
    (dispatch [:set-active-screen :sublocation-view id]))

  (defroute "/countries/:country-id/regions/:region-id/locations/:location-id/sublocations/:sublocation-id/walls/:id" [country-id region-id location-id sublocation-id id]
    (dispatch [:update-selections {:id id :sublocation sublocation-id :location location-id :region region-id :country country-id} :wall])
    (dispatch [:set-active-screen :wall-view id]))

  (defroute "/countries/:country-id/regions/:region-id/locations/:location-id/sublocations/:sublocation-id/walls/:wall-id/climbs/:id" [country-id region-id location-id sublocation-id wall-id id]
    (dispatch [:update-selections {:id id :wall wall-id :sublocation sublocation-id :location location-id :region region-id :country country-id} :climb])
    (dispatch [:set-active-screen :climb-view id]))

  ;; --------------------
  (hook-browser-navigation!))
