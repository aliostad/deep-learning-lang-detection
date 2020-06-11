(ns triggerfish.client.views.menu
  (:require
   [re-frame.core :refer [subscribe dispatch]]
   [triggerfish.client.views.controls :as ctl]))

(defn object-li [obj-name selected-add-obj]
  (let [selected? (= @selected-add-obj obj-name)]
    [:div {
         :class "add-obj"
         :on-click (fn [e]
                     (.stopPropagation e)
                     (dispatch [:add-object obj-name]))}
     [:p obj-name]]))

(defn obj-selector
  "The menu that displays on app startup - displays a list of objects that can be added"
  []
  (let [obj-types     (subscribe [:obj-types])
        selected-add-obj (subscribe [:selected-add-obj])]
    [:div
     (map (fn [obj-name]
            ^{:key (str "object-li: " obj-name)}
            [object-li obj-name selected-add-obj])
          @obj-types)]))

(defn touch-controls
  "Interactive widgets for controlling an object"
  [obj-id control-names]
  [:div {:style {:display "flex"
                 :flex 1
                 :flex-direction "column"
                 :height "80%"}}
   (map (fn [ctl-name]
          ^{:key (str "ctl-" obj-id ctl-name)}
          [ctl/control obj-id ctl-name])
        control-names)])

(defn midi-control [obj-id ctl-name device-name [status-type channel first-data-byte]]
  [:div {:class "midi-control"
         :on-click (fn [e] (dispatch [:subscribe-midi [obj-id ctl-name device-name status-type channel first-data-byte]]))}
   [:p (interpose " " [status-type channel first-data-byte])]])

(defn midi-device [obj-id ctl-name [device-name ctl-list]]
  [:div
   [:h2 device-name]
   (map (fn [ctl] ^{:key (str "midi-control-" ctl)} [midi-control obj-id ctl-name device-name ctl])
        ctl-list)])

(defn control-inspector
  "Manage MIDI subscriptions for a specific control"
  []
  (let [fiddled (subscribe [:recently-fiddled])
        inspected-ctl (subscribe [:inspected-control])
        [obj-id ctl-name] @inspected-ctl]
    [:div
     [:h1 (str obj-id " " (name ctl-name))]
     [:div (map (fn [m]
                  ^{:key (str "midi-device-" (first m))}
                  [midi-device obj-id ctl-name m])
                (filter some? @fiddled))]]))

(defn obj-inspector
  "A display for interactions with a specific object - like setting controls, subscribing MIDI listeners, deleting the object"
  []
  (let [obj (subscribe [:inspected-object])
        {:keys [name obj-id control-names]} @obj]
    [:div
     {:style {:display "flex"
              :height "100%"
              :flex-direction "column"}}
     [:div [:h1 {:style
                 {:text-align "center"}}
            [:div name]]
      [:hr]]
    [touch-controls obj-id control-names]
     [:div {:class "delete-button"
            :on-click (fn [e] (dispatch [:delete-object obj-id]))}
      "delete"]]))

(defn menu
  "A menu on the right-hand side of the screen that handles interactions like selecting object types or interacting with objects"
  []
  (let [menu-visible? (subscribe [:menu-visibility])
        menu-position (subscribe [:menu-position])
        [x y]         @menu-position
        displaying    (subscribe [:current-menu])]
    [:div
     {:on-click (fn [ev] (.stopPropagation ev))
      :style {:position  "fixed"
              :left      x
              :z-index   1
              :top       y
              :min-width 200
              :background-color "#68749c"
              :visibility (if @menu-visible? "visible" "hidden")}}
     [:h1 {:style {:textAlign "center"}} "Add Object"]
     (condp = @displaying
       :main-menu         [obj-selector]
       :obj-inspector     [obj-inspector]
       :control-inspector [control-inspector]
       nil)]))
