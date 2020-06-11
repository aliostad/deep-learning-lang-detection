(ns cider-ci.server.repository.push-notifications.ui
  (:require-macros
    [reagent.ratom :as ratom :refer [reaction]]
    [cljs.core.async.macros :refer [go]]
    )
  (:require
    [cider-ci.server.repository.ui.projects.shared :refer [humanize-datetime]]
    [cider-ci.server.repository.constants :refer [CONTEXT]]
    [cider-ci.server.repository.ui.request :as request]
    [cider-ci.server.client.state :as state]

    [cider-ci.utils.core :refer [presence]]
    [cider-ci.utils.url]

    [accountant.core :as accountant]
    [cljs.pprint :refer [pprint]]
    [reagent.core :as r]
    ))


(defn received-at [project]
  (-> project :push-notification :received_at))

(defn- color-class [project]
  (if (received-at project)
    "success"
    "default"))

(defn- state-icon [project]
  (if (received-at project)
    [:i.fa.fa-fw.fa-check-circle.text-success]
    [:i.fa.fa-fw.fa-circle-o.text-muted]))

(defn page-section [project]
  [:section.push-notifications
   [:h3 [:span [state-icon project]] "Push-Notifications"]
   (if-let [at (received-at project)]
     [:p.text-success "The most recent notification has been received "
      (humanize-datetime (:timestamp @state/client-state) at) "."]
     [:p.text-warning
      "We have not received any notifications "
      " since this service has been started! "
      "You can let Cider-CI manage your push hooks. "
      "See the section Push-Hook below." ])
   (when (-> @state/server-state :user :is_admin)
     (when-let [update-token (:update_notification_token project)]
       (let [url (str (-> @state/server-state :config :server_base_url) CONTEXT
                      "/update-notification/" update-token)]
         [:p "The URL to post notifications to is "
          [:a {:href url :method "POST"}
           [:code#update_notification_url url]]"."])))])

(defn th []
  [:th.text-center {:colSpan "1"}
   " Push-Notifications " ])

(defn td [project]
  [:td.push-notification.text-center
   {:class (color-class project)
    :data-updated-at (-> project :push-notification :updated_at)
    :data-received-at (-> project :push-notification :received_at)}
   [:span
    [:span [state-icon project]]
    (if-let [at (received-at project)]
      [:span " "
       (humanize-datetime (:timestamp @state/client-state) at)]
      [:span " " ])]])
