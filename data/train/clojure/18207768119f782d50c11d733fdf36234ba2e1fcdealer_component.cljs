(ns solitaire-web.solitaire-panel.dealer-component
  (:require-macros [reagent.ratom :refer [reaction]])
  (:require [re-frame.core :refer [subscribe dispatch]]
[re-com.core  :refer [h-box v-box box gap line label checkbox radio-button button single-dropdown
                                  popover-content-wrapper popover-anchor-wrapper]]
            [re-com.util  :refer [deref-or-value]]
            [reagent.core :as    reagent]
            [reanimated.core :as anim]
            )) 

(def welcome-dialog
  [:div
    [:p "Welcome to Vegas solitaire!"]
    [:p "My name is Bob."]
    [:p "Shall we start the game?"]
    [:button 
     {:on-click #(dispatch [:set-scene :scene-2])}
     "Sure!"] ])

(def intro-dialog
  [:div
    [:p "Here is how much you win so far."]
    [:p "Shall we start?"]
    [:button 
     {:on-click #(do (dispatch [:deal-cards])
                     (dispatch [:set-scene :in-game])
                     (dispatch [:set-dealer-dialog-visible false])
                   )}
      "Deal!"]
   ])

(def in-game-dialog
  [:div [:p "Should never be showed"] ])

(def pause-game-dialog
  [:div [:p "Pause game dialog"]])

(def won-game-dialog
  [:div
    [:p "Congrats!"]
    [:button 
     {:on-click #(do (dispatch [:deal-cards])
                     (dispatch [:set-scene :in-game])
                     (dispatch [:set-dealer-dialog-visible false])
                   )}
     "Deal again"]])

(def scenes
  {:pause   {:dialog pause-game-dialog
             :avatar "images/dealer/avatar-hide-hands.png"}
   :in-game {:dialog in-game-dialog
             :avatar "images/dealer/avatar-smile.png"}
   :scene-1 {:dialog welcome-dialog
             :avatar "images/dealer/avatar-small-eyes.png"}
   :scene-2 {:dialog intro-dialog
             :avatar "images/dealer/avatar-intro.png"}
   :scene-4 {:dialog won-game-dialog
             :avatar "images/dealer/avatar-cards.png"}})


(defn dealer-main []
  (let [dialog-visible? (subscribe [:dealer-dialog-visible?])
        scene (subscribe [:dealer-scene])
        won?  (subscribe [:won?])]
    (fn []
      (let [_ (if @won? (do (dispatch [:set-scene :scene-4])
                            (dispatch [:set-dealer-dialog-visible true])))
            avatar-img (get-in scenes [@scene :avatar])
            content    (get-in scenes [@scene :dialog])
            ]
      
        [popover-anchor-wrapper
           :showing? dialog-visible?
           :position :below-center
           :anchor   [:div
                       {:class "dealer-avatar"
                        :on-mouse-over #(do (dispatch [:set-scene :pause])
                                          (dispatch [:set-dealer-dialog-visible true]))
                        :on-click #(if @dialog-visible?
                                      (do (dispatch [:set-scene :in-game])
                                          (dispatch [:set-dealer-dialog-visible false]))
                                      (do (dispatch [:set-scene :pause])
                                          (dispatch [:set-dealer-dialog-visible true])))
                                      }
                       [:img {:src avatar-img}] ]
           :popover  [popover-content-wrapper
                       :close-button? false
                       :backdrop-opacity 0.6
                       :on-cancel #(println "do nothing")
                       :body     [:div {:style {:width "30vw" :height "30vH"}}
                                   content]]]
     )))) 

(defn dealer-component []
  [:div 
   {:class "dealer"}
   [dealer-main]])

