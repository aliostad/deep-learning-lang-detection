
(ns app.comp.resizer
  (:require-macros [respo.macros :refer [defcomp <> span button div a]])
  (:require [hsl.core :refer [hsl]]
            [app.schema :as schema]
            [respo-ui.style :as ui]
            [respo-ui.style.colors :as colors]
            [respo.core :refer [create-comp]]
            [respo.comp.space :refer [=<]]))

(defn on-inc [e dispatch! mutate!] (dispatch! :board/increase nil))

(defn on-dec [e dispatch! mutate!] (dispatch! :board/decrease nil))

(defn on-reset [e dispatch! mutate!] (dispatch! :board/reset-board nil))

(defcomp
 comp-resizer
 (current-size grid-area)
 (div
  {:style {:grid-area grid-area}}
  (<> span current-size nil)
  (=< 8 nil)
  (button {:inner-text "increase", :style ui/button, :event {:click on-inc}})
  (=< 8 nil)
  (button {:inner-text "decrease", :style ui/button, :event {:click on-dec}})
  (=< 8 nil)
  (button {:inner-text "reset", :style ui/button, :event {:click on-reset}})))
