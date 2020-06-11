(ns birds.components.team
  (:require [pump :as pump]
            [react :as react]                      
            [birds.util :refer [log GET]]           
            [birds.history :as history]
            [birds.models.app :as state]
            [dommy.core :refer [listen! attr]]
            [birds.dom :as dom]
            [cljs.core.async :refer [chan <! >!]])
  (:require-macros [pump.macros :refer [defr] :as pump-macros]
                   [cljs.core.async.macros :refer [go]]))


(defn reducer [counter {:keys [bird-type count]}]
  (assoc counter bird-type (+ count (or (counter bird-type) 0))))

(defn user-sightings [member]
  (reduce reducer {} (:sightings member)))

(defn reducer* [counter m]
  (apply merge counter (map (fn [k]
                      {k (+ (m k) (or (counter k) 0))})
                    (keys m))))

(defn sightings [{:keys [members]}]
  (reduce reducer* {} (map user-sightings members)))

(defn team-member? [{id :id} team]
  (some #(= id (:id %)) (:members team)))

(defn remove-member [team user]
  (state/put-input! [:team :members] :remove :id (:id user)))

(defn add-member [team user]
  (state/put-input! [:team :members] :add :user user))

(defn remove-current-user [users {id :id}]
  (remove #(= (:id %) id) users))

(defr Team
  [component {:keys [user team current-user-team-status users] :as properties} state]
  (log team)
  [:div
   [:h2 (:name team)]
   [:h3 "Members"]
   [:ul
    (for [m (:members team)]
      [:li (:name m)])]
   [:h3 "Sightings"]
   [:ul
    (for [[bird-type count] (sightings team)]      
      [:li (str bird-type ": " count)])]
   (if (= :owner current-user-team-status)
     [:div
      [:h3 "Manage Members"]
      [:ul
       (for [u (remove-current-user users user)]
         (if (team-member? u team)
           [:li
            [:span (:name u)]
            [:a {:href "#"
                 :on-click (dom/kill-and-call remove-member team u)}
             " Remove"]]
           [:li
            [:span (:name u)]           
            [:a {:href "#"
                 :on-click (dom/kill-and-call add-member team u)}
             " Add"]]))]])])
