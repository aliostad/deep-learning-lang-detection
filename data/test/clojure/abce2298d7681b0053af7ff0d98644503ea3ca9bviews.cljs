(ns jam.views
  (:require [re-frame.core :as re-frame]
            [reagent.core :as reagent]
            ;; [reanimated.core :as anim]
            ))


;; home

(defn home-panel []
  (let [name (re-frame/subscribe [:name])]
    (fn []
      [:div (str "Hello from " @name ". This is the jamming Home Page.")
       [:div [:a {:href "#/jam"} "Start"]]
       [:div [:a {:href "#/about"} "go to About Page"]]])))


;; about

(defn about-panel []
  (fn []
    [:div "This is the About Page."
     [:div [:a {:href "#/"} "go to Home Page"]]]))


;; jam

(defn instrument-option [s]
  ^{:key s} [:option {:value s}
             s])

(defn instrument-options [instruments]
  (map (comp instrument-option name key) instruments))

(defn instrument-selector []
  (let [value (re-frame/subscribe [:selected-instrument])
        instruments (re-frame/subscribe [:instruments])]
    [:select {:value @value
              :on-change #(re-frame/dispatch [:select-instrument (keyword (-> % .-target .-value))])
             }
     (instrument-options @instruments)]))

;; (defn spring-test []
;;   (let [size (reagent/atom 24)
;;         size-spring (anim/spring size)]
;;     (fn []
;;       [:p
;;        {:on-click (fn click [e] (swap! size + 10))}
;;        [:svg {:width "500" :height "500"}
;;         [:circle {:cx "250" :cy "250" :r @size-spring}]
;;         ]]))
;;   )

(def time-to-px 30)

(defn jam-seeker []
  (fn []
    (let [position (re-frame/subscribe [:seeker-pos])]
      [:div {:style {:height "100%" :left (str (* time-to-px @position) "px") :position "absolute" :border-left "1px solid red"}}])))


(defn jam-note [style time]
  (let [length "1em"]
     [style {:style {:left (str (* time-to-px time 1) "px"):width length}}]))

(defn jam-notes [top func notes]
  [:ul.track
   {:style {:height "100px"
            :top top
            :position "absolute"}}
   (map-indexed (fn [i [time _]] ^{:key (str i (func time))} [func time]) notes)])

(defn jam-track [notes song top]
  (let [song (map (fn [n] [(:time n) (:pitch n)]) song)]
    [:div
     [jam-notes top (partial jam-note :li.note) notes]
     [jam-notes top (partial jam-note :li.song-note) song]]))

(defn play-pause-button []
  (let [state (re-frame/subscribe [:state])
        content (if (= @state :paused) "Play" "Pause")]
    [:button {:on-click #(re-frame/dispatch [:toggle-play])}
     content]))

(defn reset-button []
  [:button {:on-click #(re-frame/dispatch [:reset])}
   "Reset"])

(defn stop-button []
  [:button {:on-click #(re-frame/dispatch [:stop])}
   "Stop"])

(defn jam-panel []
  (let [tracks (re-frame/subscribe [:tracks])
        song (re-frame/subscribe [:song])]
    (fn []
      [:div
       [:section#jam-main
        [jam-seeker]
        [instrument-selector]
        [reset-button]
        [play-pause-button]
        [stop-button]
        (map-indexed (fn [i [track song-track]]
                       ^{:key (str "track" i)}
                       [jam-track (second track) (second song-track) (* 120 (+ 1 i))])
                     (map vector @tracks @song))]

       [:footer#jam-footer
        [:div.footer-left
         [:a {:href "#/"} "return"]]]])))


;; main

(defn- panels [panel-name]
  (case panel-name
    :home-panel [home-panel]
    :about-panel [about-panel]
    :jam-panel [jam-panel]
    [:div]))

(defn show-panel [panel-name]
  [panels panel-name])

(defn main-panel []
  (let [active-panel (re-frame/subscribe [:active-panel])]
    (fn []
      [show-panel @active-panel])))
