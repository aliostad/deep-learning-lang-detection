(ns sane-tabber.settings.handlers
  (:require [re-frame.core :refer [register-handler dispatch]]
            [ajax.core :refer [POST]]
            [dommy.core :as dom :refer-macros [sel1]]
            [sane-tabber.utils :refer [id-value dispatch!]]
            [sane-tabber.generic.data :refer [get-by-id]]
            [sane-tabber.settings.subs :refer [filter-unused-users]]))

(register-handler
  :add-editor
  (fn [db [_ username]]
    (when (contains? (set (map :username (filter-unused-users (:users db) (:tournament db)))) username)
      (POST (str "/ajax/tournaments/" (:active-tournament db) "/editors/add")
            {:headers         {:x-csrf-token (:x-csrf-token db)}
             :params          {:id (:_id (get-by-id db :users username :username))}
             :handler         #(dispatch [:set-tournament %])
             :error-handler   #(dispatch [:error-resp %])
             :response-format :transit})
      (dom/set-value! (sel1 :#new-user-form) nil))
    db))

(register-handler
  :remove-editor
  (fn [db [_ id]]
    (POST (str "/ajax/tournaments/" (:active-tournament db) "/editors/remove")
          {:headers         {:x-csrf-token (:x-csrf-token db)}
           :params          {:id id}
           :handler         #(dispatch [:set-tournament %])
           :error-handler   #(dispatch [:error-resp %])
           :response-format :transit})
    db))