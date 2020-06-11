(ns turnboss.components.extras
  (:use [hiccup.core :only [html]]
        [hiccup.util :only [as-str]]
        [hiccup.def :only [defelem]]
        [hiccup.element :only [unordered-list]]
        [hiccup.form :only [drop-down]]))

(defn lower-no-spaces [s]
  (clojure.string/replace (clojure.string/lower-case s) #" " "-"))
         
(def participant-roles ["Combat"
                        "Healing"
                        "Support"
                        "Specialist"])


(defelem role-selector [id]
  (drop-down id participant-roles))

(defelem npc-radio [t]
  [:input {:type "radio"
           :name "npc-type"
           :id (lower-no-spaces t)
           :class "npc-type"
           :value t
           :checked false} t])
         
(defn google-hosted-js-file [libr ver js-file]
  (str "https://ajax.googleapis.com/ajax/libs/" libr "/" ver "/" js-file))

(defn modal-form-footer [id button]
   [:div [:a {:href "#" :id id :class "btn btn-primary"} button]
    [:a {:href "#" :data-dismiss "modal" :class "btn"} "Close"]])

(defn modal-form [id title fields foot-map]
  [:div {:id id :class "modal hide fade"}
   [:div {:class "modal-header"}
    [:button {:class "close" :data-dismiss "modal" :type "button"} "esc"]
    [:h3 title]]
   [:div {:class "modal-body well form-horizontal"}
    [:div {:class "player-error-box"}]
    fields]
   [:div {:class "modal-footer"} foot-map]])

(defelem radio-with-controls [option]
  [:label {:class "radio"}
   (npc-radio option)])
         
(defn form-elem-with-controls [items]
  [:div {:class (str "control-group" " " (get items :id))}
   [:label {:class "control-label" :for (get items :id)} (get items :label)]
   [:div {:class "controls"}
    (get items :inputs)]])
         
(defn add-modal-link [link text]
  [:a {:id link :href link :data-toggle "modal"} text])

(defn add-player-link []
  (add-modal-link "#new-player-form" "Add Player"))

(defn add-npc-link []
  (add-modal-link "#new-npc-form" "Add NPC"))

(defn manage-roster-link []
  [:a {:href "/manage/roster"} "Manage Roster"])

(defn main-content-string []
  (unordered-list ["Keep your battles fast paced and controlled."
                   "Never lose track of your NPCs or Players"
                   "Monitor the status of everyone involved, never let a players movement penalty be forgotten again."
                   "Add some players and NPCs and get crushing!"]))