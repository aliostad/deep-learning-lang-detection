
(ns app.actions
  (:require
    [clojure.string :refer [blank?]]))

(defn try-add-todo [*cursor* state]
  (fn [e dispatch!]
    (if
      (and
        (= (:key-code e) 13)
        (not (blank? (:text state))))
      (do
        (dispatch! :add-todo (:text state))
        (dispatch! :states [*cursor* (assoc state :text "")])))))

(defn add-todo [e dispatch!]
  (dispatch! :add-todo nil))

(defn input-keyup [id *cursor* state]
  (fn [e dispatch!]
    (cond
      (= (:key-code e) 13)
      (if (blank? (:text state))
        (dispatch! :delete-todo id)
        (do
          (dispatch! :edit-todo [id (:text state)])
          (dispatch! :states [*cursor* (assoc state :editing false)])))
      (= (:key-code e) 27)
      (dispatch! :states [*cursor* (assoc state :editing false)])
      :else nil)))

(defn delete-todo [id]
  (fn [e dispatch!]
    (dispatch! :delete-todo id)))

(defn toggle-todo [od]
  (fn [e dispatch!]
    (dispatch! :toggle-todo od)))

(defn toggle-all [e dispatch!]
  (dispatch! :toggle-all nil))

(defn clear-completed [e dispatch!]
  (dispatch! :clear-completed nil))
