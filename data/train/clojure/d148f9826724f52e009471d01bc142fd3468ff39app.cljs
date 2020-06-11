(ns velcro-notes.app
  (:require [reagent.core :as reagent :refer [atom]]
            [clojure.string :as string]
            [clojure.set :as set]
            [alandipert.storage-atom :refer [local-storage]]))

;; -------------------------
;; Data

(defn now "Function to return the current date as JS date object."
  []
  (js/Date.))

;; -------------------------
;; State
;; We only need two atoms to manage this app.
(def order-prop-state (reagent/atom :date-rev))
(def notes-state (local-storage (reagent/atom
                                 {:notes {}})
                                 :notes-store))

(defn note-field-get-set "Convenience function for accessing stateful note
  fields."
  ([note-field note-id]
   (get-in @notes-state [note-id note-field]))
  ([note-field note-id new-content]
   (swap! notes-state assoc-in [note-id note-field] new-content)))

;; functions updating state
(defonce counter (reagent/atom 1))

(defn add-new-note "Adds a new note to the stored set." []
  (let [id (swap! counter inc)]
    (swap! notes-state assoc id {:note-id id
                                 :body "Click here to edit note text."
                                 :title "New Note" :date (now)})))

(defn delete-note "Drops a note from local storage." [note-id]
  (swap! notes-state dissoc note-id))

;; --------------------------------------------
;; View components

;; Technically there is no difference between "views" and "components" from
;; reagent/clojurescript's perspective, excepting that views are registered as
;; the endpoints of routes with secretary (the reagent router).

(declare 
 <new-note-button>
 <notes-list>
 <note-item>
 <order-prop-select>)

;; util functions
(defn sort-notes "Simple augmentation of the sort-by function to check for
  a special case we're interested in."
  [prop vec]
  (if (= prop :date-rev)
    (reverse (sort-by (comp :date vals) vec))
    (sort-by (comp prop vals) vec)))

;; components
(defn <new-note-button> "Button for adding a new note to the list."
  [label]
  (let [button-label (reagent/atom label)]
    (fn []
      [:div.note-item.special
       [:input.control.add-btn {:type "button" :value @button-label
                                :on-click #(add-new-note)}]])))

(defn <order-prop-select> "Selector that changes the sort-by state atom."
  []
  [:select.control {:value @order-prop-state
                    :on-change #(reset! order-prop-state
                                        (-> % .-target .-value keyword))}
   [:option {:value :date-rev} "Latest"]
   [:option {:value :date} "Earliest"]
   [:option {:value :title} "Title"]])

(defn <notes-list> "A list of notes (sorted by order-prop)"
  [notes-atom order-prop]
  [:div.notes
   (when (-> @notes-atom vals count (> 1))
     ;; if there are any notes
     (for [note (->> @notes-atom
                     (rest) ;; workaround for strange react metadata issue
                     (sort-notes @order-prop))]
           ^{:key (key note)} [<note-item> note]))
   [<new-note-button> "+"]])

(defn <editable-note-field> "An editable field that transforms on click
  or enter."
  [container-type note-id field-name]
  (let [note-get-set (partial note-field-get-set field-name)
        note-contents (reagent/cursor note-get-set note-id)
        editing (reagent/atom false)]
    (fn []
      [:div
       (if-not @editing
         [container-type {:on-click #(reset! editing true)} @note-contents]
         ;; react metadata: auto focus on edit
         ^{:component-did-mount #(.focus (reagent/dom-node %))}
         [:textarea {:value @note-contents
                     :style {:z-index 10} ;; bring in front of other els
                     :on-blur #(reset! editing false)
                     :on-change (fn [evt]
                                  (reset! note-contents
                                          (-> evt .-target .-value)))
                     :on-key-down #(case (.-which %)
                                     13 (reset! editing false) ;; enter case
                                     27 (reset! editing false) ;; escape case
                                     nil)}])])))

(defn <delete-button> "A button that deletes a note from the state."
  [button-label note-id]
  [:input.control.note.delete-btn {:type "button" :value button-label
                                   :on-click #(delete-note note-id)}])

(defn <note-item> [note-map]
  (let [note-id (first note-map)
        date (get-in (second note-map) [:date])]
    [:div.note-item
     [:div.note-title
      [<editable-note-field> "h1" note-id :title]
      [<delete-button> "X" note-id]]
     [:h6.date (str date)]
     [<editable-note-field> "h5.note-body" note-id :body]]))


;; -------------------------
;; Views

;; There's only the one view so far.
(defn main-page []
  [:div
   [:div.titlebar [:h1 "VELCRONOTES"]]
   [:article
    [:div.main-controls
     [:label "Sort by:"
      [<order-prop-select>]]]
    [<notes-list> notes-state order-prop-state]
    ]])

;; -------------------------
;; Initialize app

(defn mount-root []
  (reagent/render [main-page]  (.getElementById js/document "container")))

(defn init []
  (mount-root))
