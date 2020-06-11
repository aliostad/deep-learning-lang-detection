(ns reagent-talk.core
  (:require [reagent.core :as reagent :refer [atom]]
            [reagent.session :as session]
            [secretary.core :as secretary :include-macros true]
            [goog.events :as events]
            [goog.history.EventType :as EventType]
            [cljsjs.react :as react])
  (:import goog.History))

;; -------------------------
;; Model


;; -------------------------
;; Views

(defn timer-component
  ([] (timer-component 0))
  ([init-value]
   (let [seconds-elapsed (atom init-value)]     ;; setup, and local state
     (fn []        ;; inner, render function is returned
       (js/setTimeout #(swap! seconds-elapsed inc) 1000)
       [:div "Seconds Elapsed: " @seconds-elapsed]))))

(defn counter-component []
  (let [click-count (atom 0)]
    (fn []
      [:div
       "The atom " [:code "click-count"] " has value : "
       @click-count ". "
       [:input {:type "button" :value "Click me!"
                :on-click #(swap! click-count inc)}]])))

(defn home-page []
  [:div [:h2 "Reagent Talk"]
   [:ol
    [:li [:a {:href "#/cljs"} "ClojureScript"]]
    [:li [:a {:href "#/react"} "react.js concepts"]]
    [:li [:a {:href "#/atom"} "atom"]]
    [:li [:a {:href "#/reagent"} "reagent"]]
    [:li [:a {:href "#/others"} "other libraries"]]
    [:li "play time! / demo time"]]])

(defn out-link [link text]
  [:a {:href link :target "_blank"} text]
  )

(defn react-page []
  [:div [:h2 (out-link "https://facebook.github.io/react/"
                       "React.js") " by Facebook"]
   [:ul [:li "virtual DOM"]
    [:li "one-way data flow " [:br]
     [:code "State->Component"]]
    [:li "re-render, don't mutate"]]
   ])

(defn clojurescript-page []
  [:div [:h2 "ClojureScript"]
   [:ul
    [:li "Clojure compiled to javascript"]
    [:li "Using " (out-link "https://developers.google.com/closure" "Google Closure Tools/Library")]
    [:li "Source map available"]
    [:li "Figwheel"]]])

(defn atom-page []
  [:div [:h2 "Atoms"]
   (out-link "http://clojure.org/atoms" "Atoms")
   " provide a way to manage share, synchronous, independent state (not coordinated)."
   [:ol
    [:li "create atom: "
     (out-link "http://clojuredocs.org/clojure.core/atom"
               "atom") [:br]
     " example: "  [:code "(def counter (atom 0))"]]
    [:li "acces state: "
     (out-link "http://clojuredocs.org/clojure.core/deref"
               "@ / deref") [:br]
     " example: " [:code  "@counter"]]
    [:li "change value: "
     (out-link "http://clojuredocs.org/clojure.core/swap!"
               "!swap") [:br]
     " example: " [:code "(swap! counter inc)"]]]])


(defn reagent-page []
  [:div [:h2 "Reagent by Dan Holmsand"]
   [:ol
    [:li "components: cljs functions & data that describe the
UI with a Hiccup-like syntax"]
    [:li "state: atoms"]
    [:li "bootstrap: " [:code "reagent.core/render-component"]
     [:li [:a {:href "http://reagent-project.github.io/"
               :target "_blank"}
           "the docs & examples"
           ]]
     [counter-component]
     [timer-component]]]
   "Get started >> "[:code "lein new reagent my-cool-spa"]])

(defn others-page []
  [:div [:h2 "Other cljs libraries for SPAs."]
   [:ul
    [:li "core/async " (out-link "https://github.com/cognitect/async-webinar/blob/master/src/webinar/core.cljs" "(examples)")]
    [:li (out-link "https://github.com/gf3/secretary"
                   "Secretary")
     " client-site router"]
    [:li [:a {:href "https://github.com/JulianBirch/cljs-ajax" :target "_blank"}
          "cljs-ajax"]
     " simple Ajax client"]
    [:li [:a {:href "https://github.com/ptaoussanis/tower" :target "_blank"}
          "Tower"]
     " i18n and l10n library"]
    [:li "..."]]
   [:h2 [:a {:href "http://www.luminusweb.net/" :target "_blank"} "Luminus"]]
   " a micro-framework that uses all the above (version 2)"]
  )

(defn current-page []
  [:div [(session/get :current-page)]])


;; -------------------------
;; Routes
(secretary/set-config! :prefix "#")

(secretary/defroute "/" []
  (session/put! :current-page #'home-page))

(secretary/defroute "/react" []
  (session/put! :current-page #'react-page))

(secretary/defroute "/cljs" []
  (session/put! :current-page #'clojurescript-page))

(secretary/defroute "/reagent" []
  (session/put! :current-page #'reagent-page))

(secretary/defroute "/atom" []
  (session/put! :current-page #'atom-page))

(secretary/defroute "/others" []
  (session/put! :current-page #'others-page))

;; -------------------------
;; History
;; must be called after routes have been defined
(defn hook-browser-navigation! []
  (doto (History.)
    (events/listen
     EventType/NAVIGATE
     (fn [event]
       (secretary/dispatch! (.-token event))))
    (.setEnabled true)))

;; -------------------------
;; Initialize app
(defn mount-root []
  (reagent/render [current-page] (.getElementById js/document "app")))

(defn init! []
  (hook-browser-navigation!)
  (mount-root))
