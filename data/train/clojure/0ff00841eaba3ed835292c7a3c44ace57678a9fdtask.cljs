
(ns reel.comp.task
  (:require-macros [respo.macros :refer [defcomp <> div button input]])
  (:require [respo.core :refer [create-comp]]
            [hsl.core :refer [hsl]]
            [respo.comp.space :refer [=<]]
            [respo-ui.style :as ui]
            [respo-ui.style.colors :as colors]))

(defn on-input [task-id] (fn [e dispatch!] (dispatch! :task/edit [task-id (:value e)])))

(def style-done
  {:width 32, :height 32, :display :inline-block, :background-color colors/attractive})

(defn on-toggle [task-id] (fn [e dispatch!] (dispatch! :task/toggle task-id)))

(defn on-remove [task-id] (fn [e dispatch!] (dispatch! :task/remove task-id)))

(def style-container {:margin "8px 0", :height 32})

(defcomp
 comp-task
 (task)
 (div
  {:style style-container}
  (div
   {:style (merge style-done (if (:done? task) {:background-color colors/warm})),
    :on {:click (on-toggle (:id task))}})
  (=< 8 nil)
  (input
   {:value (:text task),
    :placeholder "Content of task",
    :on {:input (on-input (:id task))},
    :style ui/input})
  (=< 8 nil)
  (button
   {:style (merge ui/button {:background-color colors/irreversible}),
    :on {:click (on-remove (:id task))}}
   (<> "Remove"))))
