
(ns app.comp.group
  (:require-macros [respo.macros :refer [defcomp cursor-> div input span <>]])
  (:require [hsl.core :refer [hsl]]
            [respo-ui.style :as ui]
            [respo-ui.style.colors :as colors]
            [respo.core :refer [create-comp]]
            [respo.comp.inspect :refer [comp-inspect]]
            [respo.comp.space :refer [=<]]
            [app.comp.task-draft :refer [comp-task-draft]]
            [app.comp.task :refer [comp-task]]))

(def style-icon {:cursor :pointer})

(defn on-toggle-hidden [group-id]
  (fn [e dispatch!] (dispatch! :session/toggle-hidden group-id)))

(def style-draft {})

(defn on-edit-group [group-id]
  (fn [e dispatch!] (dispatch! :router/change {:name :group-editor, :params group-id})))

(def style-list {})

(def style-container {:width "100%"})

(def style-empty
  {:font-size 20, :font-weight 100, :font-family "Josefin Sans", :color colors/texture-light})

(def style-sidebar {:width 320})

(def style-name {:font-size 24, :font-weight 100, :font-family "Josefin Sans"})

(defn on-group-manage [group-id]
  (fn [e dispatch!] (dispatch! :router/change {:name :group-manager, :params group-id})))

(defcomp
 comp-group
 (states task-group show-done?)
 (div
  {:style (merge ui/row style-container)}
  (div
   {:style (merge ui/flex style-list)}
   (let [tasks (:tasks task-group), done-tasks (:done-tasks task-group)]
     (div
      {}
      (div {:style style-draft} (cursor-> :draft comp-task-draft states (:id task-group)))
      (=< nil 32)
      (if (empty? tasks)
        (div {:style style-empty} (<> span "No tasks" nil))
        (div
         {}
         (->> (vals tasks)
              (sort (fn [a b] (compare (:updated-time b) (:updated-time a))))
              (map (fn [task] [(:id task) (comp-task task)])))))
      (=< nil 32)
      (div
       {}
       (<> span "Done tasks:" nil)
       (=< 8 nil)
       (div
        {:style ui/clickable-text, :event {:click (on-toggle-hidden (:id task-group))}}
        (<> span "Toggle" nil)))
      (if (empty? done-tasks)
        (div {:style style-empty} (<> span (if show-done? "No tasks" "Hidden") nil))
        (div
         {}
         (->> (vals done-tasks)
              (sort (fn [a b] (compare (:updated-time b) (:updated-time a))))
              (map (fn [task] [(:id task) (comp-task task)]))))))))
  (div
   {:style style-sidebar}
   (div
    {:style style-name}
    (<> span (:name task-group) nil)
    (=< 8 nil)
    (span
     {:class-name "icon ion-md-create",
      :style style-icon,
      :event {:click (on-edit-group (:id task-group))}})
    (=< 8 nil)
    (span
     {:class-name "icon ion-md-people",
      :style style-icon,
      :event {:click (on-group-manage (:id task-group))}})))))
