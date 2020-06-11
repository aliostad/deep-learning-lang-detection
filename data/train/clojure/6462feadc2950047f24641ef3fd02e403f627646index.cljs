(ns contrast.pages.index
  (:require [cljs.core.async :refer [put! chan mult tap close! <!]]
            [contrast.components.fixed-table :refer [fixed-table-component]]
            [contrast.components.state-display :refer [state-display-component]]
            [contrast.hotkeys :as hotkeys]
            [contrast.instrumentation :as instrumentation]
            [contrast.pages.shared-content :as shared]
            [contrast.page-triggers :as page-triggers]
            [contrast.state :as state]
            [om.dom :as dom :include-macros true]
            [om.core :as om :include-macros true])
  (:require-macros [cljs.core.async.macros :refer [go-loop]]))

(enable-console-print!)

(defonce roots
  (atom
   {"1-twosides" [(fn [] shared/single-gradient) :single-sinusoidal-gradient]
    "2-sweep-grating" [(fn [] shared/sweep-grating) :sweep-grating]
    "3-harmonic-grating" [(fn [] shared/harmonic-grating) :harmonic-grating]
    "4-drag-and-inspect" [(fn [] shared/drag-and-inspect) :drag-and-inspect]}))

(defn workaround-component [_ _]
  (reify
    om/IDisplayName
    (display-name [_]
      "Om workaround dummy")

    om/IRender
    (render [_])))

(defn install-root [r]
  (let [[element-id [ff v frootm never-instrument?]] r
        el (js/document.getElementById element-id)
        methods (cond-> om/pure-methods
                        (and (not never-instrument?)
                             (:instrument? @state/app-state))
                        (instrumentation/instrument-methods state/component-data))
        descriptor (om/specify-state-methods! (clj->js methods))]
    (om/root (ff) v
             (assoc (when frootm (frootm))
               :target el
               :descriptor descriptor))))

(defn inject-root-element
  ([id ff v]
     (inject-root-element id ff v nil))
  ([id ff v frootm]
     (inject-root-element id ff v frootm false))
  ([id ff v frootm never-instrument?]
     (let [el (js/document.createElement "div")
           r [id [ff v frootm never-instrument?]]]
       (.setAttribute el "id" id)
       (.appendChild js/document.body el)
       (swap! roots conj r)
       (install-root r))))

(defn remove-root-element [id]
  (let [el (js/document.getElementById id)]
    (swap! roots dissoc id)
    (om/detach-root el)
    (-> el .-parentElement (.removeChild el))))

(defn on-code-reload []
  ;; There must be a root on the base app-state. Otherwise Om never specifies
  ;; IRenderQueue onto the atom.
  (let [ordered-roots (into [["renderqueue-workaround" [(fn []
                                                          workaround-component)
                                                        state/app-state]]]
                            @roots)]
    (mapv install-root ordered-roots))

  (doseq [[m f] {{:modifiers [:ctrl]
                  :char "j"}
                 (fn []
                   (if (-> state/app-state
                           (swap! update-in [:hood-open?] not)
                           :hood-open?)
                     (inject-root-element "app-state"
                                          (fn []
                                            state-display-component)
                                          state/app-state)
                     (remove-root-element "app-state")))
                 {:modifiers [:ctrl]
                  :char "k"}
                 (fn []
                   (if (-> state/app-state
                           (swap! update-in [:instrument?] not)
                           :instrument?)
                     (inject-root-element "component-stats"
                                          (fn []
                                            fixed-table-component)
                                          state/component-data
                                          (fn []
                                            {:opts {:extract-table
                                                    instrumentation/aggregate-update-times}})
                                          true)
                     (remove-root-element "component-stats"))
                   (page-triggers/reload-code))
                 {:modifiers [:ctrl]
                  :char "l"}
                 (fn []
                   (reset! state/component-data {}))}]
    (hotkeys/assoc-global m f)))

;; For sliders, editors, etc., it's useful to box its value in a dedicated data
;; structure so that it doesn't have to rerender every time a sibling value
;; changes.
;; Use (when ...) rather than (defonce ...) because boot-reload sometimes
;; injects pages into one another, so defonce isn't sufficient.
(when (= @state/app-state {})

  (let [el (js/document.createElement "div")]
    (.setAttribute el "id" "renderqueue-workaround")
    (js/document.body.appendChild el))

  (swap! state/app-state merge
         {:hood-open? false
          :inspectors {:single-sinusoidal-gradient {:color-inspect {:selected-color nil}
                                                    :row-inspect {:is-tracking? false
                                                                  :locked {:probed-row 30}}}
                       :sweep-grating {:color-inspect {:selected-color nil}
                                       :row-inspect {:is-tracking? false
                                                     :locked {:probed-row 30}}}
                       :harmonic-grating {:color-inspect {:selected-color nil}}
                       :drag-and-inspect {:color-inspect {:selected-color nil}
                                          :row-inspect {:is-tracking? false
                                                        :locked {:probed-row 30}}}}
          :figures {:single-sinusoidal-gradient {:width 500
                                                 :height 256
                                                 :transition {:radius 250}
                                                 :spectrum {:left {:color [0 0 0]
                                                                   :position -1}
                                                            :right {:color [255 255 255]
                                                                    :position 1}}}
                    :sweep-grating {:width 500
                                    :height 256
                                    :wave {:form :sine}
                                    :left-period {:period 90}
                                    :right-period {:period 1}

                                    :horizontal-easing {:p1 {:x 0.25
                                                             :y 0.50}
                                                        :p2 {:x 0.70
                                                             :y 0.70}}
                                    :vertical-easing {:p1 {:x 0.25
                                                           :y 0.50}
                                                      :p2 {:x 0.70
                                                           :y 0.70}}

                                    :spectrum {:left {:color [136 136 136]
                                                      :position -1}
                                               :right {:color [170 170 170]
                                                       :position 1}}}
                    :harmonic-grating {:width 500
                                       :height 256
                                       :frequency {:period 100}
                                       :spectrum {:left {:color [136 136 136]
                                                         :position -1}
                                                  :right {:color [170 170 170]
                                                          :position 1}}
                                       :wave {:form :sine}
                                       :harmonic-magnitude "1 / n"
                                       :harmonics [1 3 5 7 9 11 13
                                                   15 17 19 21 23 25
                                                   27 29 31 33 35 37 39]}
                    :drag-and-inspect {:img-src nil}}})

  (let [reloads (chan)]
    (tap page-triggers/code-reloads reloads)
    (go-loop []
      (<! reloads)
      (on-code-reload)
      (recur))
    :listening))
