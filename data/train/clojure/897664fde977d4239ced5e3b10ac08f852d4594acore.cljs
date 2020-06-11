(ns cider-ci.repository.ui.projects.edit-new.core
  (:require-macros
    [reagent.ratom :as ratom :refer [reaction]]
    )
  (:require
    [cider-ci.repository.constants :refer [CONTEXT]]
    [cider-ci.repository.ui.projects.edit-new.fetching :as edit-new.fetching]
    [cider-ci.repository.ui.projects.edit-new.triggers :as edit-new.triggers]
    [cider-ci.repository.ui.projects.edit-new.api :as edit-new.api]
    [cider-ci.repository.ui.projects.edit-new.basics :as edit-new.basics]
    [cider-ci.repository.ui.projects.edit-new.permissions :as edit-new.permissions]
    [cider-ci.repository.ui.request :as request]
    [accountant.core :as accountant]

    [cider-ci.repository.ui.state :as state]
    [cider-ci.repository.ui.projects.edit-new.shared :refer [id project form-data update-form-data update-form-data-value]]
    [reagent.core :as r]
    ))


(defn form-component []
  [:div.form
   [edit-new.basics/component]
   [edit-new.permissions/component]
   [edit-new.api/component]
   [edit-new.fetching/component]
   [edit-new.triggers/component]
   [:hr]])

(defn send-form-data []
  "If @id is set patches and otherwise posts the form data."
  (let [req {:method  (if @id :patch :post)
             :json-params @form-data
             :url (str CONTEXT "/projects/" @id)}]
    (request/send-off2
      req {:title (if @id
                    (str "Update project \"" (:name @project) "\"")
                    (str "Create new project"))}
      :callback (fn [resp]
                  (case (:status resp)
                    200 (accountant/navigate!
                          (str CONTEXT "/projects/" @id))
                    201 (let [id (-> resp :body :id)
                              path (str CONTEXT "/projects/" id)]
                          (accountant/navigate! path)))))))

(def form-valid?
  (reaction (and @edit-new.basics/git-url-valid?
                 @edit-new.basics/name-valid?
                 @edit-new.fetching/remote-fetch-interval-valid?)))

(defn cancel-submit-component []
  [:div.form-group.row
   [:div.col-xs-6 [:a.btn.btn-warning {:href (str CONTEXT "/projects/" (or @id ""))} [:i.fa.fa-arrow-circle-left] " Cancel "]]
   [:div.col-xs-6 [:button.pull-right.btn.btn-primary (merge {:type :submit :on-click send-form-data} (when (not @form-valid?) {:disabled "yes"})) "Submit"]]
   ])

;##############################################################################
;### new ######################################################################
;##############################################################################

(defn reset-for-new-state! []
  (update-form-data
    (fn [_]
      {:git_url  nil; "https://github.com/cider-ci/cider-ci_demo-project-bash.git"
       :name nil; "cider-ci_demo-project-bash"
       ;:remote_api_type "github"
       :remote_fetch_interval "1 Minute"
       :branch_trigger_include_match "^.*$"
       :branch_trigger_exclude_match ""
       :branch_trigger_max_commit_age "12 hours"
       :send_status_notifications true
       :manage_remote_push_hooks false
       })))

(defn new-page []
  (r/create-class
    {:component-will-mount reset-for-new-state!
     :reagent-render
     (fn []
       [:div
        [:ol.breadcrumb
         [:li [:a {:href "/cider-ci/ui/public"} "Home"]]
         [:li [:a {:href (str CONTEXT "/projects/")} "Projects"]]
         [:li "Add a new project"]]
        [:div [:h1 "Add a new project"]]
        [form-component]
        [cancel-submit-component]])}))

;##############################################################################
;### edit #####################################################################
;##############################################################################

(defn reset-for-edit-state! []
  (update-form-data
    (fn [_]
      (select-keys
        @project
        [:branch_trigger_exclude_match
         :branch_trigger_include_match
         :branch_trigger_max_commit_age
         :git_url
         :id
         :manage_remote_push_hooks
         :name
         :public_view_permission
         :remote_api_endpoint
         :remote_api_name
         :remote_api_namespace
         :remote_api_token
         :remote_api_token_bearer
         :remote_api_type
         :remote_fetch_interval
         :send_status_notifications
         :update_notification_token]))))


(defn edit []
  (r/create-class
    {:component-will-mount reset-for-edit-state!
     :reagent-render
     (fn []
       [:div
        [:ol.breadcrumb
         [:li [:a {:href "/cider-ci/ui/public"} "Home"]]
         [:li [:a {:href (str CONTEXT "/projects/")} "Projects"]]
         [:li [:a {:href (str CONTEXT "/projects/" @id)} "Project"]]
         [:li "Edit project"]]
        [:div [:h1 "Edit project \""  (-> @project :name) "\""]]
        [form-component]
        [cancel-submit-component]
        ])}))



