(ns trillup.core
  (:require [reagent.core :as r :refer [atom]]
            [reagent.session :as session]
            [trillup.ajax :refer [load-interceptors!]]
            [goog.events :as events]
            [goog.history.EventType :as EventType]
            [ajax.core :as ajax]
            [trillup.components.common :as c]
            [trillup.components.auth :as auth]
            [trillup.components.timeline :as tl]
            [secretary.core :as secretary :refer-macros [defroute]])
  (:import goog.History))

;; 140 characters is the maximum we'll allow
(def ^:const max-length 140)

(secretary/set-config! :prefix "#")

(secretary/defroute "/" []
  (session/put! :page :app))

(secretary/defroute "/about" []
  (session/put! :page :about))

(secretary/defroute "/account" []
  (session/put! :page :account))

;; Our timeline
(defonce tl (atom []))

(defn trill-byline
  "Render the by-line for a trill"
  [e]
  (str "@"
       (:username e)
       " - "
       (:full_name e)
       " - "
       (:created_at e)))

(defn trill-controls
  "Render the controls for a trill"
  [e]
  [:div.controls
   [:a {:href "#"} "favorite"]
   [:a {:href "#"
        :on-click #(tl/delete-trill tl e)} "delete"]])

(defn trill
  "Render a trill in the timeline"
  [e]
  [:li.trill
   [:div.byline
    [:div.dn (trill-byline e)]]
   [:div.body (:body e)]
   [:div.controls (trill-controls e)]])

(defn timeline
  "Render the timeline"
  []
  [:ul#tl
   (for [t (reverse @tl)]
     ^{:key (:id t)} [trill t])])

(defn counter-style
  "Render the correct style for the input counter"
  [val]
  (if (< (- max-length (count @val)) 20)
    {:color "#900"}
    {:color "#333"}))

(defn- not-logged-in-app []
  [:div.splash
   [:h1 "Welcome to Trillup!"]
   [:p "Sign in or Sign up for lots of fun!"]])

(defn- logged-in-app []
  (let [val (r/atom "")]
      (fn []
        [:div
         [:textarea#in {:value @val
                        :placeholder "Trill..."
                        :on-change #(reset! val (-> % .-target .-value))}]
         [:button#post {:disabled (or (zero? (count @val))
                                      (> (count @val) max-length))
                        :on-click #(tl/add-trill tl val)} "Trill"]
         [:div#counter
          {:style (counter-style val)}
          (str (- max-length (count @val)))]
         [:div.c]
         [timeline]])))

(defn about []
  [:div.splash
   [:h1 "Hi, this is the about page"]])

(defn account []
  [:div.splash
   [:h1 "Here, you can manage your account"]])

(defn trillup-app []
  (if (session/get :identity)
    [logged-in-app]
    [not-logged-in-app]))

(defn navbar []
  (let [collapsed? (r/atom false)]
    (fn []
      [:div
       [:h1.logo "trillup"]
       (if-let [user-hash (session/get :identity)]
         [:ul.navbar
          [:li.nav-item [auth/logout-button (:username user-hash) tl]]
          [:li.nav-item [:a {:href "#/about"} "about"]]
          [:li.nav-item [:a {:href "#/"} "home"]]
          [:li.nav-item
           [:i.fa.fa-user] " " [:a {:href "#/account"} (:username user-hash)]]]
         [:ul.navbar
          [:li.nav-item [auth/signin-button]]])])))

(defn modal []
  (when-let [session-modal (session/get :modal)]
    [session-modal tl]))

(def pages {:app #'trillup-app
            :about #'about
            :account #'account})

(defn page []
  [:div
   [modal]
   [(pages (session/get :page))]])

(defn hook-browser-navigation! []
  (doto (History.)
    (events/listen
      EventType/NAVIGATE
      (fn [event]
        (secretary/dispatch! (.-token event))))
    (.setEnabled true)))

(defn mount-components []
  (r/render [#'navbar] (. js/document (getElementById "navbar")))
  (r/render [#'page] (. js/document (getElementById "app"))))

(defn watch-timeline []
  (if (session/get :identity)
    (tl/refresh-timeline tl))
  (js/setTimeout #(watch-timeline) 10000))

(defn init! []
  (load-interceptors!)
  (hook-browser-navigation!)
  (session/put! :identity (js->clj js/identity :keywordize-keys true))
  (mount-components)
  (watch-timeline))
