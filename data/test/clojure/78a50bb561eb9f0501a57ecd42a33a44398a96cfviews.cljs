(ns freecell-web.views
    (:require [re-frame.core :refer [subscribe dispatch]]
              [cljs.pprint :refer [pprint]]
              [clojure.string :refer [join]]
              [freecell-web.subs]
              [freecell-web.cards :refer [display-string color]]))

(defn classes [& cs]
  (join \space (map name (filter identity cs))))

(defn card [c location & [on-click]]
  [:span
   {:class
     (if c
       (classes
         (color c) (:suit c) (str "n" (:n c)) location "card")
       (classes "no-card" location))
    :on-click on-click}
   (display-string c)])

(defn enumerate [l]
  (map-indexed vector l))

(defn freecells []
  (let [cells (subscribe [:cells])]
    (fn []
      [:div
       {:class "hold-freecells"}
       (for [[i c] (enumerate @cells)]
         ^{:key i}
         [card c "freecell" #(dispatch [:click-freecell i])])])))

(defn sinks []
  (let [cards (subscribe [:sinks])]
    (fn []
      [:div
       {:class "hold-sinks"
        :on-click #(dispatch [:click-sink])}
       (for [c @cards]
         ^{:key (:suit c)}
         [card c "sink"])])))

(defn top-row []
  [:div
   {:class "top-row"}
   [freecells]
   [sinks]])

(defn column [i cards]
  (let [selected (subscribe [:selected i])]
    (fn [i cards]
      [:div
       {:class (classes "card-column" (when @selected "card-column-selected"))
        :on-click #(dispatch [:click-column i])}
       (for [[i c] (enumerate (or (seq (reverse cards)) [nil]))]
         ^{:key i}
         [card c "column"])])))

(defn columns []
  (let [cs (subscribe [:columns])]
    (fn []
      [:div
       {:class "columns"}
       (for [[i c] (map-indexed vector @cs)]
         ^{:key i}
         [column i c])])))

(defn button-row []
  [:div
   {:style {:float :down}
    :class "bottom-row"}
   [:button
    {:on-click #(dispatch [:reset])}
    "Reset"]
   [:button
    {:on-click #(dispatch [:undo])}
    "Undo"]
   [:button
    {:on-click #(dispatch [:initialize-db])}
    "New game"]
   [:button
    {:on-click #(dispatch [:redo])}
    "Redo"]
   [:button
    {:on-click #(dispatch [:redo-all])}
    "Redo All"]])

(defn main-panel []
  [:div
   {:class "freecell-game"}
   [button-row]
   [top-row]
   [columns]
   ])

(defn dispatch-timer-event []
  (dispatch [:auto-sink]))

(defonce do-timer
  (js/setInterval dispatch-timer-event 250))

(defn dispatch-save-timer-event []
  (dispatch [:save-state]))

(defonce save-timer
  (js/setInterval dispatch-save-timer-event 5000))
