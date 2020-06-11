(ns bond-cljs.view.functions
  (:use-macros [dommy.macros :only [node deftemplate sel sel1]])
  (:require [clojure.string :as str]
            [dommy.utils :as utils]
            [dommy.core :as dommy]
            [bond-cljs.view.contacts-bar :as contacts-bar]
            [bond-cljs.theme :as theme]))

(defn render-page! [page]
  (dommy/append! (sel1 :body) page))

(defn sel-id [id]
  (sel1 (str "#" id)))

(defn replace-element! [id template]
  (dommy/replace-contents! (sel-id id) template))

(defn toggle-contacts-bar! []
  (dommy/toggle-class! (sel1 :body) "contacts-bar-expanded"))

(defn toggle-settings-bar! []
  (dommy/toggle-class! (sel1 :body) "settings-bar-expanded"))

(defn show-dev-tools! []
  (-> (js/require "nw.gui") (.-Window) (.get) (.showDevTools)))

(defn bind-events! []
  (Mousetrap/bind "ctrl+p" #(toggle-contacts-bar!))
  (Mousetrap/bind "ctrl+o" #(toggle-settings-bar!))
  (Mousetrap/bind "ctrl+u" #(show-dev-tools!))
  (Mousetrap/bind "ctrl+m" #(theme/play-theme!))
  (dommy/listen! (sel1 :#contacts-button) :click #(toggle-contacts-bar!))
  (dommy/listen! (sel1 :#settings-button) :click #(toggle-settings-bar!)))

(defn bind-event-stream! [event-stream]
  (let [chat-stream (.filter event-stream #(= (:type %) :message))
        status-stream (.filter event-stream #(= (:type %) :status-update))
        activity-stream (.filter event-stream #(= (:type %) :activity))
        roster-stream (.filter event-stream #(= (:type %) :roster))]
    (contacts-bar/react-to-status-stream status-stream)
    (contacts-bar/react-to-roster-stream roster-stream)))