(ns cider-ci.repository.push-hooks.ui
  (:require-macros
    [reagent.ratom :as ratom :refer [reaction]]
    [cljs.core.async.macros :refer [go]]
    )
  (:require
    [cider-ci.repository.ui.projects.shared :refer [humanize-datetime]]
    [cider-ci.repository.constants :refer [CONTEXT]]
    [cider-ci.repository.ui.request :as request]
    [cider-ci.repository.ui.state :as state]
    [cider-ci.repository.remote :refer [api-access?]]

    [cider-ci.utils.core :refer [presence]]
    [cider-ci.utils.url]

    [accountant.core :as accountant]
    [cljs.pprint :refer [pprint]]
    [reagent.core :as r]
    ))


;### helpers ##################################################################


(defn state [project]
  (cond
    (-> project :manage_remote_push_hooks not) "unmanaged"
    (-> project api-access? not) "unavailable"
    :else (-> project :push-hook :state)))

(defn color-class [project]
  (condp contains? (state project)
    #{"unmanaged" "initializing"} "default"
    #{"ok"} "success"
    #{"checking"} "executing"
    #{"error" "unavailable" "unaccessible"} "danger"
    "danger"))

(defn state-icon [project]
  (r/create-class
    {:component-did-mount #(.tooltip (js/$ (reagent.core/dom-node %)))
     :reagent-render
     (fn [project]
       (let [state (state project) ]
         [:a {:href "#" :data-toggle "tooltip" :title state :data-original-title state}
          [:span {:class state}
           (condp contains? state
             #{"unmanaged"} [:i.fa.fa-fw.fa-circle-o.text-muted]
             #{"ok"} [:i.fa.fa-fw.fa-check-circle.text-success]
             #{"checking"} [:i.fa.fa-fw.fa-refresh.fa-spin.text-warning]
             #{"error" "unavailable"}[:i.fa.fa-fw.fa-warning.text-danger]
             [:i.fa.fa-fw.fa-question-circle.text-warning])]]))}))

(defn path [project-or-id]
  (let [id (or (:id project-or-id) project-or-id)]
    (str CONTEXT "/projects/" id "/push-notifications")))


;### request response #########################################################

(defn set-up-push-notification [project]
  (let [id (-> project :id name)
        req {:url (str CONTEXT "/projects/" id "/push-hook")}]
    (request/send-off2
      req
      {:title (str "Set and Check Push Hook for \"" (:name project) "\"")})))


;### request response #########################################################

(defn set-up-push-notification-button [project]
  (let [title "Set up and check push hook now"]
    (r/create-class
      {:component-did-mount #(.tooltip (js/$ (reagent.core/dom-node %)))
       :reagent-render
       (fn [project]
         [:button.check-push-hook.btn.btn-default.btn-xs.pull-right
          {:on-click #(set-up-push-notification project)
           :data-toggle "tooltip" :title title
           :data-original-title title}
          [:i.fa.fa-gear]])})))

(defn th []
  [:th.text-center {:colSpan "1"}
   " Push-Hook " ])

(defn td [project]
  [:td.push-hook.text-center
   {:class (color-class project)
    :data-state (state project)
    :data-updated-at (-> project :push-hook :updated_at)}
   [:span [state-icon project]]
   [:span (condp contains? (state project)
            #{"ok"} [:span (when-let [at (-> project :push-hook :updated_at)]
                             (humanize-datetime (:timestamp @state/client-state) at))]
            (str " " (state project) " "))]
   [:span
    (when (not (contains? #{"unmanaged"} (state project)))
      [set-up-push-notification-button project])]])

(defn page-section [project]
  [:section.push-hooks
   [:h3 [:span [state-icon project]] "Push-Hook"]
   [:div
    (condp contains? (state project)
      #{"unavailable"} [:p.text-danger "The push-hook is set to be managed on the remote but the configuration is not sufficient to do so!"]
      #{"unmanaged"} [:p "The push-hook on the remote is neither managed nor checked!"]
      #{"error"} [:p.text-danger "The set-up of the push-hook failed!"]
      #{"ok"} [:p.text-success "The push-hook has been set up and checked "
               (when-let [at (-> project :push-hook :updated_at)]
                 (humanize-datetime (:timestamp @state/client-state) at)) "."]
      " "
      )]])

