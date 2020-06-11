(ns bmihw.manage
    (:require [reagent.core :as reagent :refer [atom]]
              [reagent.session :as session]
              [secretary.core :as secretary :include-macros true]
              [goog.events :as events]
              [goog.history.EventType :as EventType]
              [ajax.core :refer [GET POST]]
              [bmihw.common :refer [auth fb]]
              [cljsjs.firebase :as firebase])
    (:import goog.History))

(def events (reagent/atom []))
(def current-event (reagent/atom nil))

(defn drunk?
  [{drunk "drunk" :as event}]
  (or (nil? drunk) (= drunk "true") drunk))

(defn add-event
  [{id :id provider "provider" user "username" target "target-username" keyword "keyword" content "content" :as event}]
  (let [current-user (get-in @auth ["twitter" "username"])]
    (.log js/console (str "Event User: " user ", Current User:" current-user))
    #_(if (= user current-user))
       (swap! events conj {:id id 
                           :provider provider
                           :user user 
                           :keyword keyword
                           :target target
                           :drunk (drunk? event)
                           :content content})));;)

(defn handle-childsnapshot
  [snapshot]
  (let [key (.key snapshot)
        val (.val snapshot)]
    (if val
      (add-event (merge {:id key} (js->clj val))))))

(defn handle-childsnapshot-remove
  [snapshot]
  (let [id (.key snapshot)
        clean-events (filter (fn [e] (not (= id (:id e))))  @events)]
    (reset! events clean-events)))

(declare manage-page)

(defn delete-page
  []
  (if-let [drunk (:drunk @current-event)]
    [:div.panel.panel-default 
     [:div.panel-heading 
      [:h3.panel-title "NOPE!!!!"]]
     [:div.panel-body
	     [:p "Always do sober what you said you'd do drunk. That will teach you to keep your mouth shut."]
	     [:i "- Ernest Hemmingway"]
	     [:br]
	     [:br]
	     [:div.btn-group.btn-group-justified
	      [:a.btn.btn-default {:href "#/manage"
	           :on-click (fn [e] 
	                       (reset! current-event nil)
	                       (session/put! :current-page #'manage-page))} "Back To Manage Submissions"]]]]
    [:div.panel.panel-default
     [:div.panel-heading 
      [:h3.panel-title "Really???"]]
     [:div.panel-body
	     [:p "Are you sure you want to hide the evidence?"]
	     [:div.btn-group.btn-group-justified
		     [:a.btn.btn-default {:href "#/manage"
	           :on-click (fn [e]
		                      (let [id (:id @current-event)
		                            ref (.child fb id)]
		                        (.remove ref)
		                        (reset! current-event nil)
		                        (session/put! :current-page #'manage-page)))} "Yes, I'm a pussy."]
		     [:a.btn.btn-default {:href "#/manage"
	           :on-click (fn [e] 
	                       (reset! current-event nil)
	                       (session/put! :current-page #'manage-page))} "Hell No!."]]]]))
  

(defn manage-page
  []
  (let [who (get-in auth ["uid"])]
	  [:div 
     [:h3.panel-title "Manage Your Insults To Those Deserving Bastards!"]
     [:div.panel-body
		   [:table#manage.table {:style {:width "100%"}}
		    [:tr
		     [:th "Service"] [:th "Drunk"] [:th "Target Person"] [:th "Target Keyword"] [:th "Insult"] [:td who]]
	     (for [event @events]
	       [:tr {:key (:id event)}
          [:td (:provider event)]
	        [:td (or (and (:drunk event) "Yep") "Nope")]
	        [:td (:target event)]
	        [:td (:keyword event)]
	        [:td (:content event)]
	        [:td [:button.btn.btn-default {:type "button" 
	                                       :on-click (fn [e] 
	                                                   (reset! current-event event)
	                                                   (session/put! :current-page #'delete-page))} "Delete"]]])]]
     [:div.btn-group.btn-group-justified
      [:a.btn.btn-default {:href "#/submit"} "Add Another"]]]))

(.on fb "child_added" handle-childsnapshot)
(.on fb "child_removed" handle-childsnapshot-remove)

(secretary/defroute "/manage" []
  (session/put! :current-page #'manage-page))
