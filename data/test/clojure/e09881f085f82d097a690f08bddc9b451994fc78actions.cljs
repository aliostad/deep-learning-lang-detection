(ns jmovedownoneline.actions
  (:require
   [re-frame.core :as re-frame]))

(defn upsert-status-id
  [id new-status-id]
  (re-frame/dispatch [:update-meme id new-status-id]))

(defn create-meme
  [new-meme-data]
  (re-frame/dispatch [:create-meme new-meme-data]))

(defn update-last-current
  []
  (re-frame/dispatch [:set-first-to-last]))

(defn toggle-volume
  []
  (re-frame/dispatch [:toggle-volume]))

(defn delete-meme
  [meme-id]
  (re-frame/dispatch [:delete-meme meme-id]))

(defn login
  []
  (re-frame/dispatch [:login]))

(defn logout
  []
  (re-frame/dispatch [:logout]))

(defn set-active-panel
  [panel]
  (re-frame/dispatch [:set-ui-active-panel panel]))

(defn set-delete-callback [callback]
  (re-frame/dispatch [:set-delete-callback callback]))

(defn set-login-callback [callback]
  (re-frame/dispatch [:set-login-callback callback]))

(defn  set-logout-callback [callback]
  (re-frame/dispatch [:set-logout-callback callback]))

(defn set-upsert-callback [callback]
  (re-frame/dispatch [:set-upsert-callback callback]))

(defn set-filter
  [filter]
  (re-frame/dispatch [:set-filter filter]))

(defn reset-db
  []
  (re-frame/dispatch [:initialize-db]))

(defn set-memes
  [new-memes]
  (re-frame/dispatch [:set-memes new-memes]))

(defn set-status [new-status]
  (re-frame/dispatch [:set-status new-status]))
