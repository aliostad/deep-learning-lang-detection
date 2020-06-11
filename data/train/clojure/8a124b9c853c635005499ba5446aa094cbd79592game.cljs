(ns app.pages.game
  (:require-macros [app.logging :refer [log]])
  [:require [app.components.grid :as grid]
            [reagent.core :refer [create-class]]
            [app.routes :as r]
            [re-frame.core :refer [dispatch subscribe]]])

(defn main []
  (let [loading? (subscribe [:loading?])
        user (subscribe [:user])
        game-id (second (clojure.string/split (r/get-token) "/"))]
    (create-class
      {:component-did-mount #(dispatch [:join-game game-id])
       :component-will-mount #(if (not @user) (dispatch [:redirect-to-login]))
       :component-will-unmount #(dispatch [:leave-game])
       :display-name "game-page"
       :reagent-render
       (fn []
         [:section.game-container
          (if @loading? [:div.spinner]
            [grid/main])])})))
