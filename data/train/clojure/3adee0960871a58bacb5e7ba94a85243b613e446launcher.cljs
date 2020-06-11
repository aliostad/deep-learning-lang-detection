
(ns global-popup.comp.launcher
  (:require-macros [respo.macros :refer [defcomp <> div span]])
  (:require [respo.core :refer [create-comp]] [respo-ui.style :as ui]))

(def style-bar {:padding "8px 16px"})

(defn on-popover-add [e dispatch!]
  (let [event (:original-event e)]
    (.stopPropagation event)
    (dispatch!
     :popup/add
     {:type :popover,
      :name :demo,
      :position {:x (.-clientX event), :y (.-clientY event), :w 320, :h 160}})))

(defn on-modal-add [e dispatch!] (dispatch! :popup/add {:type :modal, :name :demo}))

(defcomp
 comp-launcher
 ()
 (div
  {}
  (div
   {:style style-bar}
   (div {:style ui/button, :on {:click on-modal-add}} (<> "add modal")))
  (div
   {:style style-bar}
   (div {:style ui/button, :on {:click on-popover-add}} (<> "add popup")))))
