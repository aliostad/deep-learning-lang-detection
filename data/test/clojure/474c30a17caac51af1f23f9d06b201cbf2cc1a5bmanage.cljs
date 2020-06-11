(ns expense-tracker.account.manage
  (:require [reagent.core :as r]
            [expense-tracker.utils :as u]
            [expense-tracker.globals :as g]
            [expense-tracker.account.utils :as au]
            [expense-tracker.account.rm :as ar]
            [expense-tracker.transaction.utils :as tu]
            [clojure.string :as str]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; local states

(defn new-state [edit? nm parent init-bal]
  {:name nm :init-bal init-bal :bal 0 :parent parent :edit? edit?})
;; this state isn't local coz it can be modified from /core
(defonce app-state (r/atom (new-state nil "" nil nil)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; helpers

(defn name-ob [e]
  (let [val (str/lower-case (u/trim-empty? app-state (.-value (.-target e)) :name))
        parent (.-value (u/by-id "parent"))
        accs (au/accs->names @g/accounts)]
    (if (or (= val "")
            (not (empty? (filter #(= (str parent ":" val) %) accs))))
      (do (if (= val "")
            (u/alert "Account name cannot be empty!")
            (u/alert "An account with the same name (and parent) already exists!"))
          (swap! app-state assoc :name nil :parent parent))
      (swap! app-state assoc :name val :parent parent))))

(defn amt-ob [e t]
  (let [val (.-value (.-target e))]
    (if-let [f (u/amt-validate? val)]
      (swap! app-state assoc :bal (if (= val "") 0 f))
      (u/alert "Only numbers and decimal allowed!"))))

(defn acc-add [acc]
  (swap! g/accounts
         update-in (au/accs->indices (str/split (:parent acc) #":"))
         conj (dissoc acc :parent)))

(defn snn [e]
  (let [nm (:name @app-state)
        parent (.-value (u/by-id "parent"))
        bal (:bal @app-state)]
    (if (and nm parent bal)
      (do (when (:edit? @app-state)
            (let [old (:href (:attrs @g/app-page))
                  new (str parent ":" nm)]
              ;; update new name in transactions
              (tu/rename-acc old new)
              ;; replay transactions to update :bal in new acc
              (tu/replay new)
              ;; remove old account
              (ar/rm-acc old)))
          (acc-add {:name nm :parent parent :init-bal bal :bal bal})
          (reset! app-state (new-state nil "" nil nil)))
      (u/alert "Please correct errors first!"))))

(defn snd [e] (when (snn e) (reset! g/app-page {:page :home})))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; components and views

(defn c-add []
  (let [edit? (:edit? @app-state)]
    [:div [:div.form-group [:label "Parent Account"]
           (if edit?
             [:input.form-control {:type "text"
                                   :id "parent"
                                   :disabled true
                                   :value (:parent @app-state)}]
             [:select.form-control {:id "parent"
                                    :value (:parent @app-state)}
              (for [an (au/accs->names @g/accounts)]
                ^{:key (u/random)}[:option {:value an} an])])]
     [:div.form-group [:label "Account Name"]
      [:input.form-control {:type "text"
                            :id "name"
                            :placeholder (:name @app-state)
                            :onBlur name-ob}]]
     [:div.form-group [:label "Initial Balance"]
      [:input.form-control {:type "text" :id "init-bal"
                            :placeholder (:init-bal @app-state)
                            :onBlur amt-ob}]]
     [:div.row
      [:p]
      [:div.col-sm-6 [:button.btn.btn-default.pull-right {:onClick snd} "Save and Done"]]
      (when-not edit? [:div.col-sm-6
                       [:button.btn.btn-default
                        {:onClick (fn [e] (snn e)
                                    (u/alert "Added/edited account successfully!"))}
                        "Save and New"]])]]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; main

(defn edit [e] (swap! g/app-page assoc :page :acc-edit))
