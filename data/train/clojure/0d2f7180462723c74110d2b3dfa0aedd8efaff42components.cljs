(ns trumpet.ui.components
  "This namespace contains the application's React
  components that render the user interface."
  (:require [reagent.core :as reagent]
            [trumpet.logic.sounds :as sounds]
            [trumpet.logic.scales :as scales]
            [trumpet.logic.instruments :as instrument]
            [cljs.pprint :refer [pprint]]))

;; -- components --

(defn instrument-selector
  "Renders a component that allows the user to select their
  instrument. Changing the current instrument will update
  the application state with the correct transposition."
  [state]
  [:div#instrument.form-group
   [:label.control-label {:for "select-instrument"} "Instrument: "]
   [:select.form-control {:id "select-instrument"
             :value (:instrument @state)
             :on-change
             (fn [e]
               (let [selected (.. e -target -value)]
                 (swap! state assoc
                        :instrument selected
                        :transposition (get instrument/transpositions selected))))}
    (doall
     (map-indexed
      (fn [idx [instrument transposition]]
        ^{:key (str "instrument-" idx)}
        [:option {:value instrument}
         instrument]) instrument/transpositions))]])

(defn scale-selector
  "Component to select a major or minor scale to render."
  [state]
  (let [make-scale (fn [which]
                     (fn [coll]
                       (into coll
                             (mapv #(str (name %1) %2) scales/note-names (repeat which)))))
        maj-scale-fn (make-scale "maj")
        min-scale-fn (make-scale "min")
        separator    "---"
        scale-list (-> []
                       maj-scale-fn
                       (into [separator])
                       min-scale-fn)]

    [:div.scale.form-group
     [:label.control-label {:for "select-scale"} "Scale: "]
     [:select.form-control {:id "select-scale"
               :value (:scale @state)
               :on-change (fn [e]
                            (let [selected (.. e -target -value)]
                              (when-not (= selected separator)
                                (swap! state assoc :scale selected))))}
      (doall
       (map-indexed
        (fn [idx scale-name]
          (let [opts (if (= separator scale-name) {:disabled true} {})]
            ^{:key (str "scale-option-" idx)}
            [:option (merge opts {:value scale-name}) scale-name])) scale-list))]]))

(defn octave-selector
  "Component to select in which octave the notes should be played."
  [state]
  [:div.octave.form-group
   [:label.control-label {:for "select-octave"} "Octave: "]
   [:select.form-control {:id "select-octave"
             :value (:octave @state)
             :on-change #(swap! state assoc :octave (js/parseInt (.. % -target -value)))}
    (doall
     (map
      (fn [octave]
        ^{:key (str "octave-" octave)}
        [:option octave]) (range scales/octaves)))]])

(defn note-cell
  "Component which renders a single note in the scale table display.
  Clicking on the note name will cause the note to be sounded using
  HTML5 Audio."
  [state idx note]
  ^{:key (str "note-" idx)}
  [:th.text-center {:on-click #(sounds/play (name note))
                    :style {:padding "4px"}}
   [:strong {:style {:font-weight "bold"
                     :font-size "1.1em"}}
    (scales/octave-note->note note)]])

(defn note-row
  "Renders the row in the scale table that displays the note names."
  [state note-seq]
  [:tr
   (doall
    (map-indexed (partial note-cell state) note-seq))])

(defn finger-cell
  "Renders a fingering representation for each note of the current scale
  for the currently selected instrument, if such a fingering chart is
  available."
  [state idx note]
  ^{:key (str "fingering-" idx)}
  [:td.text-center
   (let [fingers (get-in instrument/fingering
                         [(:instrument @state)
                          (scales/octave-note->note note)])]
     [:ul.list-unstyled
      (doall
       (map-indexed
        (fn [idx finger]
          ^{:key (str "finger-" idx)}
          [:li finger]) fingers))])])

(defn finger-row
  "Renders the row in the scale table that displays instrument fingerings."
  [state note-seq]
  [:tr
   (let [current-instrument (:instrument @state)]
     (if (get instrument/fingering current-instrument)
       (doall (map-indexed (partial finger-cell state) note-seq))
       [:td.text-center {:colSpan 8}
        (str "Fingering chart not yet available for " current-instrument)]))])

(defn scale-table
  "Renders a table containing the notes and fingerings for the currently selected
  major or minor scale for the chosen instrument."
  [state]
  (let [scale+type (name (:scale @state))
        type-idx   (- (count scale+type) 3)
        scale      (keyword (.substring scale+type 0 type-idx))
        scale-type (keyword (.substring scale+type type-idx))
        scale-fn   (scales/scale-type->fn scale-type)
        note-seq   (scale-fn scale (:octave @state) (:transposition @state))]
    [:div.panel.panel-default
     [:div.panel-heading
      [:strong {:style {:font-size "1.2em"}}
       (str (name (scales/octave-note->note (first note-seq)))
            (name scale-type) " Scale ")]
      (when-not (zero? (:transposition @state))
        [:span "(transposed)"])]
     [:div.panel-body
      "Click on the name of any note below to hear it played."
      [:div.table-responsive {:style {:margin-top "1em"}}
       [:table.table.table-striped.table-bordered
        [:tbody
         [note-row state note-seq]
         [finger-row state note-seq]]]]]]))

(defn application-header
  "Renders the title of the application"
  [state]
  [:div.page-header
   [:h1.title
    [:span "Scale, Transposition, and Fingering Chart"]]])

(defn application-footer
  "Renders the application copyright notice."
  [state]
  [:footer
   [:p.text-center (str "Copyright ©" (.getFullYear (js/Date.))  " Christian Romney and Sebastian Romney. ")
    [:a {:href "https://opensource.org/licenses/MIT"} "MIT License."] " "
    [:span "Source code available on " [:a {:href "https://github.com/christianromney/trumpet"} "Github."]]]])

(defn toolbar
  "The toolbar contains the controls that allow the user to change selections."
  [state]
  [:div.panel.panel-default
   [:div.panel-title
    ""]
   [:div.panel-body
    [:div#toolbar.row.form-inline
     [:div.col-md-2
      [instrument-selector state]]
     [:div.col-md-1
      [scale-selector state]]
     [:div.col-md-9
      [octave-selector state]]]]])

(defn transposition-alert
  "Displays an alert that the currently selected instrument is a transposing instrument."
  [state]
  [:div.transposition.row
   [:div.col-md-12
    (when-not (zero? (:transposition @state))
      [:div.alert.alert-info.text-center {:role "alert"}
       (str "The " (:instrument @state) " is a transposing instrument.")])]])

(defn main
  "This component renders all of the application's tools."
  [state]
  [:div.main {:style {:font-family "Roboto, sans-serif"}}
   [application-header state]
   [toolbar state]
   [transposition-alert state]
   [scale-table state]
   [application-footer state]])
