;; Copyright (c) Tomek Lipski. All rights reserved.  The use
;; and distribution terms for this software are covered by the Eclipse
;; Public License 1.0 (http://opensource.org/licenses/eclipse-1.0.php)
;; which can be found in the file LICENSE.txt at the root of this
;; distribution.  By using this software in any fashion, you are
;; agreeing to be bound by the terms of this license.  You must not
;; remove this notice, or any other, from this software.

(ns ganelon.tutorial.pages.routes
  (:require [ganelon.web.dyna-routes :as dyna-routes]
            [ganelon.tutorial.pages.common :as common]
            [noir.cookies :as cookies]
            [ganelon.tutorial.widgets.invitation-details :as invitation-details]
            [ganelon.tutorial.widgets.meetup-add :as meetup-add]
            [ganelon.tutorial.widgets.meetup-edit :as meetup-edit]
            [ganelon.tutorial.widgets.meetups-list :as meetups-list]
            [ganelon.tutorial.middleware :as middleware]))

(defn meetup-layout [& contents]
  (common/layout
    [:div.row-fluid [:div.span3 (meetup-add/new-meetup-widget)
                     (meetups-list/meetups-list-widget nil)]
     [:div.span1 ]
     [:div.span8 [:div#contents contents]]]))

(dyna-routes/defpage "/" []
  (meetup-layout
    [:div.hero-unit [:h1 "Welcome"]
     [:p "Welcome to the interactive tutorial for " [:a {:href "http://ganelon.tomeklipski.com"} "Ganelon micro-framework."]]
     [:p "This sample application used to manage meetups provides links to display source of every widget and action used.
      In addition to that, each widget has a dashed border to mark its boundary."]]))

(dyna-routes/defpage "/meetup/edit/:id" [id]
  (middleware/with-admin-id-from-meetup! id
    (meetup-layout
      (meetup-edit/meetup-details-widget id))))

(dyna-routes/defpage "/i/:id" [id]
  (meetup-layout
    (invitation-details/invitation-details-widget id)))