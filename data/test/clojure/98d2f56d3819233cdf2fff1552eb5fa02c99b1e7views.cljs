(ns webinar.views
  (:require [webinar.storage :as storage]
            [webinar.store :as store]))


(def drum-animation
  [:animateTransform
   {:attributeType "XML"
    :attributeName "transform"
    :type          "scale"
    :from          1
    :to            1.04
    :dur           "0.1s"
    :begin         "click"}])


(defn play
  "Play sound by specified name"
  [drum-id]
  (let [sound (get storage/sounds drum-id)]
    (doto sound
      (aset "currentTime" 0)
      (.play))))


(defn Panel
  "Abstract panel for controls"
  ([Controls]
   [Panel {} Controls])

  ([props Controls]
   [:g props
    [:rect {:x       0
            :y       -0.6
            :width   10
            :height  0.6
            :opacity 0.4
            :fill    "#FFF"}]
    Controls]))


(defn Text
  "Wrapped text tag"
  [params text]
  [:text (merge
           {:fill        "#000"
            :stroke      "none"
            :font-size   "0.3px"
            :text-anchor "middle"
            :style       {:-webkit-user-select "none"
                          :-moz-user-select    "none"}}
           params)
   text])


(defn EditControls
  "Controls to add and delete drums"
  []
  [Panel
   [:g
    [Text {:x        1
           :y        -0.2
           :cursor   :pointer
           :on-click #(store/dispatch
                        :toggle-add-panel)}
     "Add"]

    [Text {:x 5
           :y -0.2}
     "Delete"]

    [Text {:x        9
           :y        -0.2
           :cursor   :pointer
           :on-click #(store/dispatch-all
                        [[:hide-add-panel]
                         [:set-app-mode :play]])}
     "Play"]]])


(defn PlayControls
  "Button to turn on edit mode"
  []
  [Panel {:opacity 0.3}
   [Text {:x        5
          :y        -0.2
          :cursor   :pointer
          :on-click #(store/dispatch
                       :set-app-mode :edit)}
    "Edit"]])


(defn AddDrumPanel
  "Panel for adding new drum"
  []
  (into

    [:g
     [:rect {:x       0
             :y       0
             :width   10
             :height  0.6
             :opacity 0.3
             :fill    "#FFF"}]]

    (mapv
      (fn [[drum-id drum] i]
        [Text {:x        (:name-position drum)
               :y        0.4
               :cursor   :pointer
               :on-click #(store/dispatch
                            :add-drum drum-id)}
         (:name drum)])
      storage/drums)))


(defn ControlPanel
  "Controls to manage app"
  [{:keys [app-mode add-dialog-visible?]}]
  [:g
   (if (= app-mode :edit)
     [EditControls]
     [PlayControls])
   (when add-dialog-visible?
     [AddDrumPanel])])


(defn playing?
  "Answers is playing mode now"
  [mode]
  (= :play mode))


(defn cymbal?
  "Answers is type is cymbal"
  [type]
  (= type :cymbal))


(defn drumActionAttrs
  "Returns events handlers depends on current mode"
  [drum-id mode]
  (if (playing? mode)
    {:on-click #(play drum-id)}

    {:on-mouse-down #(store/dispatch
                       :start-dragging-drum drum-id)}))


(def drumCommonAttrs
  {:stroke       "#000"
   :stroke-width 0.01
   :style        {:transform-origin "50% 50%"}})


(defn Drum
  "Returns markup for single drum"
  [[drum-id {:keys [x y]}] current-mode]
  (let [drum        (get storage/drums drum-id)
        size        (:size drum)
        type        (:type drum)
        drumActions (drumActionAttrs drum-id current-mode)
        drumColor   {:fill (if (cymbal? type) "#FFCC80" "#FAFAFA")}
        drumAttrs   (merge
                      drumCommonAttrs
                      drumActions
                      drumColor)]

    [:g drumAttrs
     [:circle {:r  size
               :cx x
               :cy y}]

     (when-not (cymbal? type)
       [:circle {:r  (- size 0.05)
                 :cx x
                 :cy y
                 :stroke-width 0.03}])

     [Text {:x x
            :y y}
      (:name drum)]

     (when (playing? current-mode)
       drum-animation)]))


(defn App
  "Returns app markup"
  [state]
  (let [app-state    @state
        kit          (:kit app-state)
        current-mode (:app-mode app-state)]

    [:div.drum-kit

     (into
       [:svg#canvas {:view-box "0 0 10 6"
                     :overflow "visible"}
        [ControlPanel app-state]]

       (for [drum kit]
         [Drum drum current-mode]))]))
