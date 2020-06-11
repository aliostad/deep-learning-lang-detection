(ns game.core
    (:require 
      [reagent.core :as reagent]
      [re-frame.core :as re-frame :refer [dispatch]]
      [re-frisk.core :refer [enable-re-frisk!]]
      [game.events]
      [game.subs]
      [game.effects]
      [game.views :as views]
      [game.config :as config]
      [cljsjs.pixi]))


(defn dev-setup []
  (when config/debug?
    (enable-console-print!)
    (enable-re-frisk!)
    (println "dev mode")))

(defn mount-root []
  (re-frame/clear-subscription-cache!)
  (reagent/render [views/pixi-renderer]
                  (.getElementById js/document "app")))

(defn init-pixi []
  (doto js/PIXI.loader
    (.add "brown-block" "assets/Brown_Block.png")
    (.add "grass-block" "assets/Grass_Block.png")
    (.add "heart" "assets/Heart.png")
    (.load
      (fn [_]
        (dispatch [:pixi/start])
        (dispatch [:pixi.sprites/create {:id 0 :x 0 :y 0 :image "grass-block"}])
        (dispatch [:pixi.sprites/create {:id 1 :x 20 :y 20 :image "heart"}])
        (dispatch [:pixi.sprites/create {:id 2 :x 40 :y 40 :image "brown-block"}])
        (js/setInterval
          #(dispatch [:pixi.sprites/move {:id 1 :x 2 :y 1}])
          100)))))

(defn ^:export init []
  (re-frame/dispatch-sync [:initialize-db])
  (dev-setup)
  (mount-root)
  (init-pixi))

