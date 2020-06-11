(ns zombunity.gui
  (:require [zombunity.dom-helper :as helper]
            [zombunity.dispatch :as dispatch]
            [zombunity.menu :as menu]
            [clojure.string :as string]))

(defn connect []
  (dispatch/dispatch :connect nil))

(defn disconnect []
  ;(js/alert "Disconnecting!")
  (dispatch/dispatch :disconnect nil))

(defn display-text
  "Display any :text event text in the generic 'text' area"
  [text]
  (helper/insert_text_node "text" text))

(defn text-key-up
  "Send text to the server"
  [event]
  (if (= (.-keyCode event) 13)
    (do
      (dispatch/dispatch :input (helper/get-value "mud-input"))
      (helper/clear "mud-input"))))

(defn get-menu-data
  "break a pipe-delimited string into a title and list of items"
  [s]
  (let [items (doall (filter (fn [x] (not (= x "|"))) (string/split s (js/RegExp. "\\|" ""))))]
    items))

(defn send-text
  "Send the specified text to the server"
  [text]
  (dispatch/dispatch :input text))

(defn send
  "Send text to the server"
  []
  (dispatch/dispatch :input (helper/get-value "mud-input")))

(defn display-menu
  "Display a menu using a function for onClick"
  [msg]
  (helper/insert-child "some_id" (menu/menu (:title msg) (:items msg) send-text)))

(defn create-debug-menu
  "Take the text from input and create a menu from it"
  []
  (let [items (get-menu-data (helper/get-value "mud-input"))]
    ;(helper/insert-text-node "text" (first items))
    ;(helper/insert-text-node "text" (str (second items) "," (nth items 2)))
    (helper/insert-child "text" (menu/menu (first items) (rest items) send-text))))

(defn text
  "Testing out a local event"
  []
  ;(js/alert (str "Value of the text area: " (helper/get-value "text")))
  (dispatch/dispatch :text (helper/get-value "mud-input")))

(defn show-connected
  "Flips 'disconnected' to 'connected'"
  [_]
  ;(js/alert "Show connected called")
  (let [elem (helper/get-element "conn-disconn-flg")]
    (set! (.-innerHTML elem) "connected")
    (.setProperty (.-style elem) "color" "green"))
  (let [elem (helper/get-element "conn-disconn-btn")]
    (set! (.-innerText elem) "disconnect")
    (set! (.-onclick elem) disconnect)))

(defn show-disconnected
  "Flips 'connected' to 'disconnected'"
  [_]
  (let [elem (helper/get-element "conn-disconn-flg")]
    (set! (.-innerHTML elem) "disconnected")
    (.setProperty (.-style elem) "color" "red"))
  (let [elem (helper/get-element "conn-disconn-btn")]
    (set! (.-innerText elem) "connect")
    (set! (.-onclick elem) connect)))

(defn register-listeners
  "Called by .core to register listeners for events we're interested in"
  []
  (dispatch/register-listener :message display-text)
  (dispatch/register-listener :text display-text)
  (dispatch/register-listener :conn-open show-connected)
  (dispatch/register-listener :conn-close show-disconnected)
  (dispatch/register-listener :menu display-menu))

(defn debug-mode
  "Unregister the websocket listeners and register mock listeners in there place"
  []
  (dispatch/unregister-listeners :input)
  (dispatch/register-listener :input display-text))
