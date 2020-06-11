(ns ^:figwheel-always hello-fig.core
    (:require
              [reagent.core :as reagent :refer [atom]]
              [cljsjs.react :as react]
              [re-frame.core :refer [register-handler path register-sub dispatch subscribe]]
              [re-com.core :refer [h-box v-box box gap line border label title alert-box]
                            :refer-macros [handler-fn]]
              [re-com.util :refer [get-element-by-id item-for-id]]))

;; Done: Figure out how to get 2 or more Jtab components on same page
;; Done: Figure out how to get the BPM of the exercise on the title line right justified.
;; Done: Manage todos in Intellij?
;; TODO: Choose shortcuts for structural movement keys
;; TODO: Add macro for select defun and reformat
;; TODO: Figure out how to render multiple "exercises" in one "session"
;; TODO: Design the exercise player
;; TODO: Design the session design interface
;; TODO: Make the Content area center justified

(enable-console-print!)

;; define your app data so that it doesn't get over-written on reload

(defonce app-state (reagent/atom {:text "Hello World!"}))

(defonce layout-state (reagent/atom {}))

(defn jtab-component
  [id tab]
  (let [tabdiv (str "div#" id)]
    (reagent/create-class
    {:component-did-mount (fn [] (.render js/jtab tabdiv tab))
     :reagent-render      (fn [] [tabdiv] )
     :display-name        "jtab-component"
     })))

(defn exercise
  "jtid is the ID of the div where the tab will be displayed"
  [jtid name desc tab bpm]
  [v-box
   :size "auto"
   :gap "8px"
   :children
   [[h-box
     :size "auto"
     :children
     [[title
       :label (str name ":")
       :level :level2
       ;;:margin-bottom "0.0em"
       ]
      [box
       :size "auto"
       :justify :end
       :padding "0px 20px 0px 0px"
       :child [title
               :label (str bpm " BPM")
               :level :level2]]]]
    [label
     :label desc]
    [jtab-component jtid tab]]])

(defn session
  []
  [v-box
   :size "auto"
   :margin "0px 0px 0px 10px"
   :children
   [[title
     :label "Tues May 19th, 2015"
     :level :level1
     :underline? true
     ]
    [exercise
     "exercise1"
     "Warmup Exercise 1"
     "Alternate pick 1st and 2nd finger to the 12th fret and back. Repeat 10 times."
     "C / / Bm"
     "65"]
    [exercise
     "exercise2"
     "Warmup Exercise 2"
     "Alternate pick 1st and 3nd finger to the 12th fret and back. Repeat 10 times."
     "$1 1 3 1 3 2 4 2 4 3 5 3 5 4 6 4 6 5 7 5 7 6 8 6 8"
     "63"]
    ]])

(defn layout []
  (let [mouse-over? (reagent/atom false)]
    (fn []
      [v-box
       :size "auto"
       :children [
        [box
         :child "Header"]
        [h-box
         :size "auto"
         :children [
          [box
           :size "200px"
           :child "Nav"
           :style (if @mouse-over? {:background-color "silver"}
                                   {:background-color "#e8e8e8"})
           :attr {:on-mouse-over (handler-fn (reset! mouse-over? true))
                  :on-mouse-out  (handler-fn (reset! mouse-over? false))}]
          [session]
                    ]
         ]
        [box
         :child "Footer"
         ;;:style {:background-color "silver"}
         ]
        ]]
      )))


(defn hello-world []
  [:h1 (:text @app-state)])

(reagent/render-component [layout]
                          (. js/document (getElementById "app")))

(defn on-js-reload []
  ;; optionally touch your app-state to force rerendering depending on
  ;; your application
  (swap! app-state update-in [:__figwheel_counter] inc)
) 

