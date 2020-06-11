(ns omnext-demo.media-player
  "Component hosting the Vimeo media player.

  After the component is \"mounted\", it creates an instance of the
  *Vimeo Player*, and stores it in this component's local state.
  Because this component includes `:video/selected-video` in its
  **query**, it will be re-rendered when the video-selection changes,
  and so can load the video into the *Player* that it manages."
  (:require
   [om.dom :as dom]
   [om.next :as om :refer-macros [defui]]))


(defn create-player
  "Create the Vimeo Player we need.

  Until we have a selected video, we don't need it, so this may not be
  called when we first mount."
  ([this selected-video-id]
   (create-player this selected-video-id "player-place"))
  ([this selected-video-id player-element-id]
   (create-player this selected-video-id player-element-id "DBGLBL"))
  ([this selected-video-id player-element-id debug-label]
   (try
     (let [player-options #js {:id     selected-video-id
                               :width  640
                               :height 480
                               :loop   false}
           player         (Vimeo.Player. player-element-id
                                         player-options)]
       (om/update-state! this assoc :player player))
     (catch js/Error e
       (let [msg (str debug-label ": Player not available\n" e)]
         (println msg)
         (js/alert msg))))))

(defn player-requirements-ok?
  "Are the things we need for a Vimeo Player available?

   - A player location
   - A selected video
   - A selected video that isn't 'NO VIDEO' :-) "
  [this]
  (let [{:keys [player-element-id selected-video] :as props} (om/props this)]
    (and player-element-id
         selected-video
         (not= "NO VIDEO" (:video/id selected-video)))))

(defui ^:once MediaPlayer
  "Manage a *Vimeo Media Player*, updating it as the selected video
  changes.

  `player-element-id` is the ID of the element where the *Vimeo
  Player* is displayed."
  static om/IQuery
  (query [_]
    '[:player-element-id [:selected-video _]])

  Object
  (render [this]
    (if (player-requirements-ok? this)
      (let [{player-element-id :player-element-id
             {selected-video-id :video/id} :selected-video} (om/props this)]
        (dom/div nil
          (dom/div (clj->js {:data-vimeo-id    selected-video-id
                             :data-vimeo-width 640
                             :style            {:width  640
                                                :height 480}
                             :id               player-element-id}))))
      (dom/p nil "Please select a video when available")))

  (componentDidUpdate [this _ _]
    ;; We use neither `prev-props` nor `prev-state`
    (when (player-requirements-ok? this)
      (let [{:keys [selected-video player-element-id]} (om/props this)
            {selected-video-id :video/id} selected-video]
        ;; Use the existing Vimeo player, or create a new one if there
        ;; isn't one
        (if-let [player (om/get-state this :player)]
          (.loadVideo player selected-video-id)
          (create-player this selected-video-id player-element-id "CDU")))))

  (componentDidMount [this]
    (when (player-requirements-ok? this)
      (let [props (om/props this)
            {:keys [player-element-id selected-video]} props
            selected-video-id (:video/id selected-video)]
        (if-let [player (om/get-state this :player)]
          ;; Re-use player that already exists
          (.loadVideo player selected-video)
          ;; Create a new player
          (create-player this selected-video-id player-element-id "CDM"))))))

(def media-player (om/factory MediaPlayer))
