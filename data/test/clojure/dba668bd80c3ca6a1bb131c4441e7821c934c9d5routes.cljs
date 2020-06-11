(ns open-source.routes
  (:require [secretary.core :as secretary :refer-macros [defroute]]
            [re-frame.core :refer [dispatch subscribe]]
            [re-frame.db :refer [app-db]]
            [goog.events :as events]
            [goog.history.EventType :as EventType]
            [accountant.core :as acc]
            [open-source.utils :as u])
  (:require-macros [open-source.routes :refer [defroute-ga defroute-nga]])
  (:import goog.history.Html5History))

(defroute-nga projects-path "/" [query-params]
  (dispatch [:list-projects (set (u/split-tags (:tags query-params)))]))

(defroute-ga "/projects/new" {}
  (dispatch [:new-project]))

(defroute-ga "/projects/:id" {:keys [id]}
  (dispatch [:view-project id]))

(defroute-ga "/projects/:id/edit" {:keys [id]}
  (dispatch [:edit-project id]))

(defn nav
  [path]
  (acc/navigate! path))

(acc/configure-navigation!)
